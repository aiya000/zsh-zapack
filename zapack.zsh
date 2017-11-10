#!/usr/bin/env zsh
source $(dirname $0)/zapack/load_init_script.zsh
source $(dirname $0)/zapack/git.zsh
source $(dirname $0)/zapack/debug.zsh


function zpk::add_to_paths () {
    local repo="$1"
    PATH=$PATH:$repo
    FPATH=$FPATH:$repo

    if [ "$verbose_is_specified" -eq 1 ] ; then
        echo "$repo was added to \$PATH and \$FPATH"
    fi
}

# Add repos to runtime paths
# and Load init scripts
function zapack-init () {
    for repo in $(ls -d "$ZAPACK_REPODIR"/*) ; do
        if [[ -z $(ls $repo) ]] ; then
            echo empty repository detected: $repo
        else
            zpk::add_to_paths "$repo"
            zpk::load_init_script_if_available "$repo"
        fi
    done
}

# Pull registered modules
# and Load it
function zapack-install () {
    for repo in $(ls -d "$ZAPACK_REPODIR"/*) ; do
        zpk::git_submudule_pull "$repo"
    done
    zapack-init
}

zapack-init
