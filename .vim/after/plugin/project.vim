" カレントディレクトリに .vimprojects があれば読み込む
"if getcwd() != $HOME
    if filereadable(getcwd(). '/.vimprojects')
        Project .vimprojects
    endif
"endif
