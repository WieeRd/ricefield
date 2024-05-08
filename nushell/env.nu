# NOTE: the conversions happen *after* `{env, config}.nu` are loaded
let PATH_CONVERSION = {
    from_string: { |s| $s | split row (char esep) | path expand | uniq }
    to_string: { |v| $v | path expand | str join (char esep) }
}

$env.ENV_CONVERSIONS = {
    # Linux
    "PATH": $PATH_CONVERSION
    # Windows
    "Path": $PATH_CONVERSION
}

$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_MULTILINE_INDICATOR = "∙"

# merge systemd user environments from `environment.d/`
/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator
| lines
| parse "{name}={value}"
| str trim value --char '"'
| transpose --header-row --as-record
| load-env

# use gpg-agent for SSH
gpgconf --launch gpg-agent
$env.GPG_TTY = (tty)
$env.SSH_AGENT_PID = ""
$env.SSH_AUTH_SOCK = (gpgconf --list-dirs agent-ssh-socket)

$env.LS_COLORS = (vivid generate one-dark)

# generate integration scripts inside tmpfs to reduce disk I/O
$env.NU_TMP_DIR = ($env.XDG_RUNTIME_DIR | path join "nu")
$env.NU_LIB_DIRS = [$env.NU_TMP_DIR]

do {
    mkdir $env.NU_TMP_DIR
    cd $env.NU_TMP_DIR

    atuin init nu | save -f atuin.nu
    starship init nu | save -f starship.nu
    zoxide init nushell | save -f zoxide.nu
}
