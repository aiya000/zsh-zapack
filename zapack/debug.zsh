#!/usr/bin/env zsh

# Define variables for debugging

function zpk::check_debug_vars () {
    local -A opthash
    zparseopts -D -A opts -- -verbose
    [ -n "${opts[(i)--verbose]}" ] && echo 1 || echo 0
}

verbose_is_specified=$(zpk::check_debug_vars $ZAPACK_OPTIONS)
