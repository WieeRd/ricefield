return {
  {
    "barreiroleo/ltex_extra.nvim",
    branch = "dev",
    ft = { "markdown", "rst" },
    opts = {
      path = vim.fn.stdpath("data") .. "/ltex",
    },
  }
}
