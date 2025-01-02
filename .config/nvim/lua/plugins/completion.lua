return {
    -- completion engine
    {
        "saghen/blink.cmp",
        version = "*",
        dependencies = "WieeRd/friendly-snippets",
        event = { "InsertEnter", "CmdlineEnter" },
        opts = {
            appearance = {
                -- FEAT(upstream): kanagawa blink.cmp support
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
        },
    },
}
