# Bash completion for git-crypt-manager.sh

__git_crypt_manager_complete() {
    local cur
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    # Top-level commands
    local cmds="setup add-users rotate-user revoke-user nuclear-rotate unencrypt doctor backup restore version --version help"

    # Default completions only — no doctor sub-flags anymore
    mapfile -t COMPREPLY < <(compgen -W "${cmds}" -- "${cur}")
    return 0
}

complete -F __git_crypt_manager_complete git-crypt-manager.sh

# echo "source /path/to/git-crypt-manager-completion.bash" >> ~/.bashrc
# or ~/.bash_profile depending on your setup
# source ~/.bashrc
