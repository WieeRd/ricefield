return {
  -- highlight and jump(%) between matching pairs
  {
    "andymass/vim-matchup",
    config = function(_, opts)
      vim.g.matchup_matchparen_offscreen = {}
      require("nvim-treesitter.configs").setup({
        matchup = {
          enable = true,
          disable_virtual_text = true,
        },
      })
    end,
  },

  -- manipulate surrounding pairs
  {
    "kylechui/nvim-surround",
    keys = { "cs", "ds", "ys", { "S", mode = "x" } },
    opts = {},
  },

  -- auto insert/remove closing pairs
  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {},
  },

  -- auto insert closing keywords
  {
    "RRethy/nvim-treesitter-endwise",
    event = "InsertEnter",
    config = function()
      require("nvim-treesitter.configs").setup({
        endwise = { enable = true },
      })
    end,
  },

  -- more and better around/inner text objects
  {
    "echasnovski/mini.ai",
    keys = {
      { "a", mode = { "o", "x" } },
      { "i", mode = { "o", "x" } },
    },
    opts = {
      n_lines = 500,
      silent = true,
    },
  },

  -- current indentation level as a textobject
  {
    "kiyoon/treesitter-indent-object.nvim",
    keys = {
      { "ai", mode = { "o", "x" }, desc = "Around indented block" },
      { "ii", mode = { "o", "x" }, desc = "Inner indented block" },
    },
    config = function()
      local indentobj = require("treesitter_indent_object.textobj")
      local map = vim.keymap.set
      map({ "o", "x" }, "ai", function()
        indentobj.select_indent_outer(true, "V")
      end)
      map({ "o", "x" }, "ii", function()
        indentobj.select_indent_inner(false, "v")
      end)
    end,
  },

  -- tree-sitter nodes as textobjects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    keys = {
      { "a", mode = { "o", "x" } },
      { "i", mode = { "o", "x" } },
      { "]", mode = { "n", "x" } },
      { "[", mode = { "n", "x" } },
    },
    opts = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
        },
        include_surrounding_whitespace = function(args)
          return args.query_string:match(".outer$")
        end,
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]]"] = "@class.outer",
          ["]m"] = "@function.outer",
        },
        goto_next_end = {
          ["]["] = "@class.outer",
          ["]M"] = "@function.outer",
        },
        goto_previous_start = {
          ["[["] = "@class.outer",
          ["[m"] = "@function.outer",
        },
        goto_previous_end = {
          ["[]"] = "@class.outer",
          ["[M"] = "@function.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["],"] = "@parameter.inner",
        },
        swap_previous = {
          ["[,"] = "@parameter.inner",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup({ textobjects = opts })
    end,
  },

  -- split/join multi-line statement
  {
    "Wansmer/treesj",
    keys = {
      { "gS", "<Cmd>TSJSplit<CR>" },
      { "gJ", "<Cmd>TSJJoin<CR>" },
      { "gM", "<Cmd>TSJToggle<CR>" },
    },
    opts = { use_default_keymaps = false },
  },

  -- the year is 2024 and people still do not have .editorconfig in their repo
  {
    "nmac427/guess-indent.nvim",
    event = "BufReadPre",
    opts = {},
  }
}
