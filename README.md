## 基于 vimim 的形码输入法

[原版插件地址](https://www.vim.org/scripts/script.php?script_id=2506)
[原精简版插件地址](https://github.com/yuweijun/vim-wb)

本仓库为 vimim 插件的再次精简，仅用于作者个人的挂载码表方案的形码输入法的小众需求

刚刚 fork 完，还没开始改，

*暂时请勿下载本插件*

*暂时请勿下载本插件*

*暂时请勿下载本插件*

原输入法 vimim 功能很强大，支持云输入法与多种输入法方案，我计划将插件简化到仅支持挂载形码码表输入法的程度，谨慎选择

## 计划完成目标

- [ ] 添加设置项，用于设定全角/半角符号等
- [ ] 提供翻页与二选三选（四选）的配置项
- [ ] 修复 normal 模式下的符号问题
- [x] 删除拼音、双拼及其他输入法的部分，精简代码
- [ ] 多编码格式的支持（？）

待项目初步修改完成后，计划增加对于码表的修改支持，包括：
- [ ] 添加自造词
- [ ] 删除码表中的废词
- [ ] 词频设置选项与修改
- [ ] 码表过滤
- [ ] 字根查询
- [ ] lua 重构与支持

## 配置

在`.vimrc`配置文件中加入以下配置，避免输入法状态下搜索功能按键显示有问题：

```vim
set imsearch=0
```

## 输入法切换

目前仍是原 vimim-wb 的简化程度，使用的是作者正在使用的宇浩输入法，可以从[这里](https://code.google.com/archive/p/vimim/downloads?page=2)下载其他输入法码表，用以替换宇浩输入法

使用[宇浩输入法v2.4.8](https://github.com/forFudan/yuhao)的 baidu 的简体简码码表，并进行了一定程度的修改，修改细节见[文档](./mabiao_diff.md)

## 使用

在普通或者插入模式中按快捷键`Ctrl-J`，也就是`Ctrl` + `Shift` + `J`，就可以输入中文了

使用方括号翻页，空格选择首个匹配项，分号选择第二匹配项，引号选择第三匹配项，tab 选择第四匹配项

<!-- more -->

## 与英文混排输入的问题

一般在输入英文单词前后用空格与中文字符分隔开来，如果需要中英文混排并且不要插入空格的话，则在输入英文单词之后按回车符，则英文词上屏后就可以接着输入中文了。

### vim-space 插件

原 vim-wb 作者还制作了一个处理中英文之间空格的插件，见 [vim 插件](https://github.com/yuweijun/vim-space.git)

