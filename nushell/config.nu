let carapace_completer = { |spans|
    carapace $spans.0 nushell $spans | from json | sort-by value --reverse
}

let fish_completer = { |spans|
    fish --command $'complete "--do-complete=($spans | str join " ")"'
    | $"value(char tab)description(char newline)" + $in
    | from tsv --flexible --no-infer
}

let zoxide_completer = { |spans|
    $spans | skip 1 | zoxide query -l $in | lines | where { |x| $x != $env.PWD }
}

# FIX: LATER: auto completion does not work for aliases
# | https://github.com/nushell/nushell/issues/8483
# | below workaround method will be removed after the issue gets resolved
let external_completer = { |spans| 
    # if the current command is an alias, get it's expansion
    let expanded_alias = (scope aliases | where name == $spans.0 | get -i expansion.0)

    # put the first word of the expanded alias first in the span
    let spans = if $expanded_alias != null  {
        $spans | skip 1 | prepend ($expanded_alias | split row " ")
    } else {
        $spans
    }

    match $spans.0 {
        z | zi => $zoxide_completer,
        _ => $fish_completer,
    } | do $in $spans
} 

$env.config = {
    show_banner: false

    datetime_format: {
        normal: "%Y-%m-%d %H:%M:%S %z %a"
        # table: "" # default: 'humanized' time delta
    }

    completions: {
        external: {
            enable: true
            max_results: 100
            completer: $external_completer
        }
    }

    filesize: {
        metric: false # true => KB, false => KiB
        format: "auto"
    }

    cursor_shape: {
        # block, underscore, line, blink_block, blink_underscore, blink_line
        emacs: line
        vi_insert: line
        vi_normal: block
    }

    # FEAT: MAYBE: history autocomplete integration with atuin
    # | currently history is written to both `history.sqlite` and atuin
    # | ghost text and Ctrl+F uses `history.sqlite`, while Ctrl+R uses atuin
    history: {
        max_size: 10000
        sync_on_enter: true
        file_format: "sqlite"
        isolation: false
    }

    edit_mode: vi # emacs, vi
    shell_integration: true
    use_kitty_protocol: true
    highlight_resolved_externals: true

    hooks: {
        pre_prompt: [{ direnv export json | from json | default {} | load-env }]
        display_output: {
            # FEAT: auto paging, save last command result
            table -e | into string | less -FR err> /dev/null
        }
    }

    menus: [
        {
            name: completion_menu
            only_buffer_difference: false
            marker: ""
            type: {
                layout: columnar
                columns: 4
                col_width: 20     # Optional value. If missing all the screen width is used to calculate column width
                col_padding: 2
            }
            style: {
                text: dark_gray
                selected_text: white
                description_text: dark_gray
            }
        }
        {
            name: history_menu
            only_buffer_difference: true
            marker: "? "
            type: {
                layout: list
                page_size: 10
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
            }
        }
        {
            name: help_menu
            only_buffer_difference: true
            marker: "? "
            type: {
                layout: description
                columns: 4
                col_width: 20     # Optional value. If missing all the screen width is used to calculate column width
                col_padding: 2
                selection_rows: 4
                description_rows: 10
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
            }
        }
    ]

    keybindings: [
        # FIX: not all emacs keybinds are available in vi_insert
        # | make a PR to `nushell/reedline` to move default keybinds
        {
            name: history_completion
            modifier: control
            keycode: char_f
            mode: [emacs, vi_insert]
            event: { send: historyhintcomplete }
        }
        {
            name: pipe_on_newline
            modifier: shift
            keycode: enter
            mode: [emacs, vi_insert]
            event: {
                edit: InsertString
                value: "\n| "
            }
        }
    ]
}

def git-log [n: int = 999] {
    ^git log --pretty=%h»¦«%s»¦«%aN»¦«%aE»¦«%aD -n $n
    | lines
    | split column "»¦«" commit subject name email date
    | upsert date { |d| $d.date | into datetime }
    | reject email # rarely used
    | reverse
}

# Captures the output of the given command in the clipboard.
def capture [command: string] {
    script --return --quiet --command $command -O /dev/null
    | (print $in; echo $in)
    | xclip -selection clipboard
}

alias eza = eza --icons --group-directories-first --sort=extension --width=80 --group --smart-group --time-style=relative --git
alias l = eza
alias ll = eza --long
alias la = eza --long --all
alias lt = eza --tree --level 2 --git-ignore

# FEAT: keymaps/aliases for `cd -`, `cd ..` and `cd (xplr)`

alias g = git
alias v = nvim
alias x = xplr

alias sctl = sudo systemctl
alias uctl = systemctl --user
alias jctl = journalctl

alias clip = xclip -selection clipboard
alias ssh = kitty +kitten ssh # FIX: set this alias iff inside kitty terminal

source atuin.nu
source starship.nu
source zoxide.nu
