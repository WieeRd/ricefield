local vim = vim
vim.loader.enable()

require("cfg").setup({
  globals = { mapleader = " " },
  options = require("core.options"),
  keymaps = require("core.keymaps"),
  autocmds = require("core.autocmds"),
  commands = require("core.commands"),

  colorscheme = "habamax",
})
