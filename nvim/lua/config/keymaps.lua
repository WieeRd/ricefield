local INSERT = "i"
local NORMAL = "n"
local VISUAL = "x"
local MOTION = { "n", "x" }
local TEXTOBJ = { "x", "o" }

return {
  [INSERT] = {
    -- ESC alternative
    ["kj"] = "<Esc>",
  },

  [NORMAL] = {
    -- frequently used commands
    ["<Leader>w"] = "<Cmd>silent update<CR>",
    ["<Leader>W"] = "<Cmd>silent wall<CR>",

    ["<Leader>t."] = "<Cmd>term<CR>",
    ["<Leader>ts"] = "<Cmd>split +term<CR>",
    ["<Leader>tv"] = "<Cmd>vsplit +term<CR>",
    ["<Leader>t<Tab>"] = "<Cmd>tab term<CR>",

    ["<Leader>="] = ":lua =",
    ["<Leader>h"] = ":h ",

    -- tabpage management
    ["]t"] = "gt",
    ["[t"] = "gT",
    ["]T"] = "<Cmd>tabmove +1<CR>",
    ["[T"] = "<Cmd>tabmove -1<CR>",

    ["<Leader>1"] = "1gt",
    ["<Leader>2"] = "2gt",
    ["<Leader>3"] = "3gt",
    ["<Leader>4"] = "4gt",
    ["<Leader>5"] = "5gt",
    ["<Leader>6"] = "6gt",
    ["<Leader>7"] = "7gt",
    ["<Leader>8"] = "8gt",
    ["<Leader>9"] = "9gt",

    ["<Leader>+"] = "<Cmd>tabnew<CR>",
    ["<Leader>-"] = "<Cmd>tabclose<CR>",
    ["<Leader>0"] = "<Cmd>tabonly<CR>",

    ["<C-p>"] = "<Cmd>FZF<CR>",
  },

  [VISUAL] = {
    -- ["<"] = "<gv",
    -- [">"] = ">gv",
  },

  [MOTION] = {
    ["<Leader>"] = "<Nop>",

    -- move based on display lines rather than real lines
    ["j"] = { "v:count == 0 ? 'gj' : 'j'", expr = true },
    ["k"] = { "v:count == 0 ? 'gk' : 'k'", expr = true },
    ["<Down>"] = { "v:count == 0 ? 'gj' : 'j'", expr = true },
    ["<Up>"] = { "v:count == 0 ? 'gk' : 'k'", expr = true },

    -- I hate the semi-regex 'magic' search mode (:h /magic)
    ["/"] = { "/\\V", desc = "literal search" },
    ["?"] = { "/\\V", desc = "literal reverse search" },
    ["g/"] = { "/\\v", desc = "regex search" },
    ["g?"] = { "?\\v", desc = "regex reverse search" },

    -- delete without worrying about yanked content
    ["yp"] = [["0p]], -- paste from yank register
    ["yd"] = [["0d]], -- delete into yank register

    -- yes I use colemak, how could you tell?
    ["<C-w>n"] = "<C-w>j",
    ["<C-w>e"] = "<C-w>k",
    ["<C-w>i"] = "<C-w>l",

    ["<C-w><C-n>"] = "<C-w>j",
    ["<C-w><C-e>"] = "<C-w>k",
    ["<C-w><C-i>"] = "<C-w>l",

    ["<C-w>N"] = "<C-W>J",
    ["<C-w>E"] = "<C-w>K",
    ["<C-w>I"] = "<C-w>L",
  },

  [TEXTOBJ] = {
    ["."] = "iw",
    [","] = "aW",

    ["ae"] = function()
      vim.cmd("norm! m'vV")
      vim.cmd("keepjumps 0")
      vim.cmd("norm! o")
      vim.cmd("keepjumps $")
    end,
  },
}
