#!/usr/bin/env nu

# FIX(upstream): auto completion does not work for aliases
# | https://github.com/nushell/nushell/issues/8483
# | below is a workaround that manually expands aliases before the completion
let external_completer = { |spans| 
    let expanded_alias = (
        scope aliases
        | where name == $spans.0 
        | get -i expansion.0
    )

    let spans = if $expanded_alias != null  {
        $spans | skip 1 | prepend ($expanded_alias | split row " ")
    } else {
        $spans
    }

    fish --command $'complete "--do-complete=($spans | str join " ")"'
    | from tsv --flexible --no-infer --noheaders
    | rename value description
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

    # FEAT: LATER: fuzzy completion menu powered by fzf
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

    # FEAT: MABYE: keymaps/aliases for very frequent commands
    # | `cd -`, `cd ..`, `yazi` `__zoxide_zi`, ...
    keybindings: [
        {
            name: pipe_on_newline
            modifier: control
            keycode: char_\
            mode: [emacs, vi_insert]
            event: {
                edit: InsertString
                value: "\n| "
            }
        }
        {
            name: delete_prev_word
            modifier: control
            keycode: backspace
            mode: [emacs, vi_insert]
            event: { edit: CutWordLeft }
        }

        # by default vi-insert mode is missing some emacs keybinds
        {
            name: left
            modifier: control
            keycode: char_b
            mode: [vi_insert]
            event: { send: Left }
        }
        {
            name: right_or_complete
            modifier: control
            keycode: char_f
            mode: [vi_insert]
            event: {
                until: [
                    { send: HistoryHintComplete } 
                    { send: Right } 
                ]
            }
        }
        {
            name: clear_to_end
            modifier: control
            keycode: char_k
            mode: [vi_insert]
            event: { edit: ClearToLineEnd }
        }
        {
            name: clear_line
            modifier: control
            keycode: char_u
            mode: [vi_insert]
            event: { edit: Clear }
        }
    ]
}


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
        | fzf --scheme path --preview $prevcmd
        | cd $in
    }
}

# Run yazi file manager and cd on exit
def --env x [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
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

def e [...paths: path] { ^$env.EDITOR ...$paths }
alias f = fzf --preview="bat --color=always {}"
alias g = git
alias G = lazygit

alias eza = eza --icons --group-directories-first --sort=extension --width=80 --group --smart-group --time-style=relative --git
alias l = eza
alias ll = eza --long
alias la = eza --long --all
alias lt = eza --tree --level 2 --git-ignore

alias clip = xclip -selection clipboard

alias sctl = systemctl
alias uctl = systemctl --user
alias jctl = journalctl

alias dots = env $"GIT_DIR=($env.HOME)/.ricefield.git" $"GIT_WORK_TREE=($env.HOME)"
