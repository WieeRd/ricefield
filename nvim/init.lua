local vim = vim
vim.loader.enable()

require("setup").setup({
  globals = { mapleader = " " },
  options = "config.options",
  keymaps = "config.keymaps",
  autocmds = "config.autocmds",
  commands = "config.commands",

  plugins = {
    enabled = true,
    bootstrap = true,
    spec = {
      {
        "rebelot/kanagawa.nvim",
        opts = {
          colors = {
            theme = {
              all = {
                ui = {
                  bg_gutter = "none",
                },
              },
            },
          },
        },
      },
    },
    opts = {},
  },

  colorscheme = {
    builtin = "habamax",
    plugin = "kanagawa",
  },
})
