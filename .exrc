function! Go_to_input()
    let l:bunch = system('cat .bunches/.installed')
    let l:test = system('cat .bunches/.installed-' . l:bunch)
    execute "edit inputs/" . fnamemodify(l:test, ':h')
endfunction

function! Go_to_test_dir()
    let l:bunch = system('cat .bunches/.installed')
    let l:test = system('cat .bunches/.installed-' . l:bunch)
    execute "edit tests/" . l:test
endfunction

nnoremap gi :call Go_to_input()<cr>
nnoremap go :call Go_to_test_dir()<cr>
