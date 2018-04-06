let s:hidden_all = 1
set noshowmode
set noruler
set laststatus=0
set noshowcmd

highlight EndOfBuffer ctermfg=black ctermbg=black
set shortmess+=I
highlight StatusLine ctermfg=black ctermbg=black cterm=NONE
highlight StatusLineNC ctermfg=black ctermbg=black cterm=NONE

function! DrawLayout()
    " Top bar buffer
    split
    let s:path = expand('<sfile>:p:h')
    enew
    resize 1
    call termopen('python '.s:path.'/topbar.py')

    " File display buffer
    wincmd j
    if @% == ""
        enew
    endif

    " Bottom bar buffer
    split
    wincmd j
    resize 2
    enew
    call termopen('python '.s:path.'/botbar.py')

    " Go back to file display buffer
    wincmd k
endfunction

" Trying to draw earlier messes things up
autocmd VimEnter * call DrawLayout()


" Restore input
function! RestoreInput()
    startinsert
    redraw
endfunction

" Handle resize
function! Resize()
    wincmd j
    resize 2
    wincmd k

    wincmd k
    resize 1
    wincmd j
endfunction

autocmd VimResized * call Resize()


" inoremap jk <esc>
inoremap <esc> <nop>

function! ForceExit()
    call feedkeys("\<C-\>\<C-n>:qa!\<CR>")
endfunction

function! PromptSave()
    if @% != ""
        write
        return 1
    endif
    let name = input('File Name to Write: ')
    echo
    if (name == "")
        return 0
    else
        call feedkeys("\<C-\>\<C-n>:w! ".name."\<CR>")
        return 1
    endif
endfunction

function! OpenFile()
    let name = input('File to insert [from ./]: ')
    if (name == "")
    else
        read name
    endif
    echo
endfunction

function! Exit()
    if &mod
        call inputsave()
        let name = confirm('Save modified buffer? (Answering "No" will DISCARD changes.) ', "Yes\nNo\nCancel")
        if (name==3)
            echo
            call RestoreInput()
        elseif (name == 2)
            call ForceExit()
        else
            if PromptSave() == 1
                call ForceExit()
            else
                echo
                call RestoreInput()
            endif
        endif

    else
        call ForceExit()
    endif
endfunction

nnoremap <C-X> :call Exit()<cr>
inoremap <C-X> <C-O>:call Exit()<cr>

nnoremap <C-O> :call PromptSave()<cr>
inoremap <C-O> <C-O>:call PromptSave()<cr>

nnoremap <C-R> :call OpenFile()<cr>
inoremap <C-R> <C-O>:call OpenFile()<cr>
 
function! SearchFile()
    let name = input('Search: ')
    if (name == "")
    else
        call feedkeys("\<C-\>\<C-n>/".name."\<CR>")
    endif
    echo
    call RestoreInput()
endfunction

nnoremap <C-F> :call SearchFile()<cr>
inoremap <C-F> <C-O>:call SearchFile()<cr>

function! ReplaceFile()
    let name = input('Search: ')
    if (name == "")
    else
        call feedkeys("\<C-\>\<C-n>/".name."\<CR>")
    endif
    echo
    call RestoreInput()
endfunction
nnoremap <C-F> :call SearchFile()<cr>
inoremap <C-F> <C-O>:call SearchFile()<cr>

function! ShowInfo()
    let curline = line('.')
    let totalline = line('$')
    let curcol = col('.')
    let totalcol = col('$')
    let lineperc = 100 * curline / totalline
    let colperc = 100 * curcol / totalcol
    echo "[ line ". curline . "/". totalline ." (".lineperc."%), col ".curcol. "/".totalcol." (".colperc."%) ]"
    echo
    call RestoreInput()
endfunction
nnoremap <C-C> :call ShowInfo()<cr>
inoremap <C-C> <C-O>:call ShowInfo()<cr>


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
        call feedkeys("\<C-\>\<C-n>".r."G")
        call feedkeys("\<C-\>\<C-n>0".c."l")
    endif
    echo
    call RestoreInput()
endfunction
nnoremap <C-_> :call GotoLine()<cr>
inoremap <C-_> <C-O>:call GotoLine()<cr>

function! PageUp()
    call feedkeys("\<C-\>\<C-n>\<PageUp>")
    echo
    call RestoreInput()
endfunction

function! PageDown()
    call feedkeys("\<C-\>\<C-n>\<PageDown>")
    echo
    call RestoreInput()
endfunction

nnoremap <C-Y> :call PageUp()<cr>
inoremap <C-Y> <C-O>:call PageUp()<cr>

nnoremap <C-V> :call PageDown()<cr>
inoremap <C-V> <C-O>:call PageDown()<cr>

function! FirstLine()
    call feedkeys("\<C-\>\<C-n>gg")
    echo
    call RestoreInput()
endfunction

function! LastLine()
    call feedkeys("\<C-\>\<C-n>G")
    echo
    call RestoreInput()
endfunction

nnoremap <A-\> :call FirstLine()<cr>
inoremap <A-\> <C-O>:call FirstLine()<cr>

nnoremap <A-/> :call LastLine()<cr>
inoremap <A-/> <C-O>:call LastLine()<cr>

function! NextSearch()
    call feedkeys("\<C-\>\<C-n>n")
    echo
    call RestoreInput()
endfunction
inoremap <A-f> <C-O>n

inoremap <A-]> <C-O>%


function! VisualMode()
    call feedkeys("\<C-\>\<C-n>v")
    echo
    call RestoreInput()
endfunction
nnoremap <C-^> :call VisualMode()<cr>
inoremap <C-^> <C-O>:call VisualMode()<cr>

vnoremap <A-c> y<cr>

inoremap <A-}> <C-O>>>
inoremap <A-{> <C-O><<

inoremap <C-J> <C-O>gqk
call feedkeys('i')

set hlsearch!

inoremap <C-L> <C-o>l
inoremap <C-k> <C-o>h

inoremap <C-q> <C-o>b
inoremap <C-e> <C-o>w
