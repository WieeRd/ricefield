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
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- top, right, bottom, left
      window = { margin = { 1, 0.2, 1, 0.2 } },
      layout = { align = "center" },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register({
        ["<Leader>g"] = { name = "git" },
        ["<Leader>t"] = { name = "term" },
      })
    end,
  },
}
