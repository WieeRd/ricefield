return {
  -- WieeRd's favorite theme throughout the years
  -- (I have my own tradition of switching theme each year)
  { "nanotech/jellybeans.vim", enabled = false }, -- 2019
  { "dracula/vim", name = "dracula", enabled = false }, -- 2020
  { "sainnhe/sonokai", enabled = false }, -- 2021
  { "folke/tokyonight.nvim", enabled = false }, -- 2022

  -- my absolute favorite since June 2022, had to drop the said tradition
  {
    "rebelot/kanagawa.nvim",
    priority = 1831,
    opts = {
      compile = true,
      colors = { theme = { all = { ui = { bg_gutter = "none" } } } },
      overrides = function(_)
        return {
          CurSearch = { link = "IncSearch" },
          IlluminatedWordRead = { link = "CursorLine" },
          IlluminatedWordWrite = { link = "CursorLine" },
          IlluminatedWordText = { link = "CursorLine" },
        }
      end,
    },
  },

  -- indentation level indicator
  {
    "lukas-reineke/indent-blankline.nvim",
    -- FIX: LATER: upgrade indent-blankline.nvim to v3
    -- | after lukas-reineke/indent-blankline.nvim#649 is resolved
    version = "2",
    opts = {
      char = "┊",
      context_char = "┊",
      show_current_context = true,
      use_treesitter = true,
      filetype_exclude = {
        "fugitive",
        "gitcommit",
        "help",
        "markdown",
        "text",
      },
      buftype_exclude = {
        "nofile",
        "prompt",
        "quickfix",
        "terminal",
      },
    },
  },

  -- smooth scrolling
  {
    "karb94/neoscroll.nvim",
    keys = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "z" },
    opts = {
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
      hide_cursor = false,
      easing = "quadratic",
    },
  },

  -- fancy folding powered by LSP/TS
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    opts = {
      -- FEAT: MAYBE: custom fold text
      -- | fold_virt_text_handler = nil,
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
    },
    config = function(_, opts)
      local ufo = require("ufo")
      local map = vim.keymap.set
      -- FIX: LATER: implement default-ish zr/zm behavior
      -- | kevinhwang91/nvim-ufo#150
      ufo.setup(opts)
      map("n", "zR", ufo.openAllFolds)
      map("n", "zM", ufo.closeAllFolds)
      map("n", "zr", ufo.openFoldsExceptKinds)
      map("n", "zm", ufo.closeFoldsWith)
      map("n", "z[", ufo.goPreviousClosedFold)
      map("n", "z]", ufo.goNextClosedFold)
    end,
  },
}
