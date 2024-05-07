# merge systemd user environments (`environment.d/`)
systemctl --user show-environment
| lines
| parse "{name}={value}"
| transpose --ignore-titles --header-row --as-record
| load-env

$env.NU_LIB_DIRS = [($nu.default-config-dir | path join "scripts")]
$env.NU_PLUGIN_DIRS = [($nu.default-config-dir | path join "plugins")]

$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_MULTILINE_INDICATOR = "∙"

$env.LS_COLORS = (vivid generate one-dark)

gpgconf --launch gpg-agent
$env.GPG_TTY = (tty)
$env.SSH_AGENT_PID = ""
$env.SSH_AUTH_SOCK = (gpgconf --list-dirs agent-ssh-socket)

# FIX: save scripts to `/tmp` to reduce SSD I/O and btrfs fragmentation
# FEAT: need a way to resolve standard paths (`XDG_*`, `TMPDIR`, etc)
zoxide init nushell | save -f ($env.NU_LIB_DIRS.0 | path join "zoxide.nu")
starship init nu | save -f ($env.NU_LIB_DIRS.0| path join "starship.nu")
atuin init nu | save -f ($env.NU_LIB_DIRS.0| path join "atuin.nu")
