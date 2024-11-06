vim.loader.enable()

require("setup").setup({
  globals = {
    mapleader = " ",
    maplocalleader = "\\",
  },
  options = "config.options",
  keymaps = "config.keymaps",
  autocmds = "config.autocmds",
  commands = "config.commands",
  diagnostics = "config.diagnostics",
  plugins = "config.plugins",
  colorscheme = {
    builtin = "habamax",
    plugin = "kanagawa",
  },
})
