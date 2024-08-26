return {
  -- automatically detect and setup language servers
  {
    "WieeRd/auto-lsp.nvim",
    event = "VeryLazy",
    opts = {
      ["*"] = function()
        return {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        }
      end,
      ["lua_ls"] = {
        settings = {
          Lua = { completion = { showWord = "Disable" } },
        },
      },
    },
  },
}
