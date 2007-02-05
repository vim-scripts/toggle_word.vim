" toggle_word.vim
"
" Vim global plugin for toggling words between true/false, yes/no, etc.
" Feedback is more than welcome :-)
"
" Last Change:  Thu Jan 25 15:47:27 EET 2007
" Maintainer:   Alexandru Ungur <alexandru@globalterrasoft.ro>
" License:      This file is placed in the public domain.
" Requires:     Vim7+, vx_lib.vim
" Version:      1.3

" some checks: version, if already loaded, if needed library is loaded already
if v:version < 700
    echo "This script 'toggle_word.vim' requires vim7+ as it uses dictionaries and OO features."
    finish 
elseif exists('loaded_toggle_word')
    echo "toggle_word.vim already loaded! won't reload."
    finish
elseif !exists('*DictInverse')
    runtime lib/vx_lib.vim library/vx_lib.vim plugin/vx_lib.vim
    if !exists('*DictInverse')
        echo "toggle_word.vim requires vx_lib.vim! Cannot work without it, aborting."
        finish
    endif
endif

" build the full toggle dictionary
let s:base_minimal =  {'true' : 'false', 'yes' : 'no'}
let s:h = Hashify(exists('g:toggle_words') ? g:toggle_words : s:base_minimal)
call s:h.merge(s:h.upcase(), s:h.capitalize()) | call s:h.merge(s:h.inverse())

" return a toggled word, or empty string if none found
func ToggleWord(word)
    return s:h.ikey(a:word)
endf

" toggle the word under cursor
func DoToggleWord()
    let tword = ToggleWord(expand("<cword>"))
    if strlen(tword) | exec "normal ciw" . tword | endif
endf

let loaded_toggle_word = "1.3"

" some handy mappings for the command
com! DoToggleWord :call DoToggleWord() <CR>
nmap <leader>t :call DoToggleWord()<CR>
vmap <leader>t <ESC>:call DoToggleWord()<CR>
