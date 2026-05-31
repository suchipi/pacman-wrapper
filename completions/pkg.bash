#!/usr/bin/env bash
# bash completion for pkg (pacman wrapper)
#
# Install:
#   - System-wide: copy to /usr/share/bash-completion/completions/pkg
#   - Per-user:    source from your ~/.bashrc, e.g.
#                    source /path/to/pkg.bash

_pkg() {
  local cur prev cmd
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  local commands="install reinstall add fetch uninstall remove delete purge \
update upgrade dist-upgrade full-upgrade search show info list list-installed \
list-explicit files owns which provides orphans version check autoremove clean help"

  if [ "$COMP_CWORD" -eq 1 ]; then
    COMPREPLY=( $(compgen -W "$commands" -- "$cur") )
    return 0
  fi

  cmd="${COMP_WORDS[1]}"

  case "$cmd" in
    install|reinstall|fetch|search|show|info|files|version|check)
      # Complete against all known packages (sync repos).
      local pkgs
      pkgs=$(pacman -Slq 2>/dev/null)
      COMPREPLY=( $(compgen -W "$pkgs" -- "$cur") )
      ;;
    uninstall|remove|delete|purge)
      # Complete against installed packages only.
      local pkgs
      pkgs=$(pacman -Qq 2>/dev/null)
      COMPREPLY=( $(compgen -W "$pkgs" -- "$cur") )
      ;;
    add)
      # Local package files (.pkg.tar.zst, .pkg.tar.xz, .pkg.tar.gz)
      COMPREPLY=( $(compgen -f -X '!*.pkg.tar.@(zst|xz|gz)' -- "$cur") )
      compopt -o plusdirs 2>/dev/null
      ;;
    owns|which|provides)
      # File path arguments.
      COMPREPLY=( $(compgen -f -- "$cur") )
      compopt -o filenames 2>/dev/null
      ;;
    *)
      COMPREPLY=()
      ;;
  esac

  return 0
}

complete -F _pkg pkg
