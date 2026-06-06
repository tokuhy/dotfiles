# Install
```
$ cd ~
$ git clone https://github.com/tokuhy/dotfiles.git
$ cd dotfiles
$ ./setup.sh install
```

# 各自の初期設定

git の identity（name / email）は共有しないので、各自 `~/.gitconfig.local` に設定する。
共有の `.gitconfig` 末尾から include される（後勝ちで上書き可能）。

```
$ cp ~/dotfiles/.gitconfig.local.example ~/.gitconfig.local
$ vi ~/.gitconfig.local   # name / email を自分のものに編集
```

git-lfs を使うリポジトリがある場合のみ、各自で有効化する。

```
$ git lfs install
```

以上
