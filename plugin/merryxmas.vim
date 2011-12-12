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
        if a:bang
            let [x, y] = [getwinposx(), getwinposy()]
            try
                winpos 0 0
                sleep 100m
                for _ in range(10)
                    call s:move_to('v')
                    call s:move_to('>')
                    sleep 100m
                endfor
                for _ in range(10)
                    call s:move_to('^')
                    call s:move_to('>')
                    sleep 100m
                endfor
                redraw
                echo 'Thanks for flying Vim.'
            finally
                " Restore winpos.
                execute 'winpos' x y
            endtry
        endif
    endtry
endfunction

" this function is from winmove.vim
let s:DX = 20
let s:DY = 15
function! s:move_to(dest)
    if has('gui_running')
        let winpos = { 'x':getwinposx(), 'y':getwinposy() }
    else
        redir => out | silent! winpos | redir END
        let mpos = matchlist(out, '^[^:]\+: X \(-\?\d\+\), Y \(-\?\d\+\)')
        if len(mpos) == 0 | return | endif
        let winpos = { 'x':mpos[1], 'y':mpos[2] }
    endif
    let repeat = v:count1

    if a:dest == '>'
        let winpos['x'] = winpos['x'] + s:DX * repeat
    elseif a:dest == '<'
        let winpos['x'] = winpos['x'] - s:DX * repeat
    elseif a:dest == '^'
        let winpos['y'] = has("gui_macvim") ?
              \ winpos['y'] + s:DY * repeat :
              \ winpos['y'] - s:DY * repeat
    elseif a:dest == 'v'
        let winpos['y'] = has("gui_macvim") ?
              \ winpos['y'] - s:DY * repeat :
              \ winpos['y'] + s:DY * repeat
    endif
    if winpos['x'] < 0 | let winpos['x'] = 0 | endif
    if winpos['y'] < 0 | let winpos['y'] = 0 | endif

    execute 'winpos' winpos['x'] winpos['y']
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
