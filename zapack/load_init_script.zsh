#!/usr/bin/env zsh

# For zpk::load_init_script_if_available


# Get repository name of the directory
# Ex: $1='.zsh/zapack/repos/zapack.zsh' ==> zapack.zsh
function zpk::get_repo_name () {
    local repo_dir="$1"
    echo "$repo_dir" | sed -r 's;^(.*/)*;;'
}

# Ex: $1='zsh-zapack' ==> zapack
function zpk::extract_name_from_case_of_prefix_zsh () {
    echo "$1" | sed -r 's/zsh-(.*)/\1/'
}

# Ex: $1='sh-hereis' ==> hereis
function zpk::extract_name_from_case_of_prefix_sh () {
    echo "$1" | sed -r 's/sh-(.*)/\1/'
}


# Load a plugin's init script.
# For example:
#   zsh-shell-kawaii/zsh-shell-kawaii.zsh (the case of {name}.zsh)
#   auto-fu.zsh/auto-fu.zsh (the case of {name})
function zpk::load_init_script_if_available () {
    local repo="$1"
    local repo_name=$(zpk::get_repo_name "$repo")
    local script

    # Use "find -print -quit" to print the first matching file
    script=$(find \
        "$repo/$repo_name.zsh" "$repo/$repo_name.sh" "$repo/$repo_name" \
        "$repo/$(zpk::extract_name_from_case_of_prefix_zsh "$repo_name").zsh" \
        "$repo/$(zpk::extract_name_from_case_of_prefix_sh "$repo_name").sh" \
        -maxdepth 0 -type f -print -quit 2> /dev/null
    )

    if [[ -f $script ]] ; then
        source "$script"
        if [ "$verbose_is_specified" -eq 1 ] ; then
            echo "loaded: $script"
        fi
    fi
}
