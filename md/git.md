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

```
git checkout --patch master audit_config
```

