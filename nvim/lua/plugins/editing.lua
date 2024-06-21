return {
  -- highlight and jump(%) between matching pairs
  {
    "andymass/vim-matchup",
    config = function()
      vim.g.matchup_matchparen_offscreen = {}
      require("nvim-treesitter.configs").setup({
        matchup = {
          enable = true,
          disable_virtual_text = true,
        },
      })
    end,
  },

  -- more and better around/inner text objects
  {
    "echasnovski/mini.ai",
    opts = { silent = true },
    keys = {
      { "a", mode = "o" },
      { "i", mode = "o" },
    },
  },

  -- manipulate surrounding pairs
  {
    "kylechui/nvim-surround",
    opts = {},
    keys = { "cs", "ds", "ys", { "S", mode = "x" } },
  },

  -- auto insert/remove closing pairs
  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {},
  },

  -- split/join multi-line statement
  {
    "Wansmer/treesj",
    opts = { use_default_keymaps = false },
    keys = {
      { "gS", "<Cmd>TSJSplit<CR>" },
      { "gJ", "<Cmd>TSJJoin<CR>" },
      { "gM", "<Cmd>TSJToggle<CR>" },
    },
  },
}
