if exists("b:current_syntax")
    finish
endif

syn keyword jsonKeyword null true false


hi link jsonKeyword Boolean


let b:current_syntax = "json"
