# vscode-remote-node

针对国内网络预先完成apt下载，内置cnpm国内源的vscode node开发用容器

本项目中的Dockerfile由[微软范例node开发容器](https://github.com/Microsoft/vscode-remote-try-node)中提取后修改

相较于原本的Dockerfile，做了如下修改

- 通过apt多安装了zsh less locales git-flow vim这五个组件
- 安装了oh-my-zsh
- ~~将所有涉及apt的操作合为一句RUN以避免缓存文件出现在docker的层叠卷中~~ 官方也已经合并
- 生成了中文locale支持，在终端中中文的输入与输出都不会乱码了
- 安装了nrm，并用其将npm的registry切换为cnpm
- 安装了yrs，并用其将yarn的registry切换为cnpm
- 时区设置为+0800
- 设置默认shell为zsh
