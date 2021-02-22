#!/usr/bin/env bash

clear
echo "Bootstrap Script for Linix by Andrei Jiroh"
echo "Starting up in 3 seconds..."
sleep 3

echo "==> Checking for GitLab Auth tokens in env..."

if [[ $GH_PAT == "" ]] && [[ $GH_USERNAME == "" ]]; then
    echo "⚠ GH_USERNAME and GH_PAT can't be blank!"
    exit 1
elif [[ $GH_USERNAME != "AndreiJirohHaliliDev2006" ]]; then
    echo "⚠ Only Andrei Jiroh can do this!"
    exit 1
elif [[ $GH_USERNAME == "AndreiJirohHaliliDev2006" ]] && [[ $GH_PAT == "" ]]; then
    echo "⚠ Missing GitLab.com PAT!"
    exit 1
else
    echo "⚠ Proceeding, please don't expect if things go brrr..."
fi

if echo $OSTYPE | grep linux-android.*; then
    # Assuming that you ibstalled wget and curl
    echo "==> Installing dependencies..."
    pkg install man git nano gnupg openssh python nodejs

    # Clone our stuff
    echo "==> Cloning the dotfiles repo"
    git clone https://github.com/AndreiJirohHaliliDev2006/.dotfiles.git
    cd .dotfiles && git clone https://$GH_USERNAME:$GH_PAT@gitlab.com/AndreiJirohHaliliDev2006/dotfiles-secrets secrets
    chmod 600 secrets

    if [[ $? != 0 ]]; then
       echo "❌ That kinda sus, but only Andrei Jiroh can proceed!"
       exit 1
    fi

    # Importing our SSH keys
    echo "==> Importing SSH keys..."
    mkdir ~/.ssh || echo "warning: ~/.ssh exists!"
    cp secrets/ssh/github-personal ~/.ssh/github-personal
    cp secrets/ssh/github-personal.pub ~/.ssh/github-personal.pub
    chmod 600 ~/*ssh/github-personal

    # Link softly
    echo "==> Creating soft links for .bashrc and .gitconfig"
    ln -s termux.bashrc ~/.bashrc
    ln -s termux.gitconfig ~/.gitconfig

    echo "✔ Task completed. Now, you need to manually import your"
    echo "  PGP keys with the included import-pgp-keys script."
elif echo $OSTYPE | grep linux-gnu.* && ;then
else
    echo "Todo"
fi
