# 常见错误

## git 命令行拉去远程的非master分支报错

当使用git进行操作：

git checkout -b local-name origin/remote-name

出现错误：

fatal: git checkout: updating paths is incompatible with switching branches.
Did you intend to checkout ‘origin/remote-name’ which can not be resolved as commit?

解决办法：

```
git remote show origin
git remote update
git fetch
git checkout -b local-name origin/remote-name
```

## git pull --rebase产生的冲突解决方法

```
解决方案一：
    1 git rebase --abort (放弃本次拉取，会退出到自己最后一次本地提交的状态)
    2 查询日志，看自己最后一次修改的文件有哪些。备份起来。
    3 git reset --hard HEAD~1 回退到上一次提交前状态（注意：自己本次修改全部丢失，小心！）
    4 git pull --rebase 重新拉远程更新
    5 使用beyond compare，比较备份的文件和现在工程文件，增量修改

解决方案二：（未实践）
    定位到冲突文件
    手动解决冲突
    执行git add .
    执行git rebase --continue
    此时执行git status 看下当前在那个分支上，如果在临时分支上，则需要执行git branch
    执行git push即可完成
```

# 散点知识

```

```

## git push和git pull的默认行为

```
我们本该输入git pull origin <branch>或者git push origin <branch>时，我们只想输入git pull或者git push，这个就可以叫做git pull 与git push 的默认行为。

git的全局配置中，有一个push.default属性，其决定了git push操作的默认行为。在Git 2.0之前，这个属性的默认被设为'matching'，2.0之后则被更改为了'simple'。

我们可以通过git version确定当前的git版本（如果小于2.0，更新是个更好的选择），通过git config --global push.default 'option'改变push.default的默认行为（或者也可直接编辑~/.gitconfig文件）。

push.default 有以下几个可选值：
nothing, current, upstream, simple, matching

nothing - push操作无效，除非显式指定远程分支，例如git push origin develop（我觉得。。。可以给那些不愿学git的同事配上此项）。

current - push当前分支到远程同名分支，如果远程同名分支不存在则自动创建同名分支。

upstream - push当前分支到它的upstream分支上（这一项其实用于经常从本地分支push/pull到同一远程仓库的情景，这种模式叫做central workflow）。

simple - simple和upstream是相似的，只有一点不同，simple必须保证本地分支和它的远程
upstream分支同名，否则会拒绝push操作。

matching - push所有本地和远程两端都存在的同名分支。

因此如果我们使用了git2.0之前的版本，push.default = matching，git push后则会推送当前分支代码到远程分支，而2.0之后，push.default = simple，如果没有指定当前分支的upstream分支，就会收到上文的fatal提示。

upstream & downstream
说到这里，需要解释一下git中的upstream到底是什么：

git中存在upstream和downstream，简言之，当我们把仓库A中某分支x的代码push到仓库B分支y，此时仓库B的这个分支y就叫做A中x分支的upstream，而x则被称作y的downstream，这是一个相对关系，每一个本地分支都相对地可以有一个远程的upstream分支（注意这个upstream分支可以不同名，但通常我们都会使用同名分支作为upstream）。

git pull的默认行为和git push完全不同。当我们执行git pull的时候，实际上是做了git fetch + git merge操作，fetch操作将会更新本地仓库的remote tracking，也就是refs/remotes中的代码，并不会对refs/heads中本地当前的代码造成影响。

当我们进行pull的第二个行为merge时，对git来说，如果我们没有设定当前分支的upstream，它并不知道我们要合并哪个分支到当前分支，所以我们需要通过下面的代码指定当前分支的upstream：

git branch --set-upstream-to=origin/<branch> develop
// 或者git push --set-upstream origin develop 
实际上，如果我们没有指定upstream，git在merge时会访问git config中当前分支(develop)merge的默认配置，我们可以通过配置下面的内容指定某个分支的默认merge操作

[branch "develop"]
    remote = origin
    merge = refs/heads/develop // [1]为什么不是refs/remotes/develop?
或者通过command-line直接设置：

git config branch.develop.merge refs/heads/develop
这样当我们在develop分支git pull时，如果没有指定upstream分支，git将根据我们的config文件去merge origin/develop；如果指定了upstream分支，则会忽略config中的merge默认配置。
```



# 分支

```
同步远程分支
    git fetch 将本地分支与远程保持同步
    git checkout -b 本地分支名x origin/远程分支名x 拉取远程分支并同时创建对应的本地分支
同步所有远程分支，如下：
	git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done

将本地所有分支与远程保持同步 
	git fetch --all

最后拉取所有分支代码 
	git pull --all

```

## 查看

```
查看本地仓库的本地分支
    git branch
查看本地仓库的远程分支
    git branch -r
查看本地仓库的所有分支
    git branch -a
    
实时的远程仓库的分支信息
	git remote show origin
	
注意：
	git branch -a 输出的是本地仓库的远程分支信息，而git remote show origin需要联网输出实时的远程仓库的分支信息。
	解决方法：git fetch origin  //从远程仓库更新信息

```

## 创建&检出

```
使用git branch <branch name>命令创建一个新的分支。
可以从现有的分支创建一个新的分支。 也可以使用特定的提交或标签作为起点创建分支。 
如果没有提供任何特定的提交ID，那么将以HEAD作为起点来创建分支:
	$ git branch new_branch
	
切换分支使用git checkout命令在分支之间切换。
	$ git checkout new_branch

创建和切换分支的快捷方式:
	$ git checkout -b test_branch

//从本地拉取代码创建新的分支，并切换到新的分支
	git checkout -b newbranch	

//从远程拉取代码创建新的分支，并切换到新的分支
    git checkout -b newbranch origin/远程分支名 | git checkout --track origin/远程分支名 | git checkout -t origin/远程分支名

把本地的新分支，和远程的新分支关联
    git push --set-upstream origin newbranch
    
示例：当前分支：master
    git checkout -b newbranch origin/远程分支名
    git push origin newbranch:newbranch
其他人：
    git checkout -b newbranch

```

## 删除

```
删除分支 ： 如分支名为dev
    git branch -d dev 会在删除前检查merge状态（其与上游分支或者与head）。
    git branch -D dev 它会直接删除,不检查

删除远程分支
	git push origin --delete dev

清理本地不存在的远程分支，如别人删除了dev,但是你本地查看还有，就可以执行该条命令
	git remote prune origin
	
注意：
	删除现有分支之前，请切换到其他分支。
	删除分支命令，有 git branch -d 和 git branch -D，-D 表示强制删除。
	如果本地分支没有合并到其他分支，或者没有对应的远程分支，删除时则会提示这个错误。
	直接选择强制删除即可。
```

## 重命名

```
1、本地分支重命名
 	git branch -m oldName  newName
2、将重命名后的分支推送到远程
	git push origin newName
3、删除远程的旧分支
	git push --delete origin oldName
	
显示如下，说明删除成功
To http://11.11.11.11/demo/demo.git
 - [deleted]           oleName
```

## 合并

```

```



# 工作流（分支管理策略）

https://blog.csdn.net/qq_35865125/article/details/80049655
https://blog.csdn.net/qq_32452623/article/details/78905181

```

```

# 常用命令

## git checkout

```
git checkout --patch master audit_config

这时分两种情况。一种情况是，你需要另一个分支的所有代码变动，那么就采用合并（git merge）。另一种情况是，你只需要部分代码变动（某几个提交），这时可以采用 Cherry pick。

git cherry-pick命令的作用，就是将指定的提交（commit）应用于其他分支。


$ git cherry-pick <commitHash>
上面命令就会将指定的提交commitHash，应用于当前分支。这会在当前分支产生一个新的提交，当然它们的哈希值会不一样。

举例来说，代码仓库有master和feature两个分支。
```

## git push

```
git push <远程主机名> <本地分支名>  <远程分支名> 
	例如：	git push origin master:refs/for/master
	即是将本地的master分支推送到远程主机origin上的对应master分支
	origin 是远程主机名，第一个master是本地分支名，第二个master是远程分支名。
1.1 git push origin master
	如果远程分支被省略，如上则表示将本地master分支推送到与之存在追踪关系的远程分支（通常两者同名），如果该远程分支不存在，则会被新建

1.2 git push origin :refs/for/master 
	如果省略本地分支名，则表示删除指定的远程分支，因为这等同于推送一个空的本地分支到远程分支，等同于 git push origin --delete master

1.3 git push origin
	如果当前分支与远程分支存在追踪关系，则本地分支和远程分支都可以省略，将当前分支推送到origin主机的对应分支 

1.4 git push
	如果当前分支只有一个远程分支，那么主机名都可以省略，形如 git push，可以使用git branch -r ，查看远程的分支名

1.5 git push 的其他命令
	这几个常见的用法已足以满足我们日常开发的使用了，还有几个扩展的用法，如下：
	（1） git push -u origin master 
        如果当前分支与多个主机存在追踪关系，则可以使用 -u 参数指定一个默认主机，这样后面就可以不加任何参数使用git push，
        不带任何参数的git push，默认只推送当前分支，这叫做simple方式，还有一种matching方式，会推送所有有对应的远程分支的本地分支， 
        Git 2.0之前默认使用matching，现在改为simple方式
        如果想更改设置，可以使用git config命令。
        git config --global push.default matching OR git config --global push.default simple；
        可以使用git config -l 查看配置
	（2） git push --all origin 
		当遇到这种情况就是不管是否存在对应的远程分支，将本地的所有分支都推送到远程主机，这时需要 -all 选项
	（3） git push --force origin 
		git push的时候需要本地先git pull更新到跟服务器版本一致，如果本地版本库比远程服务器上的低，
		那么一般会提示你git pull更新，如果一定要提交，那么可以使用这个命令。
	（4） git push origin --tags 
		//git push 的时候不会推送标签，如果一定要推送标签的话那么可以使用这个命令

1.6 关于 refs/for
	// refs/for 的意义在于我们提交代码到服务器之后是需要经过code review 之后才能进行merge的，而refs/heads 不需要
```

## git pull

```
git pull命令用于从另一个存储库或本地分支获取并集成(整合)。
git pull命令的作用是：取回远程主机某个分支的更新，再与本地的指定分支合并，它的完整格式稍稍有点复杂。
使用语法
    git pull [options] [<repository> [<refspec>…]]
    git pull <远程主机名> <远程分支名>:<本地分支名>

描述
	将远程存储库中的更改合并到当前分支中。
	在默认模式下，git pull是git fetch后跟git merge FETCH_HEAD的缩写。
	更准确地说，git pull使用给定的参数运行git fetch，并调用git merge将检索到的分支头合并到当前分支中。 
	使用--rebase，它运行git rebase而不是git merge。

比如，要取回origin主机的next分支，与本地的master分支合并，需要写成下面这样 -
	$ git pull origin next:master

如果远程分支(next)要与当前分支合并，则冒号后面的部分可以省略。上面命令可以简写为：
	$ git pull origin next

上面命令表示，取回origin/next分支，再与当前分支合并。实质上，这等同于先做git fetch，再执行git merge。
    $ git fetch origin
    $ git merge origin/next


```

## git reset

```
# 重置暂存区的指定文件，与上一次commit保持一致，但工作区不变
$ git reset [file]

# 重置暂存区与工作区，与上一次commit保持一致
$ git reset --hard

# 重置当前分支的指针为指定commit，同时重置暂存区，但工作区不变
$ git reset [commit]

# 重置当前分支的HEAD为指定commit，同时重置暂存区和工作区，与指定commit一致
$ git reset --hard [commit]

# 重置当前HEAD为指定commit，但保持暂存区和工作区不变
$ git reset --keep [commit]

---------------------
git reset --hard HEAD
    修改了代码，但不想提交，（或者遴选提交点出现冲突），要全部还原 可以用这个命令

    解决git pull --rebase产生的冲突方法：

    1 git rebase --abort (放弃本次拉取，会退出到自己最后一次本地提交的状态)

    2 查询日志，看自己最后一次修改的文件有哪些。备份起来。

    3 git reset --hard HEAD~1 回退到上一次提交前状态

    4 git pull --rebase 重新拉远程更新

    5 使用beyond compare，比较备份的文件和现在工程文件，增量修改
```

## git stash

```
（1）git stash save "save message"  : 执行存储时，添加备注，方便查找，只有git stash 也要可以的，但查找时不方便识别。

（2）git stash list  ：查看stash了哪些存储

（3）git stash show ：显示做了哪些改动，默认show第一个存储,如果要显示其他存贮，后面加stash@{$num}，比如第二个 git stash show stash@{1}

（4）git stash show -p : 显示第一个存储的改动，如果想显示其他存存储，命令：git stash show  stash@{$num}  -p ，比如第二个：git stash show  stash@{1}  -p

（5）git stash apply :应用某个存储,但不会把存储从存储列表中删除，默认使用第一个存储,即stash@{0}，如果要使用其他个，git stash apply stash@{$num} ， 比如第二个：git stash apply stash@{1} 

（6）git stash pop ：命令恢复之前缓存的工作目录，将缓存堆栈中的对应stash删除，并将对应修改应用到当前的工作目录下,默认为第一个stash,即stash@{0}，如果要应用并删除其他stash，命令：git stash pop stash@{$num} ，比如应用并删除第二个：git stash pop stash@{1}

（7）git stash drop stash@{$num} ：丢弃stash@{$num}存储，从列表中删除这个存储

（8）git stash clear ：删除所有缓存的stash

git add 
如果过后不需要缓存，删除所有缓存的stash：
git stash clear
```

## git revert

```
# 新建一个commit，用来撤销指定commit
# 后者的所有变化都将被前者抵消，并且应用到当前分支
$ git revert [commit]
```



## git branch

```
git branch -a
git branch -r

查看本地的分支与远程分支之间的追踪关系
	git branch -vv

建立本地的分支与远程分支之间的追踪关系:
	$ git branch --set-upstream master origin/next

上面命令指定master分支追踪origin/next分支。
如果当前分支与远程分支存在追踪关系，git pull就可以省略远程分支名。
	$ git pull origin

上面命令表示，本地的当前分支自动与对应的origin主机”追踪分支”(remote-tracking branch)进行合并。
如果当前分支只有一个追踪分支，连远程主机名都可以省略。
	$ git pull

上面命令表示，当前分支自动与唯一一个追踪分支进行合并。
如果合并需要采用rebase模式，可以使用–rebase选项。
	$ git pull --rebase <远程主机名> <远程分支名>:<本地分支名>

1】远程有上游分支，但是本地没有相应的跟踪分支时候，此时会在本地建立一个和远程上游分支同名的分支
	git checkout --track origin/上游分支
2】远程有上游分支，但是本地没有相应的追踪分支，想建立一个与上游分支不同名称的分支
	git checkout -b 本地自定义跟踪分支名称 origin/上游分支
3】本地有个跟踪分支，远程有一个目标分支，想让本地的分支跟踪这个目标分支
	git branch --set-upstream-to origin/目标分支
	git branch --set-upstream-to=origin/remote_branch  your_branch
4】本地有一个跟踪分支，远程没有目标分支，想在远程建立一个目标分支，并建立本地跟踪分支与新建远程分支之间的跟踪关系
	git push --set-upstream origin 本地跟踪分支/远程新建目标分支名称
```

## git tag 

```
git tag -d v1.0
git push origin --delete v1.0

如果tag已经被推送到远程仓库，再删除tag就麻烦一点，需要先在本地删除之后再使用push推送到远程。
    git tag -d < tag_name>
    git push origin :refs/tags/< tag_name>
示例：
    git tag -d v0.8
    git push origin :refs/tags/v0.8
    
删除远程标签时遇到的问题
起因： 
	由于每次上线都会打一个标签，因此标签库存在多个标签。想要删除全部的无效标签。 
	结果执行完毕删除远程标签和删除本地标签后。 发现其他同事再次推送的时候， 删除的那些标签又莫名其妙的回来了。
原因: 
	这是因为其他同事的本地标签没有清理，这时候就必须要其他同事全部都要清理本地的标签。 (很显然这行不通，很难。)
解决办法：
    使用 git tag -l | xargs -n 1 git push --delete origin 命令一条一条的删除远程仓库.
    然后再用 git tag -l | xargs git tag -d 清理本地仓库。 (此方法楼主已经测试并且可用) 。

示例： 
	git tag -l | xargs -n 1 git push --delete origin
	git tag -l | xargs git tag -d
（亲测没用）
```

## git config

```
git config --list
```

