$env.NU_LIB_DIRS = [($nu.default-config-dir | path join "scripts")]
$env.NU_PLUGIN_DIRS = [($nu.default-config-dir | path join "plugins")]

$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_MULTILINE_INDICATOR = "∙"

# merge systemd user environments from `environment.d/`
# `str trim` is for stripping $'' escape applied by systemctl
systemctl --user show-environment
| lines
| parse "{name}={value}"
| str trim value --left --char "$"
| str trim value --char "'"
| transpose --header-row --as-record
| load-env

# use gpg-agent for SSH
gpgconf --launch gpg-agent
$env.GPG_TTY = (tty)
$env.SSH_AGENT_PID = ""
$env.SSH_AUTH_SOCK = (gpgconf --list-dirs agent-ssh-socket)

$env.LS_COLORS = (vivid generate one-dark)

# FIX: save scripts to `/tmp` to reduce SSD I/O and btrfs fragmentation
# FEAT: need a way to resolve standard paths (`XDG_*`, `TMPDIR`, etc)
zoxide init nushell | save -f ($env.NU_LIB_DIRS.0 | path join "zoxide.nu")
starship init nu | save -f ($env.NU_LIB_DIRS.0| path join "starship.nu")
atuin init nu | save -f ($env.NU_LIB_DIRS.0| path join "atuin.nu")
