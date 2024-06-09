local vim = vim
local M = {}

function M.tbl_or_mod(target)
  if type(target) == "table" then
    return target
  else
    package.loaded[target] = nil
    return require(target)
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

function M.setup(cfg)
  cfg = cfg or {}

  M.load_globals(M.tbl_or_mod(cfg.globals or {}))
  M.load_options(M.tbl_or_mod(cfg.options or {}))
  M.load_keymaps(M.tbl_or_mod(cfg.keymaps or {}))
  M.load_autocmds(M.tbl_or_mod(cfg.autocmds or {}))
  M.load_commands(M.tbl_or_mod(cfg.commands or {}))

  vim.cmd.colorscheme(cfg.colorscheme or "default")
end

return M
