return {
  -- the plugin manager itself
  { "folke/lazy.nvim", version = "*" },

  -- opt-in neovim stdlib at this point
  { "nvim-lua/plenary.nvim" },

  -- filetype to nerd fonts icon mapping
  { "nvim-tree/nvim-web-devicons" },

  -- symbol type to nerd fonts icon mapping
  {
    "onsails/lspkind.nvim",
    opts = { symbol_map = vim.g.lspkind },
  },

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
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Local Keymaps",
      },
    },
    opts = {
      preset = "modern",
      win = {
        width = { min = 120, max = 0.6 },
        border = "none",
      },
      icons = {
        breadcrumb = "»",
        separator = "»",
        rules = false,
      },
      spec = {
        { "<Leader>f", group = "find" },
        { "<Leader>g", group = "git" },
        { "<Leader>l", group = "lsp" },
        { "<Leader>t", group = "term" },
      },
    },
  },
}
