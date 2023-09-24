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

