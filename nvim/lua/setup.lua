local vim = vim
local M = {}

-- FEAT: add loaders - signs, lsp(diagnostics, keymaps)
-- FEAT: add unloaders
-- FEAT: add management commands
-- FEAT: keep both original and evaluated config table
-- NOTE: autolsp.nvim

function M.tbl_or_mod(target)
  if type(target) == "table" then
    return target
  else
    package.loaded[target] = nil
    return require(target)
  end
end

function M.bool_or_func(target)
  if type(target) == "function" then
    return target()
  else
    return target
  end
end

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

function M.load_commands(commands)
  local command = vim.api.nvim_create_user_command

  for name, cmd_and_opts in pairs(commands) do
    local cmd, opts

    if type(cmd_and_opts) == "table" then
      cmd = cmd_and_opts[1]
      cmd_and_opts[1] = nil
      opts = cmd_and_opts
    else
      cmd = cmd_and_opts
      opts = {}
    end

    command(name, cmd, opts)
  end
end

function M.load_plugins(plugins)
  if not M.bool_or_func(plugins.enabled) then
    return false
  end

  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.uv.fs_stat(lazypath) then
    if not M.bool_or_func(plugins.bootstrap) then
      return false
    end

    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim",
      lazypath,
    })
  end

  vim.opt.runtimepath:prepend(lazypath)
  require("lazy").setup(plugins.spec, plugins.opts)

  return true
end

function M.setup(cfg)
  cfg = M.tbl_or_mod(cfg or {})

  M.load_globals(M.tbl_or_mod(cfg.globals or {}))
  M.load_options(M.tbl_or_mod(cfg.options or {}))
  M.load_keymaps(M.tbl_or_mod(cfg.keymaps or {}))
  M.load_autocmds(M.tbl_or_mod(cfg.autocmds or {}))
  M.load_commands(M.tbl_or_mod(cfg.commands or {}))

  if M.load_plugins(M.tbl_or_mod(cfg.plugins or {})) then
    vim.cmd.colorscheme(cfg.colorscheme.plugin or "default")
  else
    vim.cmd.colorscheme(cfg.colorscheme.builtin or "default")
  end
end

return M
