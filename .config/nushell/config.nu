#!/usr/bin/env nu

let fish_completer = { |spans|
    fish --command $'complete "--do-complete=($spans | str join " ")"'
    | $"value(char tab)description(char newline)" + $in
    | from tsv --flexible --no-infer
}

let zoxide_completer = { |spans|
    $spans | skip 1 | zoxide query -l $in | lines | where { |x| $x != $env.PWD }
}

# FIX(upstream): auto completion does not work for aliases
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

    completions: {
        external: {
            enable: true
            max_results: 100
            completer: $external_completer
        }
    }

    display_errors: {
        exit_code: false
        termination_signal: true
    }

    filesize: {
        # true => KB, false => KiB
        metric: false
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

    # emacs, vi
    edit_mode: vi
    use_kitty_protocol: true
    highlight_resolved_externals: true

    hooks: {
        pre_prompt: [{ direnv export json | from json | default {} | load-env }]
        # FEAT: auto paging, save last command result
        # | https://github.com/nushell/nushell/issues/2731
        # display_output: { table -e | into string | less -FR err> /dev/null }
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

    # FEAT: keymaps/aliases for `cd -`, `cd ..` and `cd (xplr)`
    # FEAT: ctrl + backspace = ctrl + w (delete a word)
    # FIX(upstream): not all emacs keybinds are available in vi_insert
    # | make a PR to `nushell/reedline` to move default keybinds
    keybindings: [
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

# Fuzzy & Interactive `cd` using `fd` and `fzf`
def --env c [search?: string] {
    if $search != null {
        fd --type directory
        | fzf --scheme path --filter $search
        | head -n1
        | cd $in
    } else {
        let prevcmd = "eza --icons --group-directories-first --sort=extension --color=always {}"
        fd --type directory
        | fzf --scheme path --height 45% --preview-window down,30% --preview $prevcmd
        | cd $in
    }
}

# Parses `git log` result into a Nushell table
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

alias dots = env $"GIT_DIR=($env.HOME)/.ricefield.git" $"GIT_WORK_TREE=($env.HOME)"

alias eza = eza --icons --group-directories-first --sort=extension --width=80 --group --smart-group --time-style=relative --git
alias l = eza
alias ll = eza --long
alias la = eza --long --all
alias lt = eza --tree --level 2 --git-ignore

alias g = git
alias v = nvim
alias x = do --env { cd (xplr --print-pwd-as-result) }

alias clip = xclip -selection clipboard

alias sctl = systemctl
alias uctl = systemctl --user
alias jctl = journalctl

# FIX: LATER: set kitty specific aliases only if $env.TERM == "xterm-kitty"
# | conditional alias is not supported as of v0.94.2 (nushell/nushell#5068)
alias ktsh = kitten ssh
alias icat = kitten icat

source atuin.nu
source starship.nu
source zoxide.nu

def --env z [search?: string] {
    if $search != null {
        __zoxide_z $search
    } else {
        __zoxide_zi
    }
}
