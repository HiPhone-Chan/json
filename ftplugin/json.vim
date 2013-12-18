"
"Author:Hi Phone Chan
"

let s:newline = "\n"
let s:tab = "   "

function! s:formatString(obj, level) "{{{2
    let l:buffer = ''
    let l:isFirst = 1
    if type(a:obj) == type({})
	let l:buffer .= "{"
	for key in keys(a:obj)
	    if isFirst
	    else
		let l:buffer .= ','
	    endif

	    let l:buffer .= s:newline
	    let l:buffer .= s:getIndents(a:level + 1)
	    let l:buffer .= ('"'.key.'" : ')
	    let l:buffer .= s:formatString(a:obj[key], a:level + 1)
	    let l:isFirst = 0
	endfor
	if isFirst
	    let l:buffer .= "}"
	else
	    let l:buffer .= s:newline
	    let l:buffer .= (s:getIndents(a:level)."}")
	endif
    elseif type(a:obj) == type([])
	let l:buffer .= "["
	let l:tmpcount = 0
	while l:tmpcount < len(a:obj)
	    if isFirst
	    else
		let l:buffer .= ','
	    endif

	    let l:buffer .= s:newline
	    let l:buffer .= s:getIndents(a:level + 1)
	    let l:buffer .= s:formatString(a:obj[l:tmpcount], a:level + 1)
	    let l:tmpcount += 1
	    let l:isFirst = 0
	endwhile
	if isFirst
	    let l:buffer .= "]"
	else
	    let l:buffer .= s:newline
	    let l:buffer .= (s:getIndents(a:level)."]")
	endif
    elseif  type(a:obj) == type("")
	let l:buffer = '"'.a:obj.'"'
    else  
	let l:buffer = string(a:obj)
    endif
    return l:buffer
endfunction

function! s:getIndents(num)   "{{{2
    let l:indents = ''
    let l:tmp = 0
    while l:tmp < a:num
	let l:indents .= s:tab
	let l:tmp += 1
    endwhile
    return l:indents
endfunction

function! FormatJSON()
    try
	let l:contents = join(getline(1, "$"))
	let l:obj = eval(l:contents)
	let l:buf = s:formatString(l:obj, 0)
	exe "normal! ggdGi".l:buf
    catch
    endtry
endfunction

nnoremap <buffer> <silent> <F5> :setf json<CR>
nnoremap <C-S-f> :call FormatJSON()<CR>
