" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Load Once {{{
if (exists('g:loaded_merryxmas') && g:loaded_merryxmas) || &cp
    finish
endif
let g:loaded_merryxmas = 1
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}



command! -bang MerryXmas call s:MerryXmas(<bang>0)




function! s:MerryXmas(bang)
    " TODO: bang

    call s:init_colors()
    call s:add_matches()
    redraw
    try
        let swapped = 0
        while 1
            " If user typed any key, stop a silly thing...
            if getchar(1)
                break
            endif
            call s:swap_colors(swapped)
            let swapped = !swapped
            redraw
            sleep 50m
        endwhile
    finally
        call s:delete_matches()
    endtry
endfunction

function! s:add_matches()
    for col in range(1, winwidth(0))
        call matchadd('MerryXmas' . (col % 2 ? 'Odd' : 'Even'),
        \             '\%' . col  . 'v')
    endfor
endfunction

function! s:delete_matches()
    for _ in getmatches()
        if _.group =~# '^MerryXmas\(Odd\|Even\)$'
            call matchdelete(_.id)
        endif
    endfor
endfunction

function! s:init_colors()
    " TODO: support terminal Vim
    highlight MerryXmasRed   guifg=Red
    highlight MerryXmasGreen guifg=DarkGreen
    " highlight MerryXmasRed   guifg=Red guibg=Red
    " highlight MerryXmasGreen guifg=DarkGreen guibg=DarkGreen

    highlight link MerryXmasOdd  MerryXmasRed
    highlight link MerryXmasEven MerryXmasGreen
endfunction

function! s:swap_colors(swapped)
    if a:swapped
        highlight link MerryXmasOdd  MerryXmasRed
        highlight link MerryXmasEven MerryXmasGreen
    else
        highlight link MerryXmasOdd  MerryXmasGreen
        highlight link MerryXmasEven MerryXmasRed
    endif
endfunction



" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
