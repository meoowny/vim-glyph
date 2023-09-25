## 说明

这是作者在阅读原代码时留的记录

## 函数外流程疏理

-- init

if exists("g:Vimim_profile") || &iminsert == 1 || v:version < 700
    finish
elseif &compatible
    call s:vimim_bare_bones_vimrc()
endif

scriptencoding utf-8
let g:Vimim_profile = reltime()
let s:plugin = expand("<sfile>:p:h")

-- mode: chinese

let s:translators = {}
function! s:translators.translate(english) dict

-- core driver

sil!call s:vimim_initialize_global()
sil!call s:vimim_dictionary_punctuations()
sil!call s:vimim_dictionary_keycodes()
sil!call s:vimim_super_reset()
sil!call s:vimim_set_backend_embedded()
sil!call s:vimim_set_im_toggle_list()
sil!call s:vimim_plug_and_play()
:let g:Vimim_profile = reltime(g:Vimim_profile)

## 函数疏理

let s:VimIM += [" ====  initialization   ==== {{{"]
" =================================================

主要调用者：脚本末尾，s:vimim_start()

function! s:vimim_bare_bones_vimrc()  (初始化 vim 全局设置)
function! s:vimim_initialize_global()  (初始化插件脚本设置)
function! s:vimim_dictionary_keycodes()  (疑似选择输入方案)
仅在脚本末尾初始化时调用

function! s:vimim_set_frontend()
<- function! g:Vimim_cycle_vimim()
<- function! s:vimim_start()

function! s:vimim_set_global_default()
<- s:vimim_initialize_global

function! s:vimim_cache()
<- function! VimIM(start, keyboard)

" ============================================= }}}
let s:VimIM += [" ====  user interface   ==== {{{"]
" =================================================

符号设置，仅在脚本末尾初始化时调用
function! s:vimim_dictionary_punctuations()

function! g:Vimim_bracket(offset)
function! s:vimim_get_label(label)
function! s:vimim_set_pumheight()
function! s:vimim_im_chinese()

function! g:Vimim_esc()
<- function! s:vimim_start()

" ============================================= }}}
let s:VimIM += [" ====  lmap imap nmap   ==== {{{"]
" =================================================

主要调用者：s:vimim_start()，s:vimim_set_keyboard_maps()

function! g:Vimim_label(key) (选词？)
function! g:Vimim_page(key) (翻页？但是符号输入大抵被拦截了吧)
function! g:Wubi()
function! s:vimim_punctuation_maps()
<- function! s:vimim_set_keyboard_maps()

二选用的？
function! g:Punctuation(key)
<- function! g:Vimim_page(key)
<- function! s:vimim_punctuation_maps()
(<- function! s:vimim_set_keyboard_maps(), 见上)

function! g:Vimim_cycle_vimim()
function! g:Vimim_pagedown()
function! g:Vimim_space()  (还有 <- function! g:Punctuation(key))
function! g:Vimim_enter()
<- function! s:vimim_start()

" ============================================= }}}
let s:VimIM += [" ====  mode: chinese    ==== {{{"]
" =================================================

主要调用者：s:vimim_start()，VimIM(start, keyboard)，快捷键，脚本末尾

切换中英文状态
function! g:Vimim_chinese()
<- function! s:vimim_plug_and_play() (快捷键)

function! s:vimim_set_keyboard_maps()
<- function! g:Vimim_cycle_vimim()
<- function! s:vimim_start()

仅在脚本末尾初始化时调用
function! s:vimim_set_im_toggle_list()

function! s:vimim_get_seamless(cursor_positions)
<- function! VimIM(start, keyboard)

疑似英文翻译？无调用者，删除
// function! s:translators.translate(english) dict

" ============================================= }}}
let s:VimIM += [" ====  input: unicode   ==== {{{"]
" =================================================

function! s:vimim_i18n(line)
<- function! s:vimim_readfile(datafile)

用于判断是否进行补全
function! s:vimim_left()
<- function! g:Vimim()
<- function! g:Vimim_space()
<- function! g:Vimim_enter()

工具函数，仅在一处调用
function! s:vimim_key_value_hash(single, double)
<- function! s:vimim_dictionary_punctuations()

function! s:chinese(...)

function! s:vimim_filereadable(filename)
<- function! s:vimim_set_backend_embedded()

function! s:vimim_readfile(datafile)
<- function! s:vimim_embedded_backend_engine(keyboard)

" ============================================= }}}
let s:VimIM += [" ====  input: pinyin    ==== {{{"]
" =================================================

这一块重点考虑删除的事情，所有调用当即理清

function! s:vimim_get_all_valid_pinyin_list()
<- function! s:vimim_quanpin_transform(pinyin) <- function! s:vimim_embedded_backend_engine(keyboard) (core engine)
// <- function! s:vimim_create_shuangpin_table(rules)

function! s:vimim_quanpin_transform(pinyin)
<- function! s:vimim_get_pinyin(keyboard) <- function! s:vimim_more_pinyin_candidates(keyboard) <- function! s:vimim_embedded_backend_engine(keyboard) (core engine)
<- function! s:vimim_embedded_backend_engine(keyboard) (core engine)

function! s:vimim_more_pinyin_datafile(keyboard, sentence)
<- function! s:vimim_sentence_datafile(keyboard) (backend: file)
<- function! s:vimim_get_from_datafile(keyboard) (backend: file)

function! s:vimim_get_pinyin(keyboard)
<- function! s:vimim_more_pinyin_candidates(keyboard)

function! s:vimim_more_pinyin_candidates(keyboard)
<- function! s:vimim_more_pinyin_datafile(keyboard, sentence) <- function! s:vimim_sentence_datafile(keyboard) (backend: file) <- function! s:vimim_get_from_datafile(keyboard) (backend: file)
<- function! s:vimim_embedded_backend_engine(keyboard) (core engine)

删 g:Vimim_shuangpin 变量，精简不会调用这一块的函数
// " ============================================= }}}
// let s:VimIM += [" ====  input: shuangpin ==== {{{"]
// " =================================================
// 
// function! s:vimim_shuangpin_generic()
// function! s:vimim_shuangpin_rules(shuangpin, rules)
// function! s:vimim_create_shuangpin_table(rules)
// function! s:vimim_shuangpin_transform(keyboard)
// 
// ./* <- function! VimIM(start, keyboard) (core engine, setted to be omnifunc)

" ============================================= }}}
let s:VimIM += [" ====  backend: file    ==== {{{"]
" =================================================

主要调用者：s:vimim_set_backend_embedded()，s:vimim_embedded_backend_engine(keyboard)

function! s:vimim_set_datafile(im, datafile)
<- function! s:vimim_set_backend_embedded()

function! s:vimim_sentence_datafile(keyboard)
function! s:vimim_get_from_datafile(keyboard)
<- function! s:vimim_embedded_backend_engine(keyboard)

function! s:vimim_make_pairs(oneline)
<- function! s:vimim_more_pinyin_datafile(keyboard, sentence)
<- function! s:vimim_get_from_datafile(keyboard)

" ============================================= }}}
let s:VimIM += [" ====  backend: dir     ==== {{{"]
" =================================================

主要调用者：s:vimim_set_backend_embedded()，s:vimim_embedded_backend_engine(keyboard)

function! s:vimim_set_directory(dir)
<- function! s:vimim_set_backend_embedded()

function! s:vimim_sentence_directory(keyboard, directory)
<- function! s:vimim_embedded_backend_engine(keyboard)

仅在脚本末尾初始化时调用
function! s:vimim_set_backend_embedded()

无调用，已删除
// function! s:vimim_sort_on_length(i1, i2)

" ============================================= }}}
let s:VimIM += [" ====  core workflow    ==== {{{"]
" =================================================

function! s:vimim_start()
function! s:vimim_stop()

全是脚本全局变量的设置（接口相关）
function! s:vimim_save_vimrc()

全是 vim 相关的设置
function! s:vimim_set_vimrc()

全是脚本功能实现相关的接口设置
function! s:vimim_restore_vimrc()

全是调用，仅在脚本末尾初始化和 vimim_stop 中调用
function! s:vimim_super_reset()

以下全是脚本全局变量的设置
function! s:vimim_reset_before_anything()
function! s:vimim_reset_before_omni()
function! s:vimim_reset_after_insert()

" ============================================= }}}
let s:VimIM += [" ====  core engine      ==== {{{"]
" =================================================

主要调用者：VimIM(start, keyboard)

仅被 VimIM 调用
function! VimIM(start, keyboard)

function! s:vimim_popupmenu_list(lines)
function! s:vimim_embedded_backend_engine(keyboard)
<- function! VimIM(start, keyboard)

多出现在补全的调用中
function! g:Vimim()

function! g:Omni()
<- function! g:Vimim()

" ============================================= }}}
let s:VimIM += [" ====  core driver      ==== {{{"]
" =================================================

设置切换中英文的快捷键
function! s:vimim_plug_and_play()

## 变量疏理

from chatgpt
以下是代码中的主要变量：

1. `s:plugin`：用于存储 Vimim 插件的安装路径。

2. `s:wubi`：标志是否启用五笔输入法。

3. `s:valid_wubi_keyboard`：五笔输入法的有效键盘字符列表。

4. `s:valid_keyboard`：所有输入法的有效键盘字符列表。

5. `s:keycodes`：存储输入法键码的字典。

6. `s:chinese`：将英文字符转换为对应的中文字符的字典。

7. `s:frontends`：存储前端配置的列表。

8. `s:all_vimim_input_methods`：所有可用的 Vimim 输入法的列表。

9. `s:popupmenu_height`：存储弹出菜单的高度。

10. `s:pattern_not_found`：用于标志是否找到匹配模式的变量。

11. `s:vimim_buffer_local`：用于存储是否启用 Vimim 输入法的缓冲区本地变量。

12. `s:vimim_in_init`：用于标志是否在初始化过程中的变量。

13. `s:vimim_dict_punctuations`：存储标点符号的字典。

14. `s:vimim_pumheights`：存储不同输入法的弹出菜单高度的字典。

15. `s:vimim_esc_mappings`：存储 `<Esc>` 键的映射。

16. `s:vimim_i`、`s:vimim_m`、`s:vimim_m_space` 等函数内部使用的变量。

17. `s:ctrl6`、`s:ctrl`、`s:esc`、`s:omni` 等函数内部使用的标志变量。

18. `s:starts`：存储 Vimim 启动时的相关信息。

19. `s:mode`：存储 Vimim 当前的输入模式信息。

20. `s:keyboard`：存储当前输入法键入的字符。

21. `s:match_list`：存储匹配的候选词列表。

22. `s:pageup_pagedown`：用于标志是否启用翻页模式。

23. `s:popup_list`：存储弹出菜单中的候选词列表。

24. `s:ui`：存储用户界面配置的字典，包括当前输入法和数据源的信息。

25. `g:Vimim_profile`：用于存储 Vimim 插件的性能分析信息。

这些变量在代码中起着不同的作用，包括存储配置信息、标志状态、存储数据等。它们共同支持 Vimim 插件的功能和特性。

以下是与拼音输入法相关的变量和函数：

**变量：**

1. `s:ui.im`：存储当前输入法的信息。

2. `s:ui.root`：存储当前数据源的信息。

3. `s:backend`：存储不同输入法和数据源的后端配置。

4. `s:vimim_more_pinyin_candidates()` 函数内部的 `s:ui.im` 的检查，用于判断是否是拼音输入法。

5. `s:vimim_get_all_valid_pinyin_list()` 函数中的拼音列表。

6. `s:vimim_quanpin_transform()` 函数用于拼音的转换。

7. `s:vimim_more_pinyin_datafile()` 函数内部的拼音相关逻辑。

8. `s:vimim_get_pinyin()` 函数用于获取拼音输入的字符。

9. `s:vimim_more_pinyin_candidates()` 函数用于获取更多的拼音输入候选词。

10. `s:vimim_sentence_datafile()` 函数内部的拼音相关逻辑。

11. `s:vimim_get_from_datafile()` 函数内部的拼音相关逻辑。

12. `s:vimim_embedded_backend_engine()` 函数用于拼音输入法的后端处理。

13. `g:Vimim()` 和 `g:Omni()` 函数内部的拼音相关逻辑。

**函数：**

1. `s:vimim_get_all_valid_pinyin_list()`：获取所有有效的拼音列表。

2. `s:vimim_quanpin_transform(pinyin)`：将拼音转换为全拼形式。

3. `s:vimim_more_pinyin_datafile(keyboard, sentence)`：获取更多拼音数据。

4. `s:vimim_get_pinyin(keyboard)`：从输入中提取拼音。

5. `s:vimim_more_pinyin_candidates(keyboard)`：获取更多拼音输入的候选词。

6. `s:vimim_sentence_datafile(keyboard)`：从数据源中获取拼音输入的句子。

7. `s:vimim_get_from_datafile(keyboard)`：从数据源中获取拼音相关的词汇。

8. `s:vimim_embedded_backend_engine(keyboard)`：拼音输入法的后端引擎。

以上变量和函数与拼音输入法相关，用于支持拼音输入法的功能和逻辑。如果要删除拼音输入法相关的功能，可以考虑删除与这些变量和函数相关的代码。

