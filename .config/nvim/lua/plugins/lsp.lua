return {
  -- automatically detect and setup language servers
  {
    "WieeRd/auto-lsp.nvim",
    dependencies = "neovim/nvim-lspconfig",
    event = "VeryLazy",
    opts = {
      ["*"] = function()
        return { capabilities = require("blink.cmp").get_lsp_capabilities() }
      end,
      ["ltex"] = {
        filetypes = { "markdown", "rst" },
      },
      ["lua_ls"] = {
        settings = {
          Lua = {
            completion = { showWord = "Disable" },
            hint = {
              enable = true,
              setType = true,
              arrayIndex = "Disable",
            },
          },
        },
      },
      ["rust_analyzer"] = false,
    },
  },

  -- highlight references of the symbol under the cursor
  {
    "RRethy/vim-illuminate",
    event = "VeryLazy",
    keys = {
      {
        "]r",
        function()
          require("illuminate").goto_next_reference()
        end,
        desc = "Next Reference",
      },
      {
        "[r",
        function()
          require("illuminate").goto_prev_reference()
        end,
        desc = "Prev Reference",
      },
    },
    opts = {
      providers = { "lsp", "treesitter" },
      delay = 50,
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },
}
