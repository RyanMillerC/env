#!/bin/bash
#
# Set up MacOS environment
#

echo "This will replace your settings. Are you sure you want to do this? (n/Y)"

read confirm
[[ ${confirm} = y || ${confirm} = Y ]] || exit 1

dotfiles='
.bash_profile
.bashrc
.gitconfig
.inputrc
'
for file in ${dotfiles} ; do
    [[ -f ${HOME}/${file} ]] && mv ${HOME}/${file}{,.bak} # Backup just in case
    cp ${file} ${HOME}
done

[[ ! -d ${HOME}/.config ]] && mkdir ${HOME}/.config
[[ -d ${HOME}/.config/karabiner ]] && mv ${HOME}/.config/karabiner{,.bak}
cp -r .config/karabiner ${HOME}/.config

iterm_profile="${HOME}/Library/Application Support/iTerm2/DynamicProfiles/iterm_profiles.json"
[[ -f "${iterm_profile}" ]] && mv "${iterm_profile}"{,.bak}
cp iterm_profiles.json "${iterm_profile}"

echo "Completed!"

