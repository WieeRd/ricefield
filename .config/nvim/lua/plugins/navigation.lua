return {
  -- fuzzy finder: FZF integration
  {
    "ibhagwan/fzf-lua",
    keys = {
      {
        "<C-p>",
        function()
          require("fzf-lua").files({
            header = false,
            previewer = false,
            winopts = { width = 80, height = 24, row = 0.5, col = 0.5 },
          })
        end,
        desc = "Find Files",
      },
      -- meta
      { "<Leader>f ", "<Cmd>FzfLua builtin<CR>", desc = "Pickers" },
      { "<Leader>f.", "<Cmd>FzfLua resume<CR>", desc = "Resume" },
      -- files
      { "<Leader>ff", "<Cmd>FzfLua files<CR>", desc = "Files" },
      { "<Leader>fF", "<Cmd>FzfLua git_files<CR>", desc = "Git Files" },
      -- search
      { "<Leader>f/", "<Cmd>FzfLua grep_curbuf<CR>", desc = "Grep File" },
      { "<Leader>f?", "<Cmd>FzfLua live_grep<CR>", desc = "Grep CWD" },
      -- RTFM
      { "<Leader>fh", "<Cmd>FzfLua helptags<CR>", desc = "Help Tags" },
      { "<Leader>fm", "<Cmd>FzfLua manpages<CR>", desc = "Man Pages" },
      -- lists
      { "<Leader>fa", "<Cmd>FzfLua args<CR>", desc = "Args" },
      { "<Leader>fq", "<Cmd>FzfLua quickfix<CR>", desc = "Quickfix" },
      { "<Leader>fa", "<Cmd>FzfLua loclist<CR>", desc = "Loclist" },
      -- misc
      { "<Leader>fp", "<Cmd>FzfLua registers<CR>", desc = "Registers" },
    },
    opts = {
      "telescope",
      winopts = { backdrop = 100 },
    },
  },

  -- file explorer: edit filesystem like a text buffer
  {
    "stevearc/oil.nvim",
    lazy = false,
    keys = {
      { "<C-n>", "<Cmd>Oil . --float<CR>", "Browse CWD" },
      { "-", "<Cmd>Oil<CR>", "Browse Parent Dir" },
      { "_", "<Cmd>Oil .<CR>", "Browse CWD" },
    },
    opts = {
      win_options = {
        cursorline = true,
        cursorlineopt = "both",
      },
      skip_confirm_for_simple_edits = true,
      watch_for_changes = true,
      float = {
        max_width = 120,
        max_height = 35,
        border = "solid",
      },
      preview = { border = "solid" },
      ssh = { border = "solid" },
      keymaps_help = { border = "solid" },
    },
  },

  -- code outline: view and jump to the tree of symbols
  {
    "stevearc/aerial.nvim",
    keys = {
      { "<Leader>a", "<Cmd>AerialToggle<CR>", desc = "Code Outline" },
    },
    opts = {
      backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
      layout = {
        min_width = 24,
        max_width = 34,
        win_opts = { winhl = "Normal:NormalFloat" },
        default_direction = "left",
      },
      highlight_mode = "full_width",
      highlight_on_hover = true,
      highlight_on_jump = false,
      close_on_select = true,
      show_guides = true,
      guides = {
        mid_item = "├ ",
        last_item = "└ ",
        nested_top = "│ ",
        whitespace = "  ",
      },
    },
  },

  -- floating terminal window: quick shell access
  {
    "akinsho/toggleterm.nvim",
    keys = { "<S-Tab>" },
    opts = {
      open_mapping = "<S-Tab>",
      persist_size = false,
      persist_mode = false,
      direction = "float",
      on_open = function(_)
        vim.wo.winhl = ""
      end,
      float_opts = {
        border = "solid",
        width = function(_)
          return math.min(120, vim.o.columns - 6)
        end,
        height = function(_)
          return math.min(35, math.floor(vim.o.lines * 0.7))
        end,
      },
    },
  },
}
