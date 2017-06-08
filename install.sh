#!/usr/bin/env bash

DATE=$(date +%s)
BACKUP="${HOME}/.dotfiles-${DATE}"
ITERM="${HOME}/Library/Preferences/com.googlecode.iterm2.plist"

mkdir "${BACKUP}"
echo -e "\ncreating backup folder for dotfiles in ${BACKUP}...\n"

# Make backup of current dotfiles
for dotfile in $(git ls-files | cut -f1 -d/ | grep '^\.' | uniq); do
	pwd=$(pwd)

	if [[ -L "${HOME}/${dotfile}" || -d "${HOME}/${dotfile}" ]]; then
		mv "${HOME}/${dotfile}" "${BACKUP}"
	fi

	# This will end up going in preferences
	if [ "${pwd}/${dotfile}" == "${pwd}/.iterm2.plist" ]; then
		mv "${ITERM}" "${BACKUP}"
		# don't symlink iTerm config as it will get converted to binary
		# and we don't want to accidentally commit that
		cp "${pwd}/${dotfile}" "${ITERM}"
		continue
	fi

	ln -vsfn "${pwd}/${dotfile}" "${HOME}/${dotfile}"
done

echo -e "\ninstalling vim plugins..."
vim +PlugInstall +qall
