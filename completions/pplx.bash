#!/usr/bin/env bash
#
# Bash completion for Perplexity CLI

_pplx_completion() {
    local cur prev words cword
    _init_completion || return
    
    local commands="init thread image ask export help version"
    local thread_commands="list switch new"
    local image_commands="generate list"
    local export_commands="md pdf"
    
    case $prev in
        pplx)
            COMPREPLY=($(compgen -W "$commands" -- "$cur"))
            ;;
        thread)
            COMPREPLY=($(compgen -W "$thread_commands" -- "$cur"))
            ;;
        image)
            COMPREPLY=($(compgen -W "$image_commands" -- "$cur"))
            ;;
        export)
            COMPREPLY=($(compgen -W "$export_commands" -- "$cur"))
            ;;
        switch)
            local threads
            threads=$(find "${PPLX_THREADS_DIR}" -type d -mindepth 1 -maxdepth 1 -exec basename {} \;)
            COMPREPLY=($(compgen -W "$threads" -- "$cur"))
            ;;
        *)
            COMPREPLY=()
            ;;
    esac
    
    return 0
}

complete -F _pplx_completion pplx

