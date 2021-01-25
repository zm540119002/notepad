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

## 解决git pull --rebase产生的冲突方法

```
1 git rebase --abort (放弃本次拉取，会退出到自己最后一次本地提交的状态)

2 查询日志，看自己最后一次修改的文件有哪些。备份起来。

3 git reset --hard HEAD~1 回退到上一次提交前状态

4 git pull --rebase 重新拉远程更新
```



# 分支

```
1.查看一下本地分支
    git branch;
    查看本地和远程的所有分支
    git branch -a
2.新建一个本地的分支
    git branch -b newbranch   //这个命令是新建一个分支，并切换到该分支上去
    （git branch newbranch;     git checkout newbranch）这两个命令合起来等同于上面的一个命令
3.新建一个远程分支（同名字的远程分支）
    git push origin newbranch:newbranch   //创建了一个远程分支名字叫 newbranch
4.把本地的新分支，和远程的新分支关联
    git push --set-upstream origin newbranch
这时就可以在这个分支下使用 git pull 推送到远程的新分支上了

示例：
本地：
	git checkout -b dm8
	git push origin dm8:dm8
	git push origin v0.8:v0.8
其他git：
	git checout -b dm8
```

## checkout

```
示例：当前分支：master
    git checkout -b hz origin/master
    git push origin hz:hz
其他人：
    git checkout -b hz origin/hz
    报错解决详见：git 命令行拉去远程的非master分支报错
注意
    git checkout -b newbranch	//从本地拉取代码创建新的分支，并切换到新的分支
    git checkout -b newbranch origin/newbranch //从远程拉取代码创建新的分支，并切换到新的分支
```

## 删除分支

```
删除本地分支：
	git branch -D dm8
删除远程分支：
	git push origin --delete hz
```

# 工作流

```
参考：	https://blog.csdn.net/qq_35865125/article/details/80049655
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
	（1） git push -u origin master 如果当前分支与多个主机存在追踪关系，则可以使用 -u 参数指定一个默认主机，这样后面就可以不加任何参数使用git push，
不带任何参数的git push，默认只推送当前分支，这叫做simple方式，还有一种matching方式，会推送所有有对应的远程分支的本地分支， Git 2.0之前默认使用matching，现在改为simple方式
如果想更改设置，可以使用git config命令。git config --global push.default matching OR git config --global push.default simple；可以使用git config -l 查看配置
	（2） git push --all origin 当遇到这种情况就是不管是否存在对应的远程分支，将本地的所有分支都推送到远程主机，这时需要 -all 选项
	（3） git push --force origin git push的时候需要本地先git pull更新到跟服务器版本一致，如果本地版本库比远程服务器上的低，那么一般会提示你git pull更新，如果一定要提交，那么可以使用这个命令。
	（4） git push origin --tags //git push 的时候不会推送标签，如果一定要推送标签的话那么可以使用这个命令

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
```

## git stash

```
# 暂时将未提交的变化移除，稍后再移入
$ git stash
$ git stash pop
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

