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

function M.setup(cfg)
  cfg = cfg or {}

  M.load_globals(cfg.globals or {})
  M.load_options(cfg.options or {})

  vim.cmd.colorscheme(cfg.colorscheme or "default")
end

return M
