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
    spec = {},
    opts = {},
  },

  colorscheme = "habamax",
})
