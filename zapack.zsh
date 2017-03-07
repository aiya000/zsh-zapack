#!/usr/bin/env zsh

# Execute `git submodule update --init` for a repository
function git_submudule_pull () {
	local repo="$1"

	# Save directory stack
	#NOTE: Don't use pushd and popd, because it may cannot restore previous directory
	local cur_dir=$(pwd)
	local prev_dir=$(cd - > /dev/null 2>&1; pwd; cd - > /dev/null 2>&1)

	#NOTE: Support recursive pull if it is needed
	# Pull submodules
	cd "$repo" > /dev/null
	git submodule update --init --recursive

	# Resume directory stack
	cd "$prev_dir"
	cd "$cur_dir"
}

# Get repository name of the directory
# Ex: $1='.zsh/zapack/repos/zapack.zsh' ==> zapack.zsh
function get_repo_name () {
	local repo_dir="$1"
	echo "$repo_dir" | sed -r 's;^(.*/)*;;'
}


# Ex: $1='zsh-zapack' ==> zapack
function extract_name_from_case_of_prefix_zsh () {
	echo "$1" | sed -r 's/zsh-(.*)/\1/'
}

# Ex: $1='sh-hereis' ==> hereis
function extract_name_from_case_of_prefix_sh () {
	echo "$1" | sed -r 's/sh-(.*)/\1/'
}

# Load a plugin's init script.
# For example:
#   zsh-shell-kawaii/zsh-shell-kawaii.zsh (the case of {name}.zsh)
#   auto-fu.zsh/auto-fu.zsh (the case of {name})
function load_init_script_if_available () {
	local repo="$1"
	local repo_name=$(get_repo_name "$repo")

	if [ -f "$repo/$repo_name.zsh" ] ; then
		source "$repo/$repo_name.zsh"
		return
	elif [ -f "$repo/$repo_name.sh" ] ; then
		source "$repo/$repo_name.sh"
		return
	elif [ -f "$repo/$repo_name" ] ; then
		source "$repo/$repo_name"
		return
	fi

	repo_name=$(extract_name_from_case_of_prefix_zsh "$repo")
	if [ -f "$repo/$repo_name.zsh" ] ; then
		source "$repo/$repo_core_name.zsh"
	fi

	repo_core_name=$(extract_name_from_case_of_prefix_sh "$repo")
	if [ -f "$repo/$repo_name.sh" ] ; then
		source "$repo/$repo_core_name.sh"
	fi
}


# Add repos to runtime paths
for repo in $(ls -d "$ZAPACK_REPODIR"/*) ; do
	PATH=$PATH:$repo
	git_submudule_pull "$repo"
	load_init_script_if_available "$repo"
done
