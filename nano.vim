set nocompatible
let s:hidden_all = 1
set noshowmode
set noruler
set laststatus=0
set noshowcmd
set hlsearch!

highlight EndOfBuffer ctermfg=0
set shortmess+=I
highlight StatusLine ctermfg=0 ctermbg=0 cterm=NONE
highlight StatusLineNC ctermfg=0 ctermbg=0 cterm=NONE

" Vim8 Specific
highlight StatusLineTerm ctermfg=0 ctermbg=0 cterm=NONE
highlight StatusLineTermNC ctermfg=0 ctermbg=0 cterm=NONE

let g:neoterm_autoscroll = 1


function! DrawLayout()
    " Top bar buffer
    split
    let s:path = expand('<sfile>:p:h')
    enew
    resize 1
    if has('nvim')
        call termopen('python '.s:path.'/topbar.py')
    else
        terminal ++curwin python ./topbar.py
    endif

    " File display buffer
    wincmd j
    if @% == ""
        enew
    endif

    " Bottom bar buffer
    split
    wincmd j
    resize 3
    enew
    if has('nvim')
        call termopen('python '.s:path.'/botbar.py')
        execute "$"
    else
        terminal ++curwin python ./botbar.py
    endif

    " Go back to file display buffer
    wincmd k
endfunction

set statusline=%#Normal#

" Trying to draw earlier messes things up
autocmd VimEnter * call DrawLayout()


" Handle resize
function! Resize()
    wincmd j
    resize 3
    wincmd k

    wincmd k
    resize 1
    wincmd j
endfunction

autocmd VimResized * call Resize()


" Disable command key
inoremap <silent> <esc> <nop>
" Hack to make arrow keys work with vim8
if has('nvim')
else
    inoremap <esc>x <esc>x
endif


function! ForceExit()
    qa!
endfunction


function! PromptSave()
    if @% != ""
        write
        return 1
    endif
    let l:name = input('File Name to Write: ')
    if (l:name == "")
        return 0
    else
        execute "write! ".l:name
        return 1
    endif
endfunction
" Save file
nnoremap <C-O> :call PromptSave()<cr>
inoremap <silent> <C-O> <C-O>:call PromptSave()<cr>


function! OpenFile()
    let l:name = input('File to insert [from ./]: ')
    if (l:name == "")
    else
        execute "read ".l:name
    endif
endfunction
" Read file
nnoremap <C-R> :call OpenFile()<cr>
inoremap <silent> <C-R> <C-O>:call OpenFile()<cr>
 

function! Exit()
    if &mod
        call inputsave()
        let name = confirm('Save modified buffer? (Answering "No" will DISCARD changes.) ', "Yes\nNo\nCancel")
        if (name==3)
        elseif (name == 2)
            call ForceExit()
        else
            if PromptSave() == 1
                call ForceExit()
            else
            endif
        endif

    else
        call ForceExit()
    endif
endfunction
" Exit app
nnoremap <C-X> :call Exit()<cr>
inoremap <silent> <C-X> <C-O>:call Exit()<cr>


function! SearchFile()
    let l:name = input('Search: ')
    if (name == "")
    else
        call feedkeys("\<C-\>\<C-o>/".name."\<CR>")
    endif
endfunction
" Search file
nnoremap <C-F> :call SearchFile()<cr>
inoremap <silent> <C-F> <C-O>:call SearchFile()<cr>


function! ShowInfo()
    let curline = line('.')
    let totalline = line('$')
    let curcol = col('.')
    let totalcol = col('$')
    let lineperc = 100 * curline / totalline
    let colperc = 100 * curcol / totalcol
    echo "[ line ". curline . "/". totalline ." (".lineperc."%), col ".curcol. "/".totalcol." (".colperc."%) ]"
endfunction
" Show cursor info
nnoremap <C-C> :call ShowInfo()<cr>
inoremap <silent> <C-C> <C-O>:call ShowInfo()<cr>


function! GotoLine()
    let name = input('Enter line number, column number: ')
    if (name == "")
    else
        let newlist = split(name, "[ ,]")
        let cnt = 0
        let r = line(".")
        let c = col(".")
        for i in newlist
            if i != ""
                if cnt == 0
                    let r = i
                elseif cnt == 1
                    let c = i
                endif
            endif
            let cnt += 1
        endfor
        call cursor(r, c)
    endif
endfunction
" Goto line, col
nnoremap <C-_> :call GotoLine()<cr>
inoremap <silent> <C-_> <C-O>:call GotoLine()<cr>


" Page up
nnoremap <C-Y> <PageUp>
inoremap <silent> <C-Y> <PageUp>


" Page down
nnoremap <C-V> <PageDown>
inoremap <silent> <C-V> <PageDown>


function! FirstLine()
    call feedkeys("\<C-\>\<C-o>gg")
endfunction

function! LastLine()
    call feedkeys("\<C-\>\<C-o>G")
endfunction
" First Line
nnoremap <A-\> :call FirstLine()<cr>
inoremap <silent> <A-\> <C-O>:call FirstLine()<cr>
" Last Line
nnoremap <A-/> :call LastLine()<cr>
inoremap <silent> <A-/> <C-O>:call LastLine()<cr>


" Search forward
inoremap <silent> <A-f> <C-O>n


" Match parenthesis
inoremap <silent> <A-]> <C-O>%


function! VisualMode()
    call feedkeys("\<C-\>\<C-o>v")
endfunction
" Mark Text
nnoremap <C-^> :call VisualMode()<cr>
inoremap <silent> <C-^> <C-O>:call VisualMode()<cr>


" Copy Text
vnoremap <A-c> y


" Indent
inoremap <silent> <A-}> <C-O>>>
inoremap <silent> <A-{> <C-O><<


" Justify
inoremap <silent> <C-J> <C-O>gqk


" Col nav
inoremap <silent> <C-L> <C-o>l
inoremap <silent> <C-k> <C-o>h


" Word nav
inoremap <silent> <C-q> <C-o>b
inoremap <silent> <C-e> <C-o>w


" Start insert mode
startinsert
