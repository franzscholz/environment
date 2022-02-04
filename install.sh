#!/usr/bin/env bash

# From https://medium.com/mkdir-awesome/posix-alternatives-for-readlink-21a4bfe0455c
readlinkf() {
    [ "${1:-}" ] || return 1
    max_symlinks=40
    CDPATH='' # to avoid changing to an unexpected directory

    target=$1
    [ -e "${target%/}" ] || target=${1%"${1##*[!/]}"} # trim trailing slashes
    [ -d "${target:-/}" ] && target="$target/"

    cd -P . 2>/dev/null || return 1
    while [ "$max_symlinks" -ge 0 ] && max_symlinks=$((max_symlinks - 1)); do
        if [ ! "$target" = "${target%/*}" ]; then
            case $target in
            /*) cd -P "${target%/*}/" 2>/dev/null || break ;;
            *) cd -P "./${target%/*}" 2>/dev/null || break ;;
            esac
            target=${target##*/}
        fi

        if [ ! -L "$target" ]; then
            target="${PWD%/}${target:+/}${target}"
            printf '%s\n' "${target:-/}"
            return 0
        fi
        link=$(ls -dl -- "$target" 2>/dev/null) || break
        target=${link#*" $target -> "}
    done
    return 1
}

self=$(readlinkf "$0")
script_dir=${self%/*}
dest_dir=${HOME}

# Setup the Brewfile
rm -f ${dest_dir}/Brewfile
ln -s ${script_dir}/Brewfile ${dest_dir}/Brewfile

# Install everything via Homebrew
brew bundle install --force

# Install the .bashrc
rm -f ${dest_dir}/.bashrc
ln -s ${script_dir}/.bashrc ${dest_dir}/.bashrc

# Install the .bash_profile
rm -f ${dest_dir}/.bash_profile
ln -s ${script_dir}/.bash_profile ${dest_dir}/.bash_profile

# TODO: Add oh-my-zsh installation.
if [ ! -d ~/.oh-my-zsh ] ; then
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
else
    (cd ~/.oh-my-zsh && git pull)
fi

# Install the zshrc
rm -f ${dest_dir}/.zshrc
ln -s ${script_dir}/.zshrc ${dest_dir}/.zshrc

