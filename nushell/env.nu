# NOTE: the conversions happen *after* config.nu is loaded
let PATH_CONVERSION = {
	from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
	to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
}

$env.ENV_CONVERSIONS = {
	# Linux
	"PATH": $PATH_CONVERSION
	# Windows
    "Path": $PATH_CONVERSION
}

$env.NU_LIB_DIRS = [($nu.default-config-dir | path join "scripts")]
$env.NU_PLUGIN_DIRS = [($nu.default-config-dir | path join "plugins")]

$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_MULTILINE_INDICATOR = "∙"

$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
$env.MANPAGER = "nvim +Man!"

$env.LS_COLORS = (vivid generate snazzy)

keychain --eval --quiet --timeout 15 --quick --agents gpg,ssh
| parse --regex '(\w+)=(.*); export \1'
| transpose --ignore-titles --header-row --as-record
| load-env

# FIX: LATER: zoxide nushell template is outdated
# | using manually patched version for now
# zoxide init nushell | save -f ($env.NU_LIB_DIRS.0 | path join "zoxide.nu")
starship init nu | save -f ($env.NU_LIB_DIRS.0| path join "starship.nu")
atuin init nu | save -f ($env.NU_LIB_DIRS.0| path join "atuin.nu")
