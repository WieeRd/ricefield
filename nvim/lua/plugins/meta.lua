return {
  -- the plugin manager itself
  { "folke/lazy.nvim", version = "*" },

  -- opt-in neovim stdlib at this point
  { "nvim-lua/plenary.nvim" },

  -- filetype to nerd fonts icon mapping
  { "nvim-tree/nvim-web-devicons" },

  -- install and manage tree-sitter parsers and modules
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "lua",
        "markdown",
        "markdown_inline",
        "vim",
        "vimdoc",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  -- keymap cheatsheets
  -- FIX: ASAP: manually trigger which-key on visual mode
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = function(ctx)
        return ctx.plugin and 0 or 300
      end,
      win = {
        width = 0.6,
        border = "none",
      },
      icons = { rules = false },
      modes = { x = false },
      spec = {
        { "<Leader>g", group = "git" },
        { "<Leader>t", group = "term" },
      },
    },
  },
}
