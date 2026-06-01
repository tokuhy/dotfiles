# brewでインストールしたkeychainの設定
case "${OSTYPE}" in
    darwin*)
    # keychainが入っているときだけ設定（未インストール環境でのエラー回避）
    if type keychain &>/dev/null; then
        keychain -q ~/.ssh/tokuhy ~/.ssh/tokuhy-nopass ~/.ssh/tokuyama.key
        [ -z "$HOSTNAME" ] && HOSTNAME=`uname -n`
        [ -f $HOME/.keychain/$HOSTNAME-sh ] && \
                . $HOME/.keychain/$HOSTNAME-sh
        [ -f $HOME/.keychain/$HOSTNAME-sh-gpg ] && \
                . $HOME/.keychain/$HOSTNAME-sh-gpg
    fi
    ;;
esac
