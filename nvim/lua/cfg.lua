local vim = vim
local M = {}

function M.setup(cfg)
  vim.cmd.colorscheme(cfg.colorscheme or "default")
end

return M
