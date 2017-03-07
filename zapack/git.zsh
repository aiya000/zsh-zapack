#!/usr/bin/env zsh

# For git procedures

# Execute `git submodule update --init` for a repository
function zpk::git_submudule_pull () {
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
