let g:misc_cscope_reffile = get(g:, 'misc_cscope_reffile', 'cscope.out')

if !executable('cscope')
  echom "cscope executable not found"
  finish
endif

function! misc#cscope#fzf(...)
  let options = extend({
    \ 'dest': 'return',
    \ 'target': '4',
    \ 'pattern': '',
  \ }, a:0 ? a:1 : {})

  let format = "awk 'BEGIN { print \"position\tcontext\t   line\" }; { file = $1; context = $2; line = $3; $1 = \"\"; $2 = \"\"; $3 = \"\"; printf \"%s:%s\t%s\t%s\n\", file, line, context, $0; }' | column -t -c2 -s\\\t"
  let fzf_options = {
    \ 'source': "cscope -dL -f" . g:misc_cscope_reffile . " -" . options.target . " " .
    \     options.pattern . " | " . format,
    \ 'options': ['--header-lines=1', '--prompt', '> '],
  \ }

  echom options
  let result = fzf#run(fzf_options)
  if len(result) == 0
    return
  endif
  let position = split(matchstr(result[0], "\\v^[^:]+:\\d+"), ':')
  
  if options.dest == 'return'
    return position
  else
    execute printf("silent! %s +%s %s", options.dest, position[1], position[0])
  endif
endfunction
