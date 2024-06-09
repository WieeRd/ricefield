return {
  {
    "ColorScheme",
    callback = function(args)
      local theme = args.match
      -- overrides for the 'default' theme are applied to every theme
      vim.cmd.runtime("after/colors/default.vim")
      -- override each theme at the `after/colors/{theme}.vim`
      vim.cmd.runtime(("after/colors/%s.vim"):format(theme))
    end,
    desc = "Override each colorscheme using `after/colors/` directory",
  },

  {
    "TermOpen",
    callback = function(_)
      local wo = vim.wo
      -- FIX: LATER: stop window-local opts getting transferred to new buffers
      -- wo.winhl = "Normal:NormalFloat"
      -- wo.cursorline = true
      wo.scrolloff = 0
      wo.number = false
      wo.relativenumber = false
    end,
    desc = "set terminal window options",
  },

  {
    "TextYankPost",
    callback = function(_)
      vim.highlight.on_yank({
        higroup = "CursorLine",
        timeout = 150,
        on_macro = false,
        on_visual = true,
      })
    end,
    desc = "briefly highlight the yanked text",
  },

  {
    "VimResized",
    command = "tabdo wincmd =",
    desc = "resize panes on terminal window resize",
  },
}
