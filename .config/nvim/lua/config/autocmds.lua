return {
    {
        "TextYankPost",
        callback = function(_)
            vim.highlight.on_yank({
                higroup = "CursorLine",
                timeout = 150,
                on_macro = false,
                on_visual = true,
            })
        end,
        desc = "Briefly highlight the yanked text",
    },

    {
        "ColorScheme",
        callback = function(event)
            local theme = event.match
            -- overrides for the 'default' theme are applied to every theme
            vim.cmd.runtime("after/colors/default.vim")
            -- override each theme at the `after/colors/{theme}.vim`
            vim.cmd.runtime(("after/colors/%s.vim"):format(theme))
        end,
        desc = "Override each colorscheme using `after/colors/` directory",
    },

    {
        "TermOpen",
        callback = function(_)
            local wo = vim.wo
            wo.scrolloff = 0
            wo.sidescrolloff = 0
            wo.number = false
            wo.relativenumber = false
        end,
        desc = "Set terminal window options",
    },

    {
        "VimResized",
        callback = function(_)
            local current = vim.api.nvim_get_current_tabpage()
            vim.cmd("tabdo wincmd =")
            vim.api.nvim_set_current_tabpage(current)
        end,
        desc = "Resize panes on terminal window resize",
    },

    {
        { "FocusGained", "TermLeave" },
        callback = function(_)
            -- using `vim.cmd` in cmdline window will result in error E11
            if vim.fn.getcmdwintype() == "" then
                vim.cmd("checktime")
            end
        end,
        desc = "Check if the files has been modified from the outside",
    },

    {
        "BufWritePre",
        callback = function(event)
            if event.match:match("^%w%w+:[\\/][\\/]") then
                return
            end
            local file = vim.uv.fs_realpath(event.match) or event.match
            vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
        end,
        desc = "Auto create intermediate parent directories upon write",
    },

    {
        "ModeChanged",
        pattern = "[iR]*:n*",
        callback = function(_)
            local _ = pcall(vim.system, { "fcitx5-remote", "-c" })
        end,
        desc = "Disable input method when leaving insert/replace mode",
    },

    {
        { "BufEnter", "TextChanged", "InsertLeave" },
        callback = function(event)
            vim.lsp.codelens.refresh({ bufnr = event.buf })
        end,
        desc = "Auto refresh CodeLens on changes",
    },

    -- FIX(upstream): lazily setup servers may not have `K` keymap setup
    -- | https://github.com/WieeRd/auto-lsp.nvim/issues/9
    {
        "LspAttach",
        callback = function(_)
            local map = vim.keymap.set
            map("n", "K", vim.lsp.buf.hover, { buffer = true })
        end,
        desc = "Band-aid fix for WieeRd/auto-lsp.nvim#9",
    },
}
