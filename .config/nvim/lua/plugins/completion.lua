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
      local cmp = require("cmp")
      local map = cmp.mapping

      local function visible_buffers()
        local buffers = {}
        local windows = vim.api.nvim_list_wins()
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
        ["<Tab>"] = map(function(fallback)
          return require("luasnip").expand_or_jump() or fallback()
        end, { "i", "s" }),
        ["<S-Tab>"] = map(function(fallback)
          return require("luasnip").jump(-1) or fallback()
        end, { "i", "s" }),
      })

      opts.sources = {
        { name = "luasnip", group_index = 1 },
        { name = "nvim_lsp", group_index = 1 },
        { name = "path", group_index = 2 },
        {
          name = "buffer",
          keyword_length = 3,
          option = { get_bufnrs = visible_buffers },
          group_index = 2,
        },
      }

      opts.view = {
        entries = {
          selection_order = "near_cursor",
        },
      }

      opts.window = {
        completion = {
          border = "rounded",
          winhighlight = "Search:None,NormalFloat:Normal,FloatBorder:NonText",
          col_offset = -1,
        },
        documentation = {
          border = "solid",
          winhighlight = "Search:None",
        },
      }

      opts.formatting = {
        format = require("lspkind").cmp_format({
          mode = "symbol_text",
          maxwidth = 35,
          menu = {
            luasnip = "[SNIP]",
            nvim_lsp = "[LSP]",
            path = "[PATH]",
            buffer = "[BUF]",
          },
        }),
      }

      opts.experimental = { ghost_text = { hl = "NonText" } }

      return opts
    end,
  },

  -- snippet engine
  {
    "L3MON4D3/LuaSnip",
    dependencies = "WieeRd/friendly-snippets",
    lazy = true,
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    config = function(_, opts)
      require("luasnip").setup(opts)
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}
