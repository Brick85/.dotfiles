#!/bin/bash

# dirs=`{ echo base; find ~/projects -maxdepth 2 -type d; echo "~/.config/nvim"; }`
# selected=$(echo "$dirs" | fzf)
# dirs=`~/.dotfiles/bin/find-projects`
selected=$(~/.dotfiles/bin/find-projects | fzf)

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ $selected_name == "base" ]]; then
    selected_name="0"
fi

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    echo tmux new-session -ds $selected_name -c $selected
    tmux new-session -ds $selected_name -c $selected
fi

tmux switch-client -t $selected_name
