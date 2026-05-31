# fish completion for pkg (pacman wrapper)
#
# Install:
#   - System-wide: copy to /usr/share/fish/vendor_completions.d/pkg.fish
#   - Per-user:    copy to ~/.config/fish/completions/pkg.fish

function __pkg_no_subcommand
    set -l cmd (commandline -opc)
    test (count $cmd) -le 1
end

function __pkg_using_subcommand
    set -l cmd (commandline -opc)
    if test (count $cmd) -lt 2
        return 1
    end
    contains -- $cmd[2] $argv
end

function __pkg_all_packages
    pacman -Slq 2>/dev/null
end

function __pkg_installed_packages
    pacman -Qq 2>/dev/null
end

# Top-level subcommands
complete -c pkg -f -n __pkg_no_subcommand -a install      -d 'Install packages (pacman -S)'
complete -c pkg -f -n __pkg_no_subcommand -a reinstall    -d 'Reinstall packages (pacman -S)'
complete -c pkg -F -n __pkg_no_subcommand -a add          -d 'Install from a local package file (pacman -U)'
complete -c pkg -f -n __pkg_no_subcommand -a fetch        -d 'Download but do not install (pacman -Sw)'
complete -c pkg -f -n __pkg_no_subcommand -a uninstall    -d 'Remove packages and unused deps (pacman -Rs)'
complete -c pkg -f -n __pkg_no_subcommand -a remove       -d 'Alias for uninstall'
complete -c pkg -f -n __pkg_no_subcommand -a delete       -d 'Alias for uninstall'
complete -c pkg -f -n __pkg_no_subcommand -a purge        -d 'Remove packages, deps, config (pacman -Rns)'
complete -c pkg -f -n __pkg_no_subcommand -a update       -d 'Refresh package database (pacman -Sy)'
complete -c pkg -f -n __pkg_no_subcommand -a upgrade      -d 'Upgrade all installed packages (pacman -Syu)'
complete -c pkg -f -n __pkg_no_subcommand -a dist-upgrade -d 'Alias for upgrade'
complete -c pkg -f -n __pkg_no_subcommand -a full-upgrade -d 'Alias for upgrade'
complete -c pkg -f -n __pkg_no_subcommand -a search       -d 'Search remote packages (pacman -Ss)'
complete -c pkg -f -n __pkg_no_subcommand -a show         -d 'Show info about a package'
complete -c pkg -f -n __pkg_no_subcommand -a info         -d 'Alias for show'
complete -c pkg -f -n __pkg_no_subcommand -a list         -d 'List installed packages (pacman -Q)'
complete -c pkg -f -n __pkg_no_subcommand -a list-installed -d 'Alias for list'
complete -c pkg -f -n __pkg_no_subcommand -a list-explicit -d 'List explicitly-installed packages (pacman -Qe)'
complete -c pkg -f -n __pkg_no_subcommand -a files        -d 'List files owned by a package'
complete -c pkg -F -n __pkg_no_subcommand -a owns         -d 'Find which package owns a file (pacman -Qo)'
complete -c pkg -F -n __pkg_no_subcommand -a which        -d 'Alias for owns'
complete -c pkg -F -n __pkg_no_subcommand -a provides     -d 'Find package providing a file (pacman -F)'
complete -c pkg -f -n __pkg_no_subcommand -a orphans      -d 'List unused dependencies (pacman -Qdt)'
complete -c pkg -f -n __pkg_no_subcommand -a version      -d 'List packages with updates (pacman -Qu)'
complete -c pkg -f -n __pkg_no_subcommand -a check        -d 'Verify installed package files (pacman -Qk)'
complete -c pkg -f -n __pkg_no_subcommand -a autoremove   -d 'Remove unused dependencies'
complete -c pkg -f -n __pkg_no_subcommand -a clean        -d 'Remove cached packages (pacman -Sc)'
complete -c pkg -f -n __pkg_no_subcommand -a help         -d 'Show help'

# Arguments per subcommand
# Any-package completion (remote repos)
complete -c pkg -f -n '__pkg_using_subcommand install reinstall fetch search show info files version check' \
    -a '(__pkg_all_packages)'

# Installed-package completion
complete -c pkg -f -n '__pkg_using_subcommand uninstall remove delete purge' \
    -a '(__pkg_installed_packages)'

# File-path completion (default is file completion when -f is not set)
complete -c pkg -F -n '__pkg_using_subcommand add owns which provides'
