#!/usr/bin/env nu

let PATH_CONVERSION = {
    from_string: { |s| $s | split row (char esep) | uniq }
    to_string: { |v| $v | path expand | str join (char esep) }
}

# NOTE: the conversions happen *after* `{env, config}.nu` are loaded
$env.ENV_CONVERSIONS = {
    # Linux
    "PATH": $PATH_CONVERSION
    # Windows
    "Path": $PATH_CONVERSION
}

# ...which is why a manual conversion is needed here before using `append`
$env.PATH = do $PATH_CONVERSION.from_string $env.PATH
| append ~/.local/bin
| append ~/.cargo/bin
| append ~/go/bin


# generate integration scripts inside tmpfs to reduce disk I/O
$env.NU_TMP_DIR = ($env.XDG_RUNTIME_DIR | path join "nu")
$env.NU_LIB_DIRS = [$env.NU_TMP_DIR]

do {
    mkdir $env.NU_TMP_DIR
    cd $env.NU_TMP_DIR

    atuin init nu --disable-up-arrow | save -f atuin.nu
    starship init nu | save -f starship.nu
    zoxide init nushell --no-cmd | save -f zoxide.nu
}


# disable native shell prompt and leave it up to starship
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_MULTILINE_INDICATOR = "∙"

# set default applications
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
$env.MANPAGER = "nvim +Man!"

# not sure what this is even used for but I'm too afraid to remove it
$env.GPG_TTY = (tty)

# FEAT: create kanagawa palette for vivid
$env.LS_COLORS = (vivid generate one-dark)
$env.LESS = "--ignore-case --tabs=4 --RAW-CONTROL-CHARS"

# FEAT(upstream): eza config file for default flags
# | https://github.com/eza-community/eza/issues/897
$env.FZF_DEFAULT_COMMAND = "fd --type file"
$env.FZF_DEFAULT_OPTS = "
--reverse
--info=inline
--height=20
--border=none
--preview-window=right,50%,border-sharp
--bind=btab:up,tab:down
"

$env._ZO_FZF_OPTS = $env.FZF_DEFAULT_OPTS + "
--scheme=path
--no-sort
--keep-right
--preview='eza --icons --group-directories-first --sort=extension --color=always {2..}'
"
