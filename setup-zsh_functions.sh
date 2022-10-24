#!/usr/bin/env bash

# shellcheck source=/dev/null
source ./lib.sh

function update_file() {

    # pr_info "Backing up .zshrc to .zshrc_bup"
    res=$(cp ~/.zshrc ~/.zshrc_bup)
    file="$HOME/.zshrc"
    log_result "$?" "$res" "Backing up .zshrc to .zshrc_bup."

    # pr_info "Appending themes in ~/.zshrc & enabling \"bira\"."
    res=$(append_in_file "$file" "# ## ### #### ### ## #" \
        "## Setting Themes" \
        "ZSH_THEME=\"bira\"" \
        "# # ZSH_THEME=\"robbyrussell\"" \
        "")
    log_result "$?" "$res" "Appending themes in ~/.zshrc & enabling \"bira\"."

    # pr_info "Configuring 'compleat' in ~/.zshrc."
    res=$(append_in_file "$file" "# ## ### #### ### ## #" \
        "## Setting auto-compleat" \
        "autoload -Uz compinit bashcompinit" \
        "compinit" \
        "bashcompinit" \
        "source ~/.bash_completion.d/compleat_setup" \
        "")
    log_result "$?" "$res" "Configuring 'compleat' in ~/.zshrc."

    # pr_info "Configuring background color for NTFS folders in ~/.zshrc."
    res=$(append_in_file "$file" "# ## ### #### ### ## #" \
        "## Update NTFS folder background color in terminal" \
        "LS_COLORS+=':ow=01;33'" \
        "")
    log_result "$?" "$res" "Configuring background color for NTFS folders in ~/.zshrc."

    # pr_info "Configure zsh auto update by reminder in ~/.zshrc."
    res=$(append_in_file "$file" "# ## ### #### ### ## #" \
        "## Prompt for update" \
        "zstyle ':omz:update' mode reminder  # just remind me to update when it's time" \
        "")
    log_result "$?" "$res" "Configure zsh auto update by reminder in ~/.zshrc."

    # pr_info "Enabling more 'plugins' in ~/.zshrc."
    res=$(sed -i '/^plugins\=(.*/c\plugins=(git zsh-autosuggestions zsh-interactive-cd fzf docker-compose aliases copyfile common-aliases sudo jsontools)' "$file")
    log_result "$?" "$res" "Enabling more 'plugins' in ~/.zshrc."
    
}
