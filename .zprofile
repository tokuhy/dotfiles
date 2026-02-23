# brewでインストールしたkeychainの設定
case "${OSTYPE}" in
    darwin*)
    keychain -q ~/.ssh/tokuhy ~/.ssh/tokuhy-nopass ~/.ssh/tokuyama.key
    [ -z "$HOSTNAME" ] && HOSTNAME=`uname -n`
    [ -f $HOME/.keychain/$HOSTNAME-sh ] && \
            . $HOME/.keychain/$HOSTNAME-sh
    [ -f $HOME/.keychain/$HOSTNAME-sh-gpg ] && \
            . $HOME/.keychain/$HOSTNAME-sh-gpg
    ;;
esac
