local vim = vim
local cond = require("heirline.conditions")
local utils = require("heirline.utils")

local function get_palette()
  local hl = utils.get_highlight
  return {
    Special = hl("Special").fg,
  }
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

-- `128L 64C  32% ` | `  1L  2C   3% `
-- Current line, column and percentage through file
local Ruler = {
  provider = "%3lL %2cC %3p%% ",
  hl = { bold = true },
}

-- `[protocol]`
-- Extract `protocol://` from URL-like buffer names
local FileProtocol = {
  condition = function(self)
    return self.protocol
  end,
  provider = function(self)
    return ("[%s]"):format(self.protocol)
  end,
  hl = { fg = "Special", bold = true },
}

-- `  `
-- Filetype icon from Devicon
local FileIcon = {
  init = function(self)
    if self.path:match("/$") then
      self.icon = ""
      self.highlight = "Directory"
    else
      local devicons = require("nvim-web-devicons")
      self.icon, self.highlight =
        devicons.get_icon_by_filetype(vim.bo.filetype, { default = true })
    end
  end,
  provider = function(self)
    return (" %s "):format(self.icon)
  end,
  hl = function(self)
    return self.highlight
  end,
}

-- `/etc/fstab` | `~/.profile` | `src/main.rs`
-- Shortened path relative to $HOME and $PWD
local FilePath = {
  provider = function(self)
    return vim.fn.fnamemodify(self.path, ":~:.")
  end,
}

-- `[protocol]  src/main.rs ... 128L 64C  32% `
-- Generic statusline ready for normal files as well as most special buffers
local File = {
  init = function(self)
    self.protocol = nil
    self.path = vim.api.nvim_buf_get_name(0)

    if self.path == "" then
      self.path = "[No Name]"
      return
    end

    local protocol, name = self.path:match("(.-)://(.-/?)/?$")
    if protocol then
      self.protocol = protocol
      self.path = name
    end
  end,

  FileProtocol,
  FileIcon,
  FilePath,
  Align,
  Ruler,
  Truncate,
}

local StatusLine = {
  hl = function()
    return cond.is_active() and "StatusLine" or "StatusLineNC"
  end,

  -- use the first component that matches the condition
  fallthrough = false,
  File,
}

require("heirline").setup({
  statusline = StatusLine,
  tabline = nil,
  opts = { colors = get_palette() },
})
