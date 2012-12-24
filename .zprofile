# brewでインストールたkeychainの設定
case "${OSTYPE}" in
    darwin*)
    keychain ~/.ssh/syskeeper
    [ -z "$HOSTNAME" ] && HOSTNAME=`uname -n`
    [ -f $HOME/.keychain/$HOSTNAME-sh ] && \
            . $HOME/.keychain/$HOSTNAME-sh
    [ -f $HOME/.keychain/$HOSTNAME-sh-gpg ] && \
            . $HOME/.keychain/$HOSTNAME-sh-gpg
    ;;
esac
