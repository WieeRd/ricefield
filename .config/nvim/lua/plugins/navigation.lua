local FZF_DROPDOWN_MINIMAL = {
  fzf_opts = { ["--layout"] = "reverse" },
  header = false,
  previewer = false,
  winopts = { width = 80, height = 24, row = 0.5, col = 0.5 },
}

local FZF_DROPDOWN_PREVIEW = {
  fzf_opts = { ["--layout"] = "reverse" },
  winopts = {
    width = 80,
    height = 48,
    row = 0.5,
    col = 0.5,
    preview = { layout = "vertical" },
  },
}

return {
  -- fuzzy finder: FZF integration
  {
    "ibhagwan/fzf-lua",
    keys = {
      -- frequently used navigation methods
      {
        "<Leader> ",
        function()
          require("fzf-lua").files(FZF_DROPDOWN_MINIMAL)
        end,
        desc = "Find Files",
      },
      {
        "<Leader>/",
        function()
          require("fzf-lua").lsp_document_symbols(FZF_DROPDOWN_PREVIEW)
        end,
        desc = "Find Symbols",
      },
      -- meta
      { "<Leader>f ", "<Cmd>FzfLua builtin<CR>", desc = "Pickers" },
      { "<Leader>f.", "<Cmd>FzfLua resume<CR>", desc = "Resume" },
      -- files
      { "<Leader>ff", "<Cmd>FzfLua files<CR>", desc = "Files" },
      { "<Leader>fg", "<Cmd>FzfLua git_files<CR>", desc = "Git Files" },
      -- search
      { "<Leader>f/", "<Cmd>FzfLua grep_curbuf<CR>", desc = "Grep File" },
      { "<Leader>f?", "<Cmd>FzfLua live_grep<CR>", desc = "Grep CWD" },
      -- RTFM
      { "<Leader>fh", "<Cmd>FzfLua helptags<CR>", desc = "Help Tags" },
      { "<Leader>fm", "<Cmd>FzfLua manpages<CR>", desc = "Man Pages" },
      -- lists
      { "<Leader>fa", "<Cmd>FzfLua args<CR>", desc = "Args" },
      { "<Leader>fq", "<Cmd>FzfLua quickfix<CR>", desc = "Quickfix" },
      { "<Leader>fl", "<Cmd>FzfLua loclist<CR>", desc = "Loclist" },
      -- LSP
      { "<Leader>fi", "<Cmd>FzfLua lsp_finder<CR>", desc = "LSP Finder" },
      { "<Leader>fr", "<Cmd>FzfLua lsp_references<CR>", desc = "References" },
      {
        "<Leader>fd",
        "<Cmd>FzfLua diagnostics_document<CR>",
        desc = "Document Diagnostics",
      },
      {
        "<Leader>fD",
        "<Cmd>FzfLua diagnostics_workspace<CR>",
        desc = "Workspace Diagnostics",
      },
      {
        "<Leader>fs",
        "<Cmd>FzfLua lsp_document_symbols<CR>",
        desc = "Document Symbols",
      },
      {
        "<Leader>fS",
        "<Cmd>FzfLua lsp_live_workspace_symbols<CR>",
        desc = "Workspace Symbols",
      },
      -- misc
      { "<Leader>f:", "<Cmd>FzfLua commands<CR>", desc = "Commands" },
      { "<Leader>fy", "<Cmd>FzfLua registers<CR>", desc = "Registers" },
    },
    init = function(_)
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("fzf-lua").register_ui_select(FZF_DROPDOWN_PREVIEW)
        return vim.ui.select(...)
      end
    end,
    opts = {
      "telescope",
      winopts = { backdrop = 100 },
      lsp = {
        symbols = {
          symbol_icons = vim.g.lspkind,
          symbol_hl = function(s)
            return "Aerial" .. s .. "Icon"
          end,
          symbol_fmt = function(s, _)
            return s
          end,
        },
        code_actions = { previewer = "codeaction_native" },
      },
    },
  },

  -- file explorer: edit filesystem like a text buffer
  {
    "stevearc/oil.nvim",
    lazy = false,
    keys = {
      { "<C-n>", "<Cmd>Oil --float<CR>", "Browse CWD" },
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
        border = "solid",
        override = function(conf)
          local columns = vim.o.columns
          local lines = vim.o.lines
          conf.width = math.max(math.floor(columns * 0.66 - 2), 120)
          conf.height = math.min(math.floor(lines * 0.66 - 2), lines - 6)
          conf.col = (columns - conf.width) / 2 - 1
          conf.row = (lines - conf.height) / 2 - 1
          return conf
        end,
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
      backends = { "treesitter", "markdown", "asciidoc", "man" },
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
          local columns = vim.o.columns
          return math.max(math.floor(columns * 0.66 - 2), 120)
        end,
        height = function(_)
          local lines = vim.o.lines
          return math.min(math.floor(lines * 0.66 - 2), lines - 6)
        end,
      },
    },
  },
}
