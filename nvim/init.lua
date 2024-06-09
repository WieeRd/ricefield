local vim = vim
vim.loader.enable()

require("cfg").setup({
  globals = { mapleader = " " },
  options = { clipboard = "unnamedplus" },
  colorscheme = "habamax",
})
