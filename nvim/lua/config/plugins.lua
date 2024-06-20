return {
  enabled = vim.env.USER ~= "root",
  bootstrap = true,
  spec = "plugins",
  opts = {
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
      rtp = { reset = false },
    },
  },
}
