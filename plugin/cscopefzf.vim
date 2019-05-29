let s:targets = {
\   's': ['0', 'symbol'],
\   'd': ['1', 'function'],
\   'C': ['2', 'call'],
\   'c': ['3', 'caller'],
\   't': ['4', 'text'],
\   'e': ['6', 'egrep'],
\   'f': ['7', 'file'],
\   'i': ['8', 'includer'],
\   'a': ['9', 'assign'],
\ }

let s:reffile = get(g:, 'cscope_reffile', 'cscope.out')
let s:use_default_mappings = get(g:, 'cscope_use_default_mappings', 1)

function! Cscope(target, pattern)
    let t = s:targets[a:target]
    let formatter = " | awk 'BEGIN { print \"location\tfunction\t   text\" }; { file = $1; funk = $2; line = $3; $1 = \"\"; $2 = \"\"; $3 = \"\"; printf \"%s:%s\t%s\t%s\n\", file, line, funk, $0; }' | column -t -c2 -s\\\t"
    let opts = {
\       'source': "cscope -dL -f" . s:reffile . " -" . t[0] . " " . a:pattern . " " . formatter,
\       'options': [
\           '--ansi', '-0', '-1', '--header-lines=1',
\           '--prompt', t[1] . ' > ',
\       ],
\   }
" \           '-1',
    function! opts.sink(line)
        echo a:line
    endfunction
    call fzf#run(opts)
endfunction

function! CscopeJump(target)
endfunction

" if s:use_default_mappings
"     nnoremap <leader>s :call Cscope('s', expand('<cword>'))<cr>
"     nnoremap <leader>d :call Cscope('d', expand('<cword>'))<cr>
"     nnoremap <leader>C :call Cscope('C', expand('<cword>'))<cr>
"     nnoremap <leader>c :call Cscope('c', expand('<cword>'))<cr>
"     nnoremap <leader>t :call Cscope('t', expand('<cword>'))<cr>
"     nnoremap <leader>e :call Cscope('e', expand('<cword>'))<cr>
"     nnoremap <leader>f :call Cscope('f', expand('<cfile>'))<cr>
"     nnoremap <leader>i :call Cscope('i', expand('<cfile>'))<cr>
"     nnoremap <leader>a :call Cscope('a', expand('<cword>'))<cr>
" endif
