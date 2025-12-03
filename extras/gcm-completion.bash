# Bash completion for gcm.sh

__gcm_complete() {
    local cur
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    # Top-level commands
    local cmds="setup add-users rotate-user revoke-user nuclear-rotate unencrypt doctor backup restore version --version help"

    # Default completions only — no doctor sub-flags anymore
    mapfile -t COMPREPLY < <(compgen -W "${cmds}" -- "${cur}")
    return 0
}

complete -F __gcm_complete gcm.sh

# echo "source /path/to/gcm-completion.bash" >> ~/.bashrc
# or ~/.bash_profile depending on your setup
# source ~/.bashrc
