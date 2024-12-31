return {
    -- highlight and jump(%) between matching pairs
    {
        "andymass/vim-matchup",
        opts = {
            enable = true,
            disable_virtual_text = true,
        },
        config = function(_, opts)
            vim.g.matchup_matchparen_offscreen = {}
            require("nvim-treesitter.configs").setup({ matchup = opts })
        end,
    },

    -- enhance native `gcc` commenting
    -- FEAT(upstream): add support for scss (#59)
    {
        "WieeRd/ts-comments.nvim",
        event = "VeryLazy",
        opts = {},
    },

    -- manipulate surrounding pairs
    {
        "kylechui/nvim-surround",
        keys = { "cs", "ds", "ys", { "S", mode = "x" } },
        opts = {},
    },

    -- auto insert/remove closing pairs
    {
        "altermo/ultimate-autopair.nvim",
        event = { "InsertEnter", "CmdlineEnter" },
        opts = {},
    },

    -- auto insert closing keywords
    {
        "RRethy/nvim-treesitter-endwise",
        event = "InsertEnter",
        opts = { enable = true },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup({ endwise = opts })
        end,
    },

    -- more and better around/inner text objects
    {
        "echasnovski/mini.ai",
        keys = {
            { "a", mode = { "x", "o" } },
            { "i", mode = { "x", "o" } },
        },
        opts = {
            n_lines = 500,
            silent = true,
        },
    },

    -- current indentation level as a textobject
    {
        "kiyoon/treesitter-indent-object.nvim",
        keys = {
            {
                "ai",
                function()
                    local textobj = require("treesitter_indent_object.textobj")
                    local refiner = require("treesitter_indent_object.refiner")
                    textobj.select_indent_outer(true, "V")
                    refiner.include_surrounding_empty_lines()
                end,
                mode = { "x", "o" },
                desc = "Around indented block",
            },
            {
                "ii",
                function()
                    local textobj = require("treesitter_indent_object.textobj")
                    textobj.select_indent_inner(false, "v")
                end,
                mode = { "x", "o" },
                desc = "Inner indented block",
            },
        },
    },

    -- tree-sitter nodes as textobjects
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        keys = {
            { "a", mode = { "x", "o" } },
            { "i", mode = { "x", "o" } },
            { "]", mode = { "n", "x", "o" } },
            { "[", mode = { "n", "x", "o" } },
        },
        opts = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                },
                include_surrounding_whitespace = function(args)
                    return args.query_string:match(".outer$")
                end,
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]]"] = "@class.outer",
                    ["]m"] = "@function.outer",
                },
                goto_next_end = {
                    ["]["] = "@class.outer",
                    ["]M"] = "@function.outer",
                },
                goto_previous_start = {
                    ["[["] = "@class.outer",
                    ["[m"] = "@function.outer",
                },
                goto_previous_end = {
                    ["[]"] = "@class.outer",
                    ["[M"] = "@function.outer",
                },
            },
            swap = {
                enable = true,
                -- FIX: ASAP: swap keymaps occasionally freezes neovim
                swap_next = {
                    ["],"] = "@parameter.inner",
                },
                swap_previous = {
                    ["[,"] = "@parameter.inner",
                },
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup({ textobjects = opts })
        end,
    },

    -- split/join multi-line statement
    {
        "Wansmer/treesj",
        keys = {
            { "gS", "<Cmd>TSJSplit<CR>" },
            { "gJ", "<Cmd>TSJJoin<CR>" },
            { "gM", "<Cmd>TSJToggle<CR>" },
        },
        opts = { use_default_keymaps = false },
    },
}
