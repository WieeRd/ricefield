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
}
