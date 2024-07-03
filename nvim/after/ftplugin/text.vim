" XXX: somehow some help pages invoke text.vim and some do not
" | I have absolutely no clue whatsoever how and why this happens
if &buftype == "help"
  runtime after/ftplugin/help.vim
  finish
endif

setlocal list
setlocal wrap
