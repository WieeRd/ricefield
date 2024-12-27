return {
  -- autosave and restore sessions
  -- FEAT: implement `:SessionSearch` using `vim.ui.select`
  {
    "olimorris/persisted.nvim",
    priority = 0,
    opts = {
      autosave = true,
      should_save = function()
        return vim.g.persisting
          and (
            vim.g.persisted_loaded_session
            or vim.fn.isdirectory(".git") == 1
            or vim.fn.filereadable(".git") == 1
          )
      end,
      -- FIX: do not autoload if neovim was started with piped data
      -- | https://github.com/olimorris/persisted.nvim/discussions/140
      autoload = vim.v.argv[#vim.v.argv] ~= "+Man!",
      follow_cwd = false,
    },
  },

  -- `:G` wrapper command & interactive git status
  {
    "tpope/vim-fugitive",
    lazy = false,
    keys = { { "<Leader>g<Tab>", "<Cmd>tab G<CR>", desc = "Status" } },
  },

  -- display and stage/restore hunks in the buffer
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
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
        "<Leader>go",
        function()
          local acts = require("gitsigns").get_actions() or {}
          if acts.preview_hunk then
            acts.preview_hunk()
          elseif acts.blame_line then
            acts.blame_line({
              full = true,
              ignore_whitespace = true,
              extra_opts = { "-C", "-C", "-C" },
            })
          end
        end,
        desc = "Hunk or Blame",
      },
      {
        "<Leader>g+",
        "<Cmd>Gitsigns toggle_signs<CR>",
        desc = "Toggle Signs",
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

  -- cycle through split view of `git diff` and `git log`
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      {
        "<Leader>gd",
        "<Cmd>DiffviewOpen --untracked-files=false<CR>",
        desc = "Diff",
      },
      {
        "<Leader>gl",
        "<Cmd>DiffviewFileHistory %<CR>",
        desc = "File Revisions",
      },
      {
        "<Leader>gl",
        "<Cmd>'<,'>DiffviewFileHistory<CR>",
        mode = "x",
        desc = "Range Revisions",
      },
      {
        "<Leader>gL",
        "<Cmd>DiffviewFileHistory<CR>",
        desc = "Project Revisions",
      },
    },
    opts = {
      enhanced_diff_hl = true,
      hooks = {
        diff_buf_read = function(_)
          vim.wo.cursorline = true
          vim.wo.cursorlineopt = "both"
          vim.wo.relativenumber = false
          vim.wo.wrap = false
        end,
      },
    },
  },
}
