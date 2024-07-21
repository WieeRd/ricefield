#!/usr/bin/env nu

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

# import systemd user environments from `environment.d/`
systemctl --user show-environment --output=json
| from json
| load-env

# not sure what this is even used for but I'm too afraid to remove it
$env.GPG_TTY = (tty)

# FEAT: create kanagawa palette for vivid
$env.LS_COLORS = (vivid generate one-dark)

# generate integration scripts inside tmpfs to reduce disk I/O
$env.NU_TMP_DIR = ($env.XDG_RUNTIME_DIR | path join "nu")
$env.NU_LIB_DIRS = [$env.NU_TMP_DIR]

do {
    mkdir $env.NU_TMP_DIR
    cd $env.NU_TMP_DIR

    atuin init nu --disable-up-arrow | save -f atuin.nu
    starship init nu | save -f starship.nu
    zoxide init nushell | save -f zoxide.nu
}
