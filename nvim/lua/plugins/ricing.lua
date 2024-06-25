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
    opts = {
      compile = true,
      colors = { theme = { all = { ui = { bg_gutter = "none" } } } },
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
      filetype_exclude = { "help", "markdown", "text", "gitcommit" },
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
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
      -- FEAT: MAYBE: custom fold text
      -- | fold_virt_text_handler = nil,
    },
  },
}
