let s:misc = {
  \ 'project_root_markers': extend(['.git', '.hg'], get(g:, 'misc_project_root_markers')),
\ }

echom s:
function! misc#guess_project_root(...)
  let options = extend({'path': expand('%:p')}, a:0 ? a:1 : {})

  if options.path !~ '^/'
    echoerr printf("path is not absolute (path:'%s')", options.path)
  endif

  let path = options.path . '/'
  while 1
    let path = fnamemodify(path, ':h')
    if path == '/'
      break
    endif

    for m in s:misc.project_root_markers
      let f = path . '/' . m
      if filereadable(f) || isdirectory(f)
        return path
      endif
    endfor
  endwhile

  return ''
endfunction

function! misc#project_root_get()
  if !has_key(s:misc, 'project_root')
    let s:misc.project_root = misc#guess_project_root()
  endif
  echo s:misc
  return s:misc.project_root
endfunction
