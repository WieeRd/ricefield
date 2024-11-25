# FIX(upstream): Nushell does not respect locale.conf
# | https://github.com/nushell/nushell/issues/7941
open /etc/locale.conf
| lines
| parse "{name}={value}"
| str trim value --char '"'
| transpose --header-row --as-record
| load-env

# automatically launch tmux on login shells (tty/ssh sessions)
if (
    $nu.is-login
    and $nu.is-interactive
    and not ("TMUX" in $env)
    and not (which tmux | is-empty)
) { tmux }
