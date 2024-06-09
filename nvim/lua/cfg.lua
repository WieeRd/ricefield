local vim = vim
local M = {}

function M.load_globals(globals)
  local g = vim.g

  for name, value in pairs(globals) do
    g[name] = value
  end
end

function M.load_options(options)
  local opt = vim.opt

  for name, value in pairs(options) do
    opt[name] = value
  end
end

function M.load_keymaps(keymaps)
  local map = vim.keymap.set

  for mode, mappings in pairs(keymaps) do
    for lhs, rhs_and_opts in pairs(mappings) do
      local rhs, opts

      if type(rhs_and_opts) == "table" then
        rhs = rhs_and_opts[1]
        rhs_and_opts[1] = nil
        opts = rhs_and_opts
      else
        rhs = rhs_and_opts
        opts = {}
      end

      map(mode, lhs, rhs, opts)
    end
  end
end

function M.load_autocmds(autocmds)
  local autocmd = vim.api.nvim_create_autocmd
  local augroup = vim.api.nvim_create_augroup
  local group = augroup("cfg", { clear = true })

  for i = 1, #autocmds do
    local opts = autocmds[i]
    local event = opts[1]
    opts[1] = nil
    opts.group = opts.group or group

    autocmd(event, opts)
  end
end

function M.setup(cfg)
  cfg = cfg or {}

  M.load_globals(cfg.globals or {})
  M.load_options(cfg.options or {})
  M.load_keymaps(cfg.keymaps or {})
  M.load_autocmds(cfg.autocmds or {})

  vim.cmd.colorscheme(cfg.colorscheme or "default")
end

return M
