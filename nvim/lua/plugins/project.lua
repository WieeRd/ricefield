return {
  -- `:Git` wrapper command & interactive git status
  {
    "tpope/vim-fugitive",
    cmd = "G",
    keys = { { "<Leader>g<Tab>", "<Cmd>tab G<CR>", desc = "Status" } },
  },

  -- display and stage/restore hunks in the buffer
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    keys = {
      {
        "<Leader>gR",
        "<Cmd>Gitsigns reset_buffer<CR>",
        desc = "Restore File",
      },
      {
        "<Leader>gS",
        "<Cmd>Gitsigns stage_buffer<CR>",
        desc = "Stage File",
      },
      {
        "<Leader>gU",
        "<Cmd>Gitsigns reset_buffer_index<CR>",
        desc = "Unstage File",
      },
      {
        "<Leader>gr",
        ":Gitsigns reset_hunk<CR>",
        mode = { "n", "x" },
        desc = "Restore Hunk",
      },
      {
        "<Leader>gs",
        ":Gitsigns stage_hunk<CR>",
        mode = { "n", "x" },
        desc = "Stage Hunk",
      },
      {
        "<Leader>gu",
        "<Cmd>Gitsigns undo_stage_hunk<CR>",
        desc = "Unstage Hunk",
      },
      {
        "ah",
        "<Cmd>Gitsigns select_hunk<CR>",
        mode = { "x", "o" },
        desc = "a Hunk",
      },
      {
        "]c",
        function()
          return vim.wo.diff and "]c" or "<Cmd>Gitsigns next_hunk<CR>"
        end,
        expr = true,
        desc = "Next Change",
      },
      {
        "[c",
        function()
          return vim.wo.diff and "[c" or "<Cmd>Gitsigns prev_hunk<CR>"
        end,
        expr = true,
        desc = "Next Change",
      },
      {
        "<Leader>gi",
        function()
          local actions = require("gitsigns").get_actions() or {}
          local hunk_or_blame = actions.preview_hunk or actions.blame_line
          return hunk_or_blame and hunk_or_blame({
            ignore_whitespace = true,
            extra_opts = { "-C", "-C", "-C" },
          })
        end,
        desc = "Preview Hunk/Blame",
      },
      {
        "<Leader>g+",
        "<Cmd>Gitsigns toggle_signs<CR>",
        desc = "Toggle Signs"
      },
      {
        "<Leader>g=",
        "<Cmd>Gitsigns toggle_linehl<CR>",
        desc = "Toggle Highlights",
      },
      {
        "<Leader>gb",
        "<Cmd>Gitsigns toggle_current_line_blame<CR>",
        desc = "Toggle Blame",
      },
    },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
      },
      signs_staged_enable = false,
      current_line_blame_opts = { delay = 100 },
      preview_config = { border = "solid", row = 1, col = 1 },
    },
  },
}
