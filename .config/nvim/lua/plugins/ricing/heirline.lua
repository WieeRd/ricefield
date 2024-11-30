local vim = vim
local cond = require("heirline.conditions")
local utils = require("heirline.utils")

local function get_palette()
  local hl = utils.get_highlight
  return {}
end

-- update the palette on colorscheme changes
vim.api.nvim_create_augroup("Heirline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local colors = get_palette()
    utils.on_colorscheme(colors)
  end,
  group = "Heirline",
})

local Align = { provider = "%=" }
local Truncate = { provider = "%<" }
local Space = { provider = " " }

local File = {
  provider = "%f",
}

local StatusLine = {
  hl = function()
    return cond.is_active() and "StatusLine" or "StatusLineNC"
  end,

  File,
}

require("heirline").setup({
  statusline = StatusLine,
  tabline = nil,
  opts = { colors = get_palette() },
})
