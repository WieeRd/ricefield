local vim = vim
vim.loader.enable()

require("cfg").setup({
  globals = { mapleader = " " },
  options = "core.options",
  keymaps = "core.keymaps",
  autocmds = "core.autocmds",
  commands = "core.commands",

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
