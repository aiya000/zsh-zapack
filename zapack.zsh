#!/usr/bin/env zsh
source $(dirname $0)/zapack/load_init_script.zsh
source $(dirname $0)/zapack/git.zsh
source $(dirname $0)/zapack/debug.zsh

# Add repos to runtime paths
for repo in $(ls -d "$ZAPACK_REPODIR"/*) ; do
	PATH=$PATH:$repo
	zpk::git_submudule_pull "$repo"
	zpk::load_init_script_if_available "$repo"
done
