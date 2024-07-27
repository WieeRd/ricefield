return {
  -- FEAT: disable plugin when being used for `sudoedit`
  enabled = vim.env.USER ~= "root",
  bootstrap = true,
  spec = "plugins",
  opts = {
    install = {
      colorscheme = { "kanagawa" },
    },
    ui = {
      backdrop = 100,
    },
    checker = {
      enabled = true,
      notify = false,
      frequency = 3600,
    },
    change_detection = {
      enabled = true,
      notify = false,
    },
    performance = {
      rtp = {
        reset = true,
        disabled_plugins = {
          "matchit",
          "matchparen",
          "netrwPlugin",
        },
      },
    },
  },
}
