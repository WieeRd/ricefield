vim.g.rustaceanvim = {
    server = {
        default_settings = {
            ["rust-analyzer"] = {
                -- FIX(upstream): features for rust-analyzer should be set per project
                -- | to avoid trouble on projects with mutually exclusive feature flags
                -- | `rust-analyzer.toml` is WIP (rust-lang/rust-analyzer#13529)
                cargo = { features = "all" },
            },
        },
    },
}

return {
    -- advanced Rust integration with rust-analyzer, codelldb, tests, and more
    {
        "mrcjkb/rustaceanvim",
        ft = "rust",
    },
}
