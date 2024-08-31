return {
  -- setup lua_ls for Neovim config / plugin development
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = { "luvit-meta/library" },
    },
  },

  -- provide types for Luvit (vim.uv) API
  { "Bilal2453/luvit-meta", lazy = true },
}
