let g:misc_project_root_markers = []

let g:misc = {
  \ 'project_root_markers': extend(['.git', '.hg'], get(g:, 'misc_project_root_markers')),
\ }
