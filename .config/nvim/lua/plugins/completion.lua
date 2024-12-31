return {
    -- completion engine
    {
        "saghen/blink.cmp",
        version = "*",
        dependencies = "WieeRd/friendly-snippets",
        event = { "InsertEnter", "CmdlineEnter" },
        opts = {
            appearance = {
                use_nvim_cmp_as_default = true,
                kind_icons = vim.g.lspkind,
            },
            completion = {
                keyword = { range = "full" },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                    window = { border = "solid" },
                },
                ghost_text = { enabled = true },
            },
        },
    },
}
