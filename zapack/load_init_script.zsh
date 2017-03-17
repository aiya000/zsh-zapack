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

	if [ -f "$repo/$repo_name.zsh" ] ; then
		source "$repo/$repo_name.zsh"
		if [ "$verbose_is_specified" -eq 1 ] ; then
			echo "loaded: $repo/$repo_name.zsh"
		fi
		return
	elif [ -f "$repo/$repo_name.sh" ] ; then
		source "$repo/$repo_name.sh"
		if [ "$verbose_is_specified" -eq 1 ] ; then
			echo "loaded: $repo/$repo_name.sh"
		fi
		return
	elif [ -f "$repo/$repo_name" ] ; then
		source "$repo/$repo_name"
		if [ "$verbose_is_specified" -eq 1 ] ; then
			echo "loaded: $repo/$repo_name"
		fi
		return
	fi

	repo_name=$(zpk::extract_name_from_case_of_prefix_zsh "$repo")
	if [ -f "$repo/$repo_name.zsh" ] ; then
		source "$repo/$repo_core_name.zsh"
		if [ "$verbose_is_specified" -eq 1 ] ; then
			echo "loaded: $repo/$repo_core_name.zsh"
		fi
	fi

	repo_core_name=$(zpk::extract_name_from_case_of_prefix_sh "$repo")
	if [ -f "$repo/$repo_name.sh" ] ; then
		source "$repo/$repo_core_name.sh"
		if [ "$verbose_is_specified" -eq 1 ] ; then
			echo "loaded: $repo/$repo_core_name.sh"
		fi
	fi
}
