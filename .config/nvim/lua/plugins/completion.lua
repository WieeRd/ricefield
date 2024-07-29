return {
  -- completion engine
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
    },
    event = "InsertEnter",
    opts = function(_, opts)
      local map = require("cmp").mapping

      local function visible_buffers()
        local buffers = {}
        local windows = vim.api.nvim_tabpage_list_wins(0)
        for _, win in ipairs(windows) do
          buffers[#buffers + 1] = vim.api.nvim_win_get_buf(win)
        end
        return buffers
      end

      opts.snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      }

      opts.mapping = map.preset.insert({
        ["<C-Space>"] = map.confirm({ select = true }),
        ["<C-d>"] = map.scroll_docs(4),
        ["<C-u>"] = map.scroll_docs(-4),
      })

      opts.sources = {
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "path" },
        {
          name = "buffer",
          keyword_length = 3,
          option = { get_bufnrs = visible_buffers },
        },
      }

      opts.view = {
        entries = {
          selection_order = "near_cursor",
        },
      }

      opts.window = {
        completion = {
          border = "none",
          -- winhighlight = "Search:None",
        },
        documentation = {
          border = "solid",
          winhighlight = "Search:None",
        },
      }

      opts.formatting = {
        format = require("lspkind").cmp_format(),
      }

      opts.experimental = { ghost_text = { hl = "NonText" } }

      return opts
    end,
  },

  -- snippet engine
  {
    "L3MON4D3/LuaSnip",
    dependencies = "rafamadriz/friendly-snippets",
    event = "InsertEnter",
    keys = {
      {
        "<Tab>",
        function()
          require("luasnip").expand_or_jump()
        end,
        mode = { "i", "s" },
      },
      {
        "<S-Tab>",
        function()
          require("luasnip").jump(-1)
        end,
        mode = { "i", "s" },
      },
    },
    config = function()
      require("luasnip").setup({
        history = true,
        delete_check_events = "TextChanged",
      })
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}
