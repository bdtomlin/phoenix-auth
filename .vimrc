map <leader>t :w<CR>:call VimuxRunCommand("clear; mix test " . bufname("%"))<CR>
map <leader>T :w<CR>:call VimuxRunCommand("clear; mix test " . bufname("%") . " --only line:" . line("."))<CR>
map <silent><leader>a :if &mod<CR>w<CR>endif<CR>:call VimuxRunCommand("clear; mix test")<CR>
