local vim = vim
local M = {}

function M.globals(globals)
  local g = vim.g
  for name, value in pairs(globals) do
    g[name] = value
  end
end

function M.options(options)
  local opt = vim.opt
  for name, value in pairs(options) do
    opt[name] = value
  end
end

function M.keymaps(keymaps)
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

function M.autocmds(autocmds)
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

function M.commands(commands)
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

function M.signs(signs)
  local sign_define = vim.fn.sign_define
  for name, attr in pairs(signs) do
    sign_define(name, attr)
  end
end

function M.plugins(plugins)
  if not plugins.enabled then
    return false
  end

  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"

  if not vim.uv.fs_stat(lazypath) then
    vim.notify("Bootstrapping the plugin manager...")
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      lazyrepo,
      lazypath,
    })
  end

  vim.opt.runtimepath:prepend(lazypath)
  require("lazy").setup(plugins.spec, plugins.opts)

  return true
end

return M
