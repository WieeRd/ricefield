local vim = vim
vim.loader.enable()

require("setup").setup({
  globals = { mapleader = " " },
  options = "config.options",
  keymaps = "config.keymaps",
  autocmds = "config.autocmds",
  commands = "config.commands",
  plugins = "config.plugins",

  colorscheme = {
    builtin = "habamax",
    plugin = "kanagawa",
  },
})
