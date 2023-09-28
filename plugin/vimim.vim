" ===========================================================
"                VimIM —— Vim 中文輸入法简化版
" ===========================================================
let s:url = ' http://vimim.googlecode.com/svn/vimim/vimim.vim.html'
let s:url = ' http://code.google.com/p/vimim/source/list'
let s:url = ' http://vim.sf.net/scripts/script.php?script_id=2506'

let s:VimIM  = [" ====  introduction     ==== {{{"]
" =================================================
"    File: vimim.vim
"  Author: vimim <vimim@googlegroups.com>
" License: GNU Lesser General Public License
"  Readme: VimIM is a Vim plugin as an Input Method for i_CTRL-^ in Vim
"    (1) do Chinese input without mode change: Midas touch
"  PnP: Plug and Play
"    (1) drop the vimim.vim to the plugin folder: plugin/vimim.vim
"    (2) [option] drop supported datafiles, like: plugin/vimim.wubijd.txt
"  Usage: VimIM takes advantage of the definition from Vim
"    (1) :help i_CTRL-^  Toggle the use of language      ...
"    (2) :help i_CTRL-_  Switch between languages        ...

" ============================================= }}}
let s:VimIM += [" ====  initialization   ==== {{{"]
" =================================================

function! s:vimim_bare_bones_vimrc()
    set fileencodings=utf8,chinese,gb18030
    set cpoptions=Bce$ guioptions=cirMehf shm=aoOstTAI noloadplugins
endfunction

if exists("g:Vimim_profile") || &iminsert == 1 || v:version < 700
    finish
elseif &compatible
    call s:vimim_bare_bones_vimrc()
endif

scriptencoding utf-8
let g:Vimim_profile = reltime()
let s:plugin = expand("<sfile>:p:h")

function! s:vimim_initialize_global()
    highlight  default lCursorIM guifg=NONE guibg=green gui=NONE
    highlight! link lCursor lCursorIM
    let s:space = '　'
    let s:colon = '：'
    let g:Vimim = "VimIM　中文輸入法"
    let s:multibyte    = &encoding =~ "utf-8" ? 3 : 2
    let s:localization = &encoding =~ "utf-8" ? 0 : 2
    let s:seamless_positions = []
    let s:starts = { 'row' : 0, 'column' : 1 }
    let s:abcd = split("'abcdvfgxz", '\zs')
    let s:az_list = map(range(97,122),"nr2char(".'v:val'.")")
    let s:valid_keys = s:az_list
    let s:valid_keyboard = "[0-9a-z]"
    let s:pumheights = { 'current' : &pumheight, 'saved' : &pumheight }
    let s:backend = { 'datafile' : {}, 'directory' : {} }
    let s:ui = { 'root' : '', 'im' : '', 'frontends' : [] }

    " s:rc 项可供用户设置，但是需要在插件加载完毕后进行
    let s:rc = {}
    let s:rc["g:Vimim_toggle"] = 0
    let s:rc["g:Vimim_plugin"] = s:plugin
    let s:rc["g:Vimim_punctuation"] = 1
    " 设置默认选项
    call s:vimim_set_global_default()

    let s:plugin = isdirectory(g:Vimim_plugin) ? g:Vimim_plugin : s:plugin
    let s:plugin = s:plugin[-1:] != "/" ? s:plugin."/" : s:plugin
    let s:dynamic    = {'dynamic':1,'static':0}
    let s:static     = {'dynamic':0,'static':1}
endfunction

function! s:vimim_dictionary_keycodes()
    let s:keycodes = {}
    for key in split('wubi')
        let s:keycodes[key] = "[a-z]"
    endfor
    let ime  = ' wubiyuhao'
    let s:all_vimim_input_methods = keys(s:keycodes) + split(ime)
endfunction

function! s:vimim_set_frontend()
    let s:valid_keyboard = "[0-9a-z]"
    if !empty(s:ui.root)
        let s:valid_keyboard = s:backend[s:ui.root][s:ui.im].keycode
    endif
    let i = 0
    let keycode_string = ""
    while i < 256
        if nr2char(i) =~# s:valid_keyboard
            let keycode_string .= nr2char(i)
        endif
        let i += 1
    endwhile

    let s:valid_keys = split(keycode_string, '\zs')
    let logo = s:chinese('chinese','_',s:mode.static?'static':'dynamic')
    let tail = s:chinese('halfwidth')
    if g:Vimim_punctuation > 0 && s:toggle_punctuation > 0
        let tail = s:chinese('fullwidth')
    endif
    let g:Vimim = "VimIM".s:space.logo.' '.s:vimim_im_chinese().' '.tail
endfunction

function! s:vimim_set_global_default()
    let s:vimimrc = []
    let s:vimimdefaults = []
    for variable in keys(s:rc)
        if exists(variable)
            let value = string(eval(variable))
            let vimimrc = ':let ' . variable .' = '. value .' '
            call add(s:vimimrc, '    ' . vimimrc)
        else
            let value = string(s:rc[variable])
            let vimimrc = ':let ' . variable .' = '. value .' '
            call add(s:vimimdefaults, '  " ' . vimimrc)
        endif
        exe 'let '. variable .'='. value
    endfor
endfunction

function! s:vimim_cache()
    let results = []
    if !empty(s:pageup_pagedown)
        let length = len(s:match_list)
        if length > &pumheight
            let page = s:pageup_pagedown * &pumheight
            let partition = page ? page : length+page
            let B = s:match_list[partition :]
            let A = s:match_list[: partition-1]
            let results = B + A
        endif
    endif
    return results
endfunction

" ============================================= }}}
let s:VimIM += [" ====  user interface   ==== {{{"]
" =================================================

function! s:vimim_dictionary_punctuations()
    let s:antonym = " 〖〗 （） 《》 【】 "
    let one =       " { }  ( )  < >  [  ] "
    let two = join(split(join(split(s:antonym)[:3],''),'\zs'))
    let antonyms = s:vimim_key_value_hash(one, two)
    let one = " ,  .  ~  ^  _  :  $  !  ;  ?  \\  '  \" "
    let two = " ， 。 ﹡ …… —— ： ￥ ！ ； ？ 、 ‘’  “” "
    let mini_punctuations = s:vimim_key_value_hash(one, two)
    let one = " +  -  ~  #  &  %  =  * "
    let two = "＋ － ～ ＃ ＆ ％  ＝ ﹡"
    let most_punctuations = s:vimim_key_value_hash(one, two)
    call extend(mini_punctuations, antonyms)
    call extend(most_punctuations, antonyms)

    let s:all_evils = { "<TAB>": "<TAB>" }

    call extend(s:all_evils, mini_punctuations)
    call extend(s:all_evils, most_punctuations)
    let s:punctuations = {}
    if g:Vimim_punctuation > 0
        call extend(s:punctuations, mini_punctuations)
    endif
    if g:Vimim_punctuation > 1
        call extend(s:punctuations, most_punctuations)
    endif
endfunction

function! s:vimim_get_label(label)
    let labeling = a:label == 10 ? "0" : a:label
    return labeling
endfunction

function! s:vimim_set_pumheight()
    let &completeopt = 'menuone'
    let &pumheight = s:pumheights.saved
    if empty(&pumheight)
        let &pumheight = 5
        if len(s:valid_keys) > 28
            let &pumheight = 10
        endif
    endif
    let &pumheight = &pumheight
    let s:pumheights.current = copy(&pumheight)
endfunction

function! s:vimim_im_chinese()
    if empty(s:ui.im)
        return "==broken interface to vim=="
    endif
    let backend = s:backend[s:ui.root][s:ui.im]
    let title = has_key(s:keycodes, s:ui.im) ? backend.chinese : ''
    if s:ui.im =~ 'wubi'
        for wubi in split('wubihf wubiyuhao')
            if get(split(backend.name, '/'),-1) =~ wubi
                let title .= '_' . s:chinese(wubi)
            endif
        endfor
    endif
    return title
endfunction

function! g:Vimim_esc()
    let key = nr2char(27)  "  <Esc> is <Esc>
    sil!exe 'sil!return "' . key . '"'
endfunction

" ============================================= }}}
let s:VimIM += [" ====  lmap imap nmap   ==== {{{"]
" =================================================

function! g:Vimim_cycle_vimim()
    if s:mode.static || s:mode.dynamic
        let s:toggle_punctuation = (s:toggle_punctuation + 1) % 2
    endif
    sil!call s:vimim_set_frontend()
    sil!call s:vimim_set_keyboard_maps()
    return ""
endfunction

" 数字键（标签）选词
function! g:Vimim_label(key)
    let key = a:key
    if pumvisible()
        let n = match(s:abcd, key)
        if key =~ '\d'
            let n = key < 1 ? 9 : key - 1
        endif
        let yes = repeat("\<Down>", n). '\<C-Y>'
        let omni = '\<C-R>=g:Vimim()\<CR>'
        if len(yes)
            sil!call s:vimim_reset_after_insert()
        endif
        let key = yes . omni
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

" 翻页按键的处理
function! g:Vimim_page(key)
    let key = a:key
    if pumvisible()
        let page = '\<C-E>\<C-R>=g:Vimim()\<CR>'
        " 取消左右方括号删词的操作，太鸡肋，改为翻页用
        if key =~ '[]]'
            let s:pageup_pagedown = &pumheight ? 1 : 0
            let key = &pumheight ? page : '\<PageDown>'
        elseif key =~ '[[]'
            let s:pageup_pagedown = &pumheight ? -1 : 0
            let key = &pumheight ? page : '\<PageUp>'
        endif
    " elseif key =~ "[][=-]"
    elseif key =~ "[][]"
        let key = g:Punctuation(key)
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

function! g:Wubi(after_char)
    if s:gi_dynamic_on
        let s:gi_dynamic_on = 0 | return ""
    endif
    " 四码顶屏及唯一结果顶屏 
    let key = pumvisible() && !a:after_char ? '\<C-E>' : ""
    if empty(len(get(split(s:keyboard),0))%4)
        if a:after_char && len(s:match_list) == 1 || !a:after_char
            let key = pumvisible() ? '\<C-Y>' : key
        endif
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

" 初始化 lmap 的符号相关的按键映射
function! s:vimim_punctuation_maps()
    for _ in keys(s:all_evils)
        if _ !~ s:valid_keyboard
            if _ == "'"
                exe "lnoremap<buffer><expr> "._.' g:Punctuation("'._.'")'
            else
                exe "lnoremap<buffer><expr> "._." g:Punctuation('"._."')"
            endif
        endif
    endfor
endfunction

" 符号转化输出，依据符号表来确认输出字符，二选三选四选均在此
function! g:Punctuation(key)
    let key = a:key

    if s:toggle_punctuation > 0
        if pumvisible() || getline(".")[col(".")-2] !~ '\w'
            if has_key(s:punctuations, a:key)
                let key = s:punctuations[a:key]
                if a:key == '"'
                    let key = split(key, '\zs')[s:double_quotes_toggle_status]
                    let s:double_quotes_toggle_status = (s:double_quotes_toggle_status + 1) % 2
                elseif a:key == "'"
                    let key = split(key, '\zs')[s:single_quotes_toggle_status]
                    let s:single_quotes_toggle_status = (s:single_quotes_toggle_status + 1) % 2
                endif
            endif
            if pumvisible()
                let key = '\<C-Y>'.key
            endif
        endif
    endif
    if pumvisible()
        " 三选，四选 
        if a:key == ";"
            let key = '\<C-N>\<C-Y>' 
        elseif a:key == "'"
            let key = '\<C-N>\<C-N>\<C-Y>' 
        elseif a:key == "\t"
            let key = '\<C-N>\<C-N>\<C-N>\<C-Y>' 
        else
            let key = key
        endif
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

function! g:Vimim_space()
    " (1) Space after English (valid keys)    => trigger keycode menu
    " (2) Space after omni popup menu         => insert Chinese
    " (3) Space after pattern not found       => Space
    let key = " "
    if pumvisible()
        let key = '\<C-R>=g:Vimim()\<CR>'
        let cursor = s:mode.static ? '\<C-P>\<C-N>' : ''
        let key = cursor . '\<C-Y>' . key
    elseif s:pattern_not_found
    elseif s:mode.dynamic
    elseif s:mode.static
        let key = s:vimim_left() ? g:Vimim() : key
    elseif s:seamless_positions == getpos(".")
        let s:smart_enter = 0
    endif
    call s:vimim_reset_after_insert()
    sil!exe 'sil!return "' . key . '"'
endfunction

function! g:Vimim_enter()
    let s:omni = 0
    let key = ""
    if pumvisible()
        let key = "\<C-E>"
        let s:smart_enter = 1
    elseif s:vimim_left()
        let s:smart_enter = 1
        if s:seamless_positions == getpos(".")
            let s:smart_enter += 1
        endif
    else
        let s:smart_enter = 0
    endif
    if s:smart_enter == 1
        let s:seamless_positions = getpos(".")
    else
        let key = "\<CR>"
        let s:smart_enter = 0
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

" ============================================= }}}
let s:VimIM += [" ====  mode: chinese    ==== {{{"]
" =================================================

function! g:Vimim_chinese()
    let s:mode = s:dynamic
    let s:switch = empty(s:ui.frontends) ? -1 : s:switch ? 0 : 1
    return s:switch<0 ? "" : s:switch ? s:vimim_start() : s:vimim_stop()
endfunction

function! s:vimim_set_keyboard_maps()
    " 以下为新增变量，用于处理引号配对的问题
    let s:single_quotes_toggle_status = 0
    let s:double_quotes_toggle_status = 0

    let both_dynamic = s:mode.dynamic ? 1 : 0
    " 取消加减翻页的功能，改用方括号翻页
    " let common_punctuations = split("] [ = -")
    let common_punctuations = split("] [")
    let common_labels = s:ui.im =~ 'phonetic' ? [] : range(10)
    if both_dynamic
        for char in s:valid_keys
            sil!exe 'lnoremap<silent><buffer> ' . char . ' ' .
            \ '<C-R>=g:Wubi(0)<CR>' . char . '<C-R>=g:Vimim()<CR><C-R>=g:Wubi(1)<CR>'
            " 两次调用 Wubi ，第一次用于四码顶屏，第二次用于唯一匹配结果顶屏
        endfor
    elseif s:mode.static
        for char in s:valid_keys
            sil!exe 'lnoremap<silent><buffer> ' . char . ' ' .  char
        endfor
    else
        let common_punctuations += split(". ,")
        let common_labels += s:abcd[1:]
    endif
    if g:Vimim_punctuation < 0
    elseif both_dynamic || s:mode.static
        sil!call s:vimim_punctuation_maps()
    endif
    for _ in common_punctuations
        if _ !~ s:valid_keyboard
            sil!exe 'lnoremap<buffer><expr> '._.' g:Vimim_page("'._.'")'
        endif
    endfor
    for _ in common_labels
        sil!exe 'lnoremap<buffer><expr> '._.' g:Vimim_label("'._.'")'
    endfor
endfunction

function! s:vimim_set_im_toggle_list()
    let toggle_list = []
    if g:Vimim_toggle < 0
        let toggle_list = [get(s:ui.frontends,0)]
    elseif empty(g:Vimim_toggle)
        let toggle_list = s:ui.frontends
    else
        for toggle in split(g:Vimim_toggle, ",")
            for [root, im] in s:ui.frontends
                if toggle == im
                    call add(toggle_list, [root, im])
                endif
            endfor
        endfor
    endif
    let s:frontends = copy(toggle_list)
    let s:ui.frontends = copy(toggle_list)
    let s:ui.root = get(get(s:ui.frontends,0), 0)
    let s:ui.im   = get(get(s:ui.frontends,0), 1)
endfunction

function! s:vimim_get_seamless(cursor_positions)
    if empty(s:seamless_positions)
    \|| s:seamless_positions[0] != a:cursor_positions[0]
    \|| s:seamless_positions[1] != a:cursor_positions[1]
    \|| s:seamless_positions[3] != a:cursor_positions[3]
        return -1
    endif
    let current_line = getline(a:cursor_positions[1])
    let seamless_column = s:seamless_positions[2]-1
    let len = a:cursor_positions[2]-1 - seamless_column
    let snip = strpart(current_line, seamless_column, len)
    if empty(len(snip))
        return -1
    endif
    for char in split(snip, '\zs')
        if char !~ s:valid_keyboard
            return -1
        endif
    endfor
    return seamless_column
endfunction

" ============================================= }}}
let s:VimIM += [" ====  input: unicode   ==== {{{"]
" =================================================

function! s:vimim_i18n(line)
    let line = a:line
    if s:localization == 1
        return iconv(line, "chinese", "utf-8")
    elseif s:localization == 2
        return iconv(line, "utf-8", &enc)
    endif
    return line
endfunction

function! s:vimim_left()
    let key = 0
    let one_byte_before = getline(".")[col(".")-2]
    if one_byte_before =~ '\s' || empty(one_byte_before)
        let key = ""
    elseif one_byte_before =~# s:valid_keyboard
        let key = 1
    endif
    return key
endfunction

function! s:vimim_key_value_hash(single, double)
    let hash = {}
    let singles = split(a:single)
    let doubles = split(a:double)
    for i in range(len(singles))
        let hash[get(singles,i)] = get(doubles,i)
    endfor
    return hash
endfunction

function! s:chinese(...)
    let chinese = ""
    for english in a:000
        let cjk = english
        let chinese .= cjk
    endfor
    return chinese
endfunction

function! s:vimim_filereadable(filename)
    let datafile_1 = s:plugin . a:filename
    if filereadable(datafile_1)
        return datafile_1
    endif
    return ""
endfunction

function! s:vimim_readfile(datafile)
    let lines = []
    if filereadable(a:datafile)
        if s:localization
            for line in readfile(a:datafile)
                call add(lines, s:vimim_i18n(line))
            endfor
        else
            return readfile(a:datafile)
        endif
    endif
    return lines
endfunction

" ============================================= }}}
let s:VimIM += [" ====  backend: file    ==== {{{"]
" =================================================

function! s:vimim_set_datafile(im, datafile)
    let im = a:im
    if isdirectory(a:datafile) | return
    elseif im =~ '^wubi'       | let im = 'wubi'
    endif
    let s:ui.root = 'datafile'
    let s:ui.im = im
    call insert(s:ui.frontends, [s:ui.root, s:ui.im])
    let s:backend.datafile[im] = {}
    let s:backend.datafile[im].root = s:ui.root
    let s:backend.datafile[im].im = s:ui.im
    let s:backend.datafile[im].name = a:datafile
    let s:backend.datafile[im].keycode = s:keycodes[im]
    let s:backend.datafile[im].chinese = s:chinese(im)
    let s:backend.datafile[im].lines = []
endfunction

function! s:vimim_get_from_datafile(keyboard)
    let pattern = '^\V' . a:keyboard . ' '
    let backend = s:backend[s:ui.root][s:ui.im]
    let cursor = match(backend.lines, pattern)
    if cursor < 0 | return [] | endif
    let oneline = get(backend.lines, cursor)
    let results = split(oneline)[1:]
    if len(results) > 10
        return results
    endif

    let results = []
    let results += s:vimim_make_pairs(oneline)
    let s:show_extra_menu = 1
    " 原本范围为 range(10)
    for i in range(50)
        let cursor += 1
        let oneline = get(backend.lines, cursor)
        " 去除不匹配的结果，依赖码表顺序排列
        if match(oneline, pattern) < 0 | break | endif
        let results += s:vimim_make_pairs(oneline)
    endfor
    return results
endfunction

function! s:vimim_make_pairs(oneline)
    if empty(a:oneline) || match(a:oneline,' ') < 0
        return []
    endif
    let oneline_list = split(a:oneline)
    let menu = remove(oneline_list, 0)
    let results = []
    for chinese in oneline_list
        call add(results, menu .' '. chinese)
    endfor
    return results
endfunction

" ============================================= }}}
let s:VimIM += [" ====  backend: dir     ==== {{{"]
" =================================================

function! s:vimim_set_backend_embedded()
    for im in s:all_vimim_input_methods
        let datafile = s:vimim_filereadable("vimim." . im . ".txt")
        if empty(datafile)
            let filename = "vimim." . im . "." . &encoding . ".txt"
            let datafile = s:vimim_filereadable(filename)
        endif
        if !empty(datafile)
            call s:vimim_set_datafile(im, datafile)
        endif
    endfor
endfunction

" ============================================= }}}
let s:VimIM += [" ====  core workflow    ==== {{{"]
" =================================================

function! s:vimim_start()
    sil!call s:vimim_save_vimrc()
    sil!call s:vimim_set_vimrc()
    sil!call s:vimim_set_frontend()
    sil!call s:vimim_set_keyboard_maps()
    lnoremap <silent><buffer> <expr> <Esc>   g:Vimim_esc()
    lnoremap <silent><buffer> <expr> <C-L>   g:Vimim_cycle_vimim()
    lnoremap <silent><buffer> <expr> <CR>    g:Vimim_enter()
    lnoremap <silent><buffer> <expr> <Space> g:Vimim_space()
    let key = ''
    if empty(s:ctrl6)
        let s:ctrl6 = 32911
        let key = nr2char(30)
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

function! s:vimim_stop()
    if has("gui_running")
        lmapclear
    endif
    " i_CTRL-^
    let key = nr2char(30)
    let s:ui.frontends = copy(s:frontends)
    sil!call s:vimim_restore_vimrc()
    sil!call s:vimim_super_reset()
    sil!exe 'sil!return "' . key . '"'
endfunction

function! s:vimim_save_vimrc()
    let s:omnifunc    = &omnifunc
    let s:complete    = &complete
    let s:completeopt = &completeopt
endfunction

function! s:vimim_set_vimrc()
    set title noshowmatch shellslash
    set completeopt=menuone
    set complete=.
    set nolazyredraw
    set omnifunc=VimIM
endfunction

function! s:vimim_restore_vimrc()
    let &omnifunc    = s:omnifunc
    let &complete    = s:complete
    let &completeopt = s:completeopt
    let &pumheight   = s:pumheights.saved
endfunction

function! s:vimim_super_reset()
    sil!call s:vimim_reset_before_anything()
    sil!call s:vimim_reset_before_omni()
    sil!call s:vimim_reset_after_insert()
endfunction

function! s:vimim_reset_before_anything()
    let s:mode = s:static
    let s:keyboard = ""
    let s:omni = 0
    let s:ctrl6 = 0
    let s:switch = 0
    let s:toggle_im = 0
    let s:smart_enter = 0
    let s:gi_dynamic_on = 0
    let s:toggle_punctuation = 1
    let s:popup_list = []
endfunction

function! s:vimim_reset_before_omni()
    let s:show_extra_menu = 0
endfunction

function! s:vimim_reset_after_insert()
    let s:match_list = []
    let s:pageup_pagedown = 0
    let s:pattern_not_found = 0
endfunction

" ============================================= }}}
let s:VimIM += [" ====  core engine      ==== {{{"]
" =================================================

function! VimIM(start, keyboard)
let valid_keyboard = s:valid_keyboard
if a:start
    let cursor_positions = getpos(".")
    let start_row = cursor_positions[1]
    let start_column = cursor_positions[2]-1
    let current_line = getline(start_row)
    let before = current_line[start_column-1]
    let seamless_column = s:vimim_get_seamless(cursor_positions)
    if seamless_column < 0
        let s:seamless_positions = []
        let last_seen_bslash_column = copy(start_column)
        let last_seen_nonsense_column = copy(start_column)
        let all_digit = 1
        while start_column
            if before =~# valid_keyboard
                let start_column -= 1
                if before !~# "[0-9']" || s:ui.im =~ 'phonetic'
                    let last_seen_nonsense_column = start_column
                    let all_digit = all_digit ? 0 : all_digit
                endif
            elseif before == '\'
                let s:pattern_not_found = 1
                return last_seen_bslash_column
            else
                break
            endif
            let before = current_line[start_column-1]
        endwhile
        if all_digit < 1 && current_line[start_column] =~ '\d'
            let start_column = last_seen_nonsense_column
        endif
    else
        let start_column = seamless_column
    endif
    let len = cursor_positions[2]-1 - start_column
    let keyboard = strpart(current_line, start_column, len)
    if s:keyboard !~ '\S\s\S'
        let s:keyboard = keyboard
    endif
    let s:starts.column = start_column
    return start_column
else
    if s:omni < 0
        return [s:space]
    endif
    let results = s:vimim_cache()
    if empty(results)
        sil!call s:vimim_reset_before_omni()
    else
        return s:vimim_popupmenu_list(results)
    endif
    let keyboard = a:keyboard
    if !empty(str2nr(keyboard))
        let keyboard = get(split(s:keyboard),0)
    endif
    if empty(keyboard) || keyboard !~ valid_keyboard
        return []
    endif
    if empty(results)
        if len(keyboard) > 4
            let keyboard = strpart(keyboard, 4*((len(keyboard)-1)/4))
            let s:keyboard = keyboard
        endif
        let results = s:vimim_embedded_backend_engine(keyboard)
    endif
    if empty(results)
        let s:pattern_not_found = 1
    endif
    return s:vimim_popupmenu_list(results)
endif
endfunction

function! s:vimim_popupmenu_list(lines)
    let s:match_list = a:lines
    let keyboards = split(s:keyboard)  " mmmm => ['m',"m'm'm"]
    let keyboard = join(keyboards,"")
    let tail = len(keyboards) < 2 ? "" : get(keyboards,1)
    if empty(a:lines) || type(a:lines) != type([])
        return []
    endif
    let label = 1
    let one_list = []
    let s:popup_list = []
    for chinese in s:match_list
        let complete_items = {}
        let titleline = s:vimim_get_label(label)
        let menu = ""
        let pairs = split(chinese)
        let pair_left = get(pairs,0)
        if len(pairs) > 1 && pair_left !~ '[^\x00-\xff]'
            let chinese = get(pairs,1)
            let menu = s:show_extra_menu ? pair_left : menu
        endif
        let label2 = ' '
        let titleline = printf('%3s ', label2 . titleline)
        let chinese .= empty(tail) || tail == "'" ? '' : tail
        let complete_items["abbr"] = titleline . chinese
        let complete_items["menu"] = menu
        let label += 1
        let complete_items["dup"] = 1
        let complete_items["word"] = empty(chinese) ? s:space : chinese
        call add(s:popup_list, complete_items)
    endfor
    call s:vimim_set_pumheight()
    return s:popup_list
endfunction

function! s:vimim_embedded_backend_engine(keyboard)
    let keyboard = a:keyboard
    if empty(s:ui.im) || empty(s:ui.root)
        return []
    endif
    let results = []
    let backend = s:backend[s:ui.root][s:ui.im]
    if s:ui.root =~# "datafile"
        if empty(backend.lines)
            let backend.lines = s:vimim_readfile(backend.name)
        endif
        " 这里原本有一份语句流处理的代码，但我不用这个，删了
        " 作用是逐字查找可行的编码
        let results = s:vimim_get_from_datafile(keyboard)
    endif
    if s:keyboard !~ '\S\s\S'
        " 这里同上一语句块内的注释
        let s:keyboard = keyboard
    endif
    return results
endfunction

function! g:Vimim()
    let s:omni = s:omni < 0 ? -1 : 0
    let s:keyboard = empty(s:pageup_pagedown) ? "" : s:keyboard
    let key = s:vimim_left() ? '\<C-X>\<C-O>\<C-R>=g:Omni()\<CR>' : ""
    sil!exe 'sil!return "' . key . '"'
endfunction

function! g:Omni()
    let s:omni = s:omni < 0 ? 0 : 1
    let key = s:mode.static ? '\<C-N>\<C-P>' : '\<C-P>\<Down>'
    let key = pumvisible() ? key : ""
    sil!exe 'sil!return "' . key . '"'
endfunction

" ============================================= }}}
let s:VimIM += [" ====  core driver      ==== {{{"]
" =================================================

function! s:vimim_plug_and_play()
    " 原代码:
    " nnoremap <silent> <C-_> a<C-R>=g:Vimim_chinese()<CR>
    " inoremap <unique> <C-_>  <C-R>=g:Vimim_chinese()<CR>
    " vim 原生支持的语言切换键是 C-_ 和 C-^
    nnoremap <silent> <C-J> a<C-R>=g:Vimim_chinese()<CR><ESC>
    inoremap <unique> <C-J>  <C-R>=g:Vimim_chinese()<CR>
    " 希望加入命令模式下的支持
    " cnoremap <unique> <C-J>  <C-R>=g:Vimim_chinese()<CR>
endfunction

sil!call s:vimim_initialize_global()
sil!call s:vimim_dictionary_punctuations()
sil!call s:vimim_dictionary_keycodes()
sil!call s:vimim_super_reset()
sil!call s:vimim_set_backend_embedded()
sil!call s:vimim_set_im_toggle_list()
sil!call s:vimim_plug_and_play()
:let g:Vimim_profile = reltime(g:Vimim_profile)
" ============================================= }}}
