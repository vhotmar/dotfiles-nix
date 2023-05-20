#!/bin/bash

function init() {
    local username="$1"
    local host="$2"

    if [[ -z "$username" || -z "$host" ]]; then
        echo "Usage: $0 [username] [host]"
        exit 1
    fi

    gpg --export-secret-keys | ssh "$username@$host" "gpg --import --batch"
    gpg --export-ownertrust | ssh "$username@$host" "gpg --import-ownertrust --batch"

    ssh -o "ForwardAgent=yes" "$username@$host" <<-EOF
    # Set up the ssh control correctly (exports each key with authentication ability from gpg)
    gpg -K --with-colons --with-fingerprint --with-keygrip | \
        awk -F: '{ if (\$1 == "ssb" && \$12 ~ "a") { getline; getline; print \$10 } }' >> ~/.gnupg/sshcontrol

    # Enable ssh support in the current running gpg-agent and adds the SSH_AUTH_SOCK variable (which tells which ssh-agent to use)
    # echo 'enable-ssh-support:0:1' | gpgconf --change-options gpg-agent
    # export SSH_AUTH_SOCK=\$(gpgconf --list-dirs agent-ssh-socket)
    # gpg-connect-agent updatestartuptty /bye

    # Trust github
    ssh-keyscan github.com >> ~/.ssh/known_hosts

    # Clone the dotfiles
    git clone git@github.com:vhotmar/dotfiles-nix.git ~/.dotfiles

    # Set up nix
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

    # Set up home manager
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install

    # Set up home manager in current shell
    . \$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh

    home-manager --flake ~/.dotfiles#$username switch -b backup
EOF
}

init "$1" "$2"
