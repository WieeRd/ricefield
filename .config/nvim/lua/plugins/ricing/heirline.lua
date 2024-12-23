local vim = vim
local cond = require("heirline.conditions")
local utils = require("heirline.utils")

local function get_palette()
  local hl = utils.get_highlight
  return {
    Breadcrumbs = hl("Comment").fg,
    Readonly = hl("Constant").fg,
    Special = hl("Special").fg,
    TermIcon = hl("DiffAdded").fg,
    Title = hl("Title").fg,
  }
end

-- update the palette on colorscheme changes
vim.api.nvim_create_augroup("Heirline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function(_)
    local colors = get_palette()
    utils.on_colorscheme(colors)
  end,
  group = "Heirline",
})

local Align = { provider = "%=" }
local Truncate = { provider = "%<" }

-- ` 128L 64C  32% ` | `   1L  2C   3% `
-- Current line, column and percentage through file.
local Ruler = {
  provider = " %3lL %2vC %3p%% ",
  hl = "Bold",
}

-- `   Foo   bar`
-- Display current code context.
local Breadcrumbs = {
  static = {
    loose_hierarchy = {
      help = true,
      man = true,
      markdown = true,
    },
  },
  provider = function(self)
    local exact = not self.loose_hierarchy[vim.bo.filetype]
    local symbols = require("aerial").get_location(exact)
    if #symbols == 0 then
      return
    end

    local crumbs = {}
    for i, symbol in ipairs(symbols) do
      crumbs[i] = {
        {
          provider = " ",
          hl = { fg = "Breadcrumbs" },
        },
        {
          provider = " " .. symbol.icon .. " ",
          hl = "Aerial" .. symbol.kind .. "Icon",
        },
        { provider = symbol.name },
      }
    end

    return self:new(crumbs):eval()
  end,
}

-- `[protocol]`
-- Extract `protocol://` from URL-like buffer names.
local FileProtocol = {
  provider = function(self)
    return self.protocol and ("[%s]"):format(self.protocol)
  end,
  hl = { fg = "Special", bold = true },
}

-- `  `
-- Filetype icon from Devicon.
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

-- `/etc/fstab` | `~/.profile` | `src/main.rs` | `[No Name]`
-- Path shortened relative to $HOME and $PWD.
local FilePath = {
  provider = function(self)
    return self.path == "" and "[No Name]"
      or vim.fn.fnamemodify(self.path, ":~:.")
  end,
}

-- ` [+]`
-- Modified file indicator.
local FileModified = {
  provider = function(_)
    return vim.bo.modified and " [+]"
  end,
}

-- ` `
-- Readonly file indicator.
local FileReadonly = {
  provider = function(_)
    return vim.bo.readonly and " "
  end,
  hl = { fg = "Readonly" },
}

-- ` 2  1 `
-- File diagnostic counter.
local FileDiagnostics = {
  init = function(self)
    local counts = vim.diagnostic.count(0)
    for severity = 1, 4 do
      local count = counts[severity]
      self[severity].provider = count and (" %d "):format(count)
    end
  end,
  update = { "BufEnter", "DiagnosticChanged" },
  { hl = "DiagnosticError" },
  { hl = "DiagnosticWarn" },
  { hl = "DiagnosticInfo" },
  { hl = "DiagnosticHint" },
}

-- ` [dos] ` | ` [mac] `
-- Indicate the use of non-unix line break character.
local FileFormat = {
  condition = function(_)
    return vim.bo.fileformat ~= "unix"
  end,
  provider = function(_)
    return (" [%s] "):format(vim.bo.fileformat)
  end,
  hl = { fg = "Special", bold = true },
}

-- `  src/lib.rs [+]   Foo   bar ... 128L 64C  32% `
-- `[oil]  /etc/systemd/            ...   2L  4C   8% `
-- Generic statusline ready for normal files as well as most special buffers.
local Files = {
  init = function(self)
    self.protocol = nil
    self.path = vim.api.nvim_buf_get_name(0)

    local protocol, path = self.path:match("(.-)://(.-/?)/?$")
    if protocol then
      self.protocol = protocol
      self.path = path
    end
  end,

  FileProtocol,
  FileIcon,
  FilePath,
  FileModified,
  FileReadonly,
  Breadcrumbs,
  Align,
  FileDiagnostics,
  FileFormat,
  Ruler,
  Truncate,
}

-- `:Edit Command` | `/Edit Search`
-- Display the type of `:h cmdline-window`.
local Cmdwin = {
  static = {
    desc = {
      [":"] = "Command",
      [">"] = "Debug",
      ["/"] = "Search",
      ["?"] = "Search",
      ["@"] = "Input",
      ["-"] = "Text",
      ["="] = "Expression",
    },
  },
  condition = function(self)
    self.kind = vim.fn.getcmdwintype()
    return self.kind ~= ""
  end,
  provider = function(self)
    return ("%sEdit %s"):format(self.kind, self.desc[self.kind])
  end,
}

-- `[ ... Title ... ]` | `... [ Title ] ...`
-- Sidebars and bottom panels, special plugin windows in general.
local Panels = {
  provider = function(_)
    -- vim.api.nvim_buf_get_name() tend to return more verbose name
    local bufname = vim.fn.bufname()
    local title = nil

    if bufname == "" then
      title = vim.bo.filetype
    elseif bufname:match("^%S*/") then
      title = vim.fs.basename(bufname)
    else
      title = bufname
    end

    if vim.api.nvim_win_get_width(0) == vim.o.columns then
      return ("%%=[ %s ]%%="):format(title)
    else
      return ("[%%=%s%%=]"):format(title)
    end
  end,
}

-- `:Edit Command` | `[ ... Title ... ]`
-- Special, 'nofile' buffers such as `:h cmdline-window` and sidebars.
local NoFiles = {
  condition = function(_)
    return vim.bo.buftype == "nofile"
  end,
  hl = { fg = "Title", bold = true },

  -- use the first component that matches the condition
  fallthrough = false,
  Cmdwin,
  Panels,
}

-- `:h ` | `$ man `
-- Prefix the documentation type: help page or man page.
local DocType = {
  provider = function(_)
    if vim.bo.buftype == "help" then
      return ":h "
    elseif vim.bo.filetype == "man" then
      return "$ man "
    end
  end,
  hl = { fg = "Special", bold = true },
}

-- `builtin.txt` | `git(1)`
-- Basename of the path to the docs.
local DocTitle = {
  provider = function(_)
    local bufname = vim.api.nvim_buf_get_name(0)
    return vim.fs.basename(bufname)
  end,
}

-- ` :h builtin.txt   expand()             ... 128L 64C  32% `
-- ` $ man git(1)   OPTIONS   -h, --help ... 128L 64C  32% `
-- :help pages and :Man pages.
local Docs = {
  condition = function(_)
    return vim.bo.buftype == "help" or vim.bo.filetype == "man"
  end,

  DocType,
  DocTitle,
  Breadcrumbs,
  Align,
  Ruler,
  Truncate,
}

-- ` ❯ `
-- Terminal icon.
local TermIcon = {
  provider = " ❯ ",
  hl = { fg = "TermIcon" },
}

-- `Yazi: ~/.config/nvim` | `cargo test`
-- Title set by the running program. Default to the command line used to launch the program.
local TermTitle = {
  provider = function(_)
    local title = vim.b.term_title
    local bufname = vim.api.nvim_buf_get_name(0)
    if title ~= bufname then
      -- terminal title set by the running program
      return title
    else
      -- the command line used to launch the program
      return bufname:match("//%d+:(.+)$")
    end
  end,
}

-- ` [+]`
-- Use modified sign to indicate terminal mode.
local TermMode = {
  provider = function(_)
    return vim.api.nvim_get_mode().mode == "t" and " [+]"
  end,
  -- force refresh after switching from/to terminal mode
  update = {
    "ModeChanged",
    pattern = { "t:*", "*:t" },
    callback = vim.schedule_wrap(function()
      vim.cmd("redrawstatus")
    end),
  },
}

-- ` PID 12345 `
-- Process ID of the program running in the terminal buffer.
local TermPid = {
  provider = function(_)
    return (" PID %d "):format(vim.b.terminal_job_pid)
  end,
  hl = "Bold",
}

-- ` ❯ Yazi: ~/.config/nvim ... PID 41774 `
-- Embedded terminal buffers `:h :terminal`
local Terminals = {
  condition = function(_)
    return vim.bo.buftype == "terminal"
  end,

  TermIcon,
  TermTitle,
  TermMode,
  Align,
  TermPid,
  Truncate,
}

local StatusLine = {
  hl = function(_)
    return cond.is_active() and "StatusLine" or "StatusLineNC"
  end,

  -- use the first component that matches the condition
  fallthrough = false,
  Terminals,
  Docs,
  NoFiles,
  Files,
}

require("heirline").setup({
  statusline = StatusLine,
  tabline = nil,
  opts = { colors = get_palette() },
})
