return {
  -- handle off-spec LSP requests from LTeX such as 'add to dictionary'
  {
    "barreiroleo/ltex_extra.nvim",
    branch = "dev",
    ft = { "markdown", "rst" },
    opts = {
      path = vim.fn.stdpath("data") .. "/ltex",
    },
  },
}
