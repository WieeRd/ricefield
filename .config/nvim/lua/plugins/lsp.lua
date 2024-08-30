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
        desc = "Goto next reference",
      },
      {
        "[r",
        function()
          require("illuminate").goto_prev_reference()
        end,
        desc = "Goto previous reference",
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
