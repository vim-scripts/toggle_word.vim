" vx_lib.vim - Vim eXtenstions Library
"
" Vim generally useful library, 
" contains String and Dictionary related functions.
"
" Feedback is more than welcome :-)
"
" Last Change:  Thu Jan 25 15:37:19 EET 2007
" Maintainer:   Alexandru Ungur <alexandru@globalterrasoft.ro>
" License:      This file is placed in the public domain.

" Return a word in lowercase
func! Downcase(word)
    return tolower(a:word)
endf

" Return a word in uppercase
func! Upcase(word)
    return toupper(a:word)
endf

" Return a word capitalized
func! Capitalize(word)
    return Upcase(a:word[0]) . Downcase(a:word[1:strlen(a:word)-1])
endf

" Generic, full dictionary mapping (both to values AND keys)
func! DictMap(dict,expr)
    let new_dict = {}
    for key in keys(a:dict)
        call extend(new_dict, eval(a:expr))
    endfor | return new_dict
endf

" Full dictionary downcase
func! DictDowncase(dict)
    return DictMap(a:dict, "{Downcase(key):Downcase(a:dict[key])}")
endf

" Full dictionary uppercase
func! DictUpcase(dict)
    return DictMap(a:dict, "{Upcase(key):Upcase(a:dict[key])}")
endf

" Full dictionary capitalize
func! DictCapitalize(dict)
    return DictMap(a:dict, "{Capitalize(key):Capitalize(a:dict[key])}")
endf

" Dictionary swap keys <-> values
func! DictInverse(dict)
    let new_dict = {}
    for key in keys(a:dict)
        call extend(new_dict, {a:dict[key] : key})
    endfor | return new_dict
endf


" ==============================================================================
" VX Library - OO Version
" It only implements an OO wrapper layer around the functions defined above
" ==============================================================================

" We define the Hash type here, which is nothing but a Dictionary type,
" wrapped together with some methods, in a nice OO package
" NEVER USE IT DIRECTLY!, instead use Hashify, see below
let Hash = {'data' : {}}

" Initialize a Hash variable
" THIS IS THE PREFERRED METHOD OF INITIALIZING A HASH,
" though one can just as well use copy(Hash)
"
" If you pass it an optional Dictionary it will initialize the Hash with it
func! Hashify(...)
    let tmp_dict = copy(g:Hash)
    if a:0
        call tmp_dict.merge(a:1)
    endif
    return tmp_dict
endf

" Return the size/length of an Hash
func! Hash.size() dict
    return len(self.data)
endf

" Concatenate the Hash's content with any number of Dictionaries passed 
" as arguments and return the result
func! Hash.concat(...) dict
    let tmp_dict = copy(self.data)
    if a:0
        for n in a:000
            call extend(tmp_dict, n)
        endfor
    endif
    return tmp_dict
endf

" Merge Hash's content with an arbitrary number of Dictionaries
func! Hash.merge(...) dict
    if a:0
        for n in a:000
            call extend(self.data, n)
        endfor
    endif
endf

" Turn all Hash's content (including keys) to lowercase
func! Hash.downcase() dict
    return DictDowncase(self.data)
endf

" Turn all Hash's content (including keys) to uppercase
func! Hash.upcase() dict
    return DictUpcase(self.data)
endf

" Turn all Hash's content (including keys) to capitalize
func! Hash.capitalize() dict
    return DictCapitalize(self.data)
endf

" Swap keys with values in Hash's content
func! Hash.inverse() dict
    return DictInverse(self.data)
endf

" Get key with indiferent case access, return empty string on failure
func! Hash.ikey(word) dict
    if     has_key(self.data, a:word) | return self.data[a:word]
    elseif has_key(self.data, Downcase(a:word)) | return self.data[Downcase(a:word)]
    else | return ""
    endif
endf

" Example usage
"
" dict = {'on' : 'off', 'yes' : 'no'}
"
" "Initialize hash
" h = Hashify(dict)
"
" h.data => dict
" h.size => 2
" h.concat({'true' : 'false'}) => returns {'on' : 'off', 'yes' : 'no', 'true' : 'false'}
" h.merge({'true' : 'false'}) => generates the same data as `concat' but
"                                stores it back in `h', returns nothing
" h.upcase => {'ON' : 'OFF', 'YES' : 'NO'}
" h.inverse => {'off' : 'on', 'no' : 'yes'}
"
