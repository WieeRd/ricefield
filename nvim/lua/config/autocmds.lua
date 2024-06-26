return {
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
    desc = "Briefly highlight the yanked text",
  },

  {
    "ColorScheme",
    callback = function(event)
      local theme = event.match
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
    desc = "Set terminal window options",
  },

  {
    "VimResized",
    command = "tabdo wincmd =",
    desc = "Resize panes on terminal window resize",
  },

  {
    "BufWritePre",
    callback = function(event)
      if event.match:match("^%w%w+:[\\/][\\/]") then
        return
      end
      local file = vim.uv.fs_realpath(event.match) or event.match
      vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
    desc = "Auto create intermediate parent directories upon write",
  },
}
