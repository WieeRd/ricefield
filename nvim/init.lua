local vim = vim
vim.loader.enable()

require("cfg").setup({
  globals = { mapleader = " " },
  options = { clipboard = "unnamedplus" },
  keymaps = {
    ["i"] = {
      ["kj"] = "<Esc>",
    },
    [{ "x", "o" }] = {
      ["."] = "iw",
      [","] = "aW",
    },
  },

  colorscheme = "habamax",
})
