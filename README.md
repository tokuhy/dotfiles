# Install
```
$ cd ~
$ git clone https://github.com/tokuhy/dotfiles.git
$ cd dotfiles
$ ./setup install
$ git submodule ini
$ git submodule update
```

`git submodule update` で fatal error が出る場合は以下
```
$ cd ~/dotfiles/.vim/bundle/neobundle.vim/
$ git reset --hard
$ cd ../
$ git commit -a
```

以上
