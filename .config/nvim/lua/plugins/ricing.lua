return {
    -- WieeRd's favorite theme throughout the years
    -- (I have my own tradition of switching theme each year)
    { "nanotech/jellybeans.vim", enabled = false }, -- 2019
    { "dracula/vim", name = "dracula", enabled = false }, -- 2020
    { "sainnhe/sonokai", enabled = false }, -- 2021
    { "folke/tokyonight.nvim", enabled = false }, -- 2022

    -- my absolute favorite since June 2022, had to drop the said tradition
    {
        "rebelot/kanagawa.nvim",
        build = ":KanagawaCompile",
        priority = 1831,
        opts = {
            compile = true,
            colors = { theme = { all = { ui = { bg_gutter = "none" } } } },
            overrides = function(colors)
                local ui = colors.theme.ui
                local function fade(color, ratio)
                    return require("kanagawa.lib.color")(color)
                        :blend(ui.bg, ratio)
                        :to_hex()
                end
                return {
                    -- search highlight
                    CurSearch = { link = "IncSearch" },
                    -- popup menu
                    Pmenu = { fg = ui.fg_dim, bg = ui.bg_dim },
                    PmenuSel = { fg = "none", bg = ui.bg_p1 },
                    PmenuSbar = { bg = ui.bg_p2 },
                    PmenuThumb = { bg = ui.whitespace },
                    -- vim-illuminate
                    IlluminatedWordRead = { link = "CursorLine" },
                    IlluminatedWordWrite = { link = "CursorLine" },
                    IlluminatedWordText = { link = "CursorLine" },
                    -- indent-blankline.nvim
                    IndentBlanklineChar = { fg = fade(ui.whitespace, 0.66) },
                    IndentBlanklineContextChar = { fg = fade(ui.special, 0.33) },
                    -- blink.cmp
                    BlinkCmpGhostText = { link = "Comment" },
                }
            end,
        },
    },

    -- indentation level indicator
    {
        "lukas-reineke/indent-blankline.nvim",
        -- FIX: LATER: upgrade indent-blankline.nvim to v3
        -- | after lukas-reineke/indent-blankline.nvim#649 is resolved
        version = "2",
        event = "UIEnter",
        opts = {
            show_current_context = true,
            use_treesitter = true,
            filetype_exclude = {
                "fugitive",
                "gitcommit",
                "help",
                "markdown",
                "text",
            },
            buftype_exclude = {
                "nofile",
                "prompt",
                "quickfix",
                "terminal",
            },
        },
    },

    -- smooth scrolling
    {
        "karb94/neoscroll.nvim",
        keys = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "z" },
        opts = {
            mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
            hide_cursor = false,
            easing = "quadratic",
            pre_hook = function()
                vim.opt.eventignore:append({
                    "WinScrolled",
                    "CursorMoved",
                })
            end,
            post_hook = function()
                vim.opt.eventignore:remove({
                    "WinScrolled",
                    "CursorMoved",
                })
            end,
        },
    },

    -- highlight hex color codes such as #7E9CD8
    {
        "NvChad/nvim-colorizer.lua",
        event = "VeryLazy",
        opts = {
            user_default_options = {
                names = false,
                RGB = false,
                RRGGBBAA = true,
                mode = "virtualtext",
                virtualtext = "󰝤 ",
            },
        },
    },

    -- fancy folding powered by LSP/TS
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        opts = {
            -- FEAT: MAYBE: custom fold text
            -- | fold_virt_text_handler = nil,
            provider_selector = function(_, _, _)
                return { "treesitter", "indent" }
            end,
        },
        config = function(_, opts)
            local ufo = require("ufo")
            local map = vim.keymap.set
            -- FIX: LATER: implement default-ish zr/zm behavior
            -- | kevinhwang91/nvim-ufo#150
            ufo.setup(opts)
            map("n", "zR", ufo.openAllFolds)
            map("n", "zM", ufo.closeAllFolds)
            map("n", "zr", ufo.openFoldsExceptKinds)
            map("n", "zm", ufo.closeFoldsWith)
            map("n", "z[", ufo.goPreviousClosedFold)
            map("n", "z]", ufo.goNextClosedFold)
        end,
    },

    -- a framework for building statusline, tabline, and winbar
    {
        "rebelot/heirline.nvim",
        event = "UIEnter",
        config = function(_, _)
            package.loaded["plugins.ricing.heirline"] = nil
            require("plugins.ricing.heirline")
        end,
    },
}
