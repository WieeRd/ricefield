return {
    -- completion engine
    {
        "saghen/blink.cmp",
        version = "*",
        event = { "InsertEnter", "CmdlineEnter" },
        opts = {
            appearance = {
                -- FEAT(upstream): kanagawa.nvim blink.cmp support
                -- | https://github.com/rebelot/kanagawa.nvim/pull/271
                use_nvim_cmp_as_default = true,
                kind_icons = vim.g.lspkind,
            },
            completion = {
                keyword = { range = "full" },
                trigger = { prefetch_on_insert = true },
                list = {
                    max_items = 40,
                    selection = function(ctx)
                        return ctx.mode == "cmdline" and "auto_insert"
                            or "preselect"
                    end,
                },
                menu = {
                    auto_show = function(ctx, _)
                        return ctx.trigger.kind ~= "keyword"
                            or ctx.bounds.length >= 3
                    end,
                    draw = {
                        -- FIX(upstream): LATER: exclude label details
                        columns = { { "label" }, { "kind_icon" } },
                    },
                },
                documentation = { window = { border = "solid" } },
                ghost_text = { enabled = true },
            },
            keymap = {
                preset = "none",
                -- accept
                ["<C-Space>"] = { "select_and_accept", "show" },
                ["<C-c>"] = { "cancel", "fallback" },
                -- select
                ["<C-n>"] = { "show", "select_next" },
                ["<C-p>"] = { "show", "select_prev" },
                ["<Down>"] = { "show", "select_next" },
                ["<Up>"] = { "show", "select_prev" },
                -- snippet
                ["<Tab>"] = { "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "snippet_backward", "fallback" },
                ["<Left>"] = { "snippet_backward" },
                ["<Right>"] = { "snippet_forward" },
                -- documentation
                ["<C-u>"] = {
                    "show_documentation",
                    "scroll_documentation_up",
                    "fallback",
                },
                ["<C-d>"] = {
                    "show_documentation",
                    "scroll_documentation_down",
                    "fallback",
                },
                cmdline = {
                    preset = "none",
                    ["<C-Space>"] = { "show", "select_and_accept" },
                    ["<C-c>"] = { "cancel", "fallback" },
                    ["<Tab>"] = { "show", "select_next" },
                    ["<S-Tab>"] = { "show", "select_prev" },
                },
            },
            snippets = {
                expand = function(snippet)
                    require("luasnip").lsp_expand(snippet)
                end,
                active = function(filter)
                    local direction = filter and filter.direction or 1
                    if direction > 0 then
                        return require("luasnip").expand_or_locally_jumpable()
                    else
                        return require("luasnip").locally_jumpable(direction)
                    end
                end,
                jump = function(direction)
                    if direction > 0 then
                        require("luasnip").expand_or_jump()
                    else
                        require("luasnip").jump(direction)
                    end
                end,
            },
            sources = {
                default = { "lsp", "path", "luasnip", "buffer" },
            },
        },
    },

    -- snippet engine
    {
        "L3MON4D3/LuaSnip",
        dependencies = "WieeRd/friendly-snippets",
        keys = {
            {
                "<C-f>",
                function()
                    local ls = require("luasnip")
                    return ls.choice_active() and ls.change_choice(1)
                end,
                mode = { "i", "s" },
            },
            {
                "<C-b>",
                function()
                    require("luasnip").unlink_current()
                end,
                mode = { "i", "s" },
            },
        },
        opts = {
            history = true,
            delete_check_events = "TextChanged",
        },
        config = function(_, opts)
            require("luasnip").setup(opts)
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
}
