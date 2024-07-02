return {
  -- `:Git` wrapper command & interactive git status
  {
    "tpope/vim-fugitive",
    cmd = "G",
    keys = { { "<Leader>gi", "<Cmd>tab G<CR>", desc = "Status" } },
  },

  -- display and stage/restore hunks in the buffer
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
      },
      -- FIX: need more distinguishable and prettier staged signs
      signs_staged_enable = false,
      current_line_blame_opts = { delay = 100 },
      preview_config = { border = "solid", row = 1, col = 1 },
    },
    config = function(_, opts)
      local gs = require("gitsigns")
      local map = vim.keymap.set
      gs.setup(opts)

      -- buffer actions
      map("n", "<Leader>gR", gs.reset_buffer, { desc = "Restore File" })
      map("n", "<Leader>gS", gs.stage_buffer, { desc = "Stage File" })
      map("n", "<Leader>gU", gs.reset_buffer_index, { desc = "Unstage File" })

      -- hunk actions
      map(
        { "n", "x" },
        "<Leader>gr",
        ":Gitsigns reset_hunk<CR>",
        { desc = "Restore Hunk" }
      )
      map(
        { "n", "x" },
        "<Leader>gs",
        ":Gitsigns stage_hunk<CR>",
        { desc = "Stage Hunk" }
      )
      map(
        { "n", "x" },
        "<Leader>gu",
        ":Gitsigns undo_stage_hunk<CR>",
        { desc = "Unstage Hunk" }
      )

      -- hunk textobject & motions
      map({ "o", "x" }, "ah", gs.select_hunk, { desc = "a Hunk" })
      map("n", "]c", function()
        return vim.wo.diff and "]c" or "<Cmd>Gitsigns next_hunk<CR>"
      end, { expr = true, desc = "Next Change" })
      map("n", "[c", function()
        return vim.wo.diff and "[c" or "<Cmd>Gitsigns prev_hunk<CR>"
      end, { expr = true, desc = "Prev Change" })

      -- toggle features
      map("n", "<Leader>g+", gs.toggle_signs, { desc = "Toggle Signs" })
      map("n", "<Leader>g=", gs.toggle_linehl, { desc = "Toggle Highlights" })
      map(
        "n",
        "<Leader>gb",
        gs.toggle_current_line_blame,
        { desc = "Toggle Blame" }
      )

      -- hunk/blame are mutually exclusive
      map("n", "<Leader>gp", function()
        local acts = gs.get_actions() or {}
        local cmd = acts.blame_line or acts.preview_hunk
        return cmd and cmd()
      end, { desc = "Preview Hunk/Blame" })
    end,
  },
}
