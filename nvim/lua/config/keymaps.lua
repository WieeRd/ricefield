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
    ["<C-s>"] = "<Cmd>silent update<CR>",
    ["<Leader>h"] = { ":h ", desc = ":help" },
    ["<Leader>="] = { ":lua =", desc = ":lua" },

    -- +term: open embedded terminal
    ["<Leader>t."] = { "<Cmd>term<CR>", desc = "Current Window" },
    ["<Leader>ts"] = { "<Cmd>split +term<CR>", desc = "Horizontal Split" },
    ["<Leader>tv"] = { "<Cmd>vsplit +term<CR>", desc = "Vertical Split" },
    ["<Leader>t<Tab>"] = { "<Cmd>tab term<CR>", desc = "New Tabpage" },

    -- tabpage management
    ["+"] = "<Cmd>tabnew<CR>",
    ["-"] = "<Cmd>tabclose<CR>",
    ["_"] = "<Cmd>tabonly<CR>",

    -- {count}<Tab> opens tabpage {count}
    -- FEAT: MAYBE: on-demand tabpage auto creation
    ["<Tab>"] = { "v:count == 0 ? '<C-i>' : 'gt'", expr = true },

    ["]t"] = "<Cmd>tabnext<CR>",
    ["[t"] = "<Cmd>tabprevious<CR>",
    ["]T"] = "<Cmd>tabmove +1<CR>",
    ["[T"] = "<Cmd>tabmove -1<CR>",

    -- fzf package provides simple fuzzy finder plugin
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
    ["/"] = { "/\\V", desc = "Literal Search" },
    ["?"] = { "/\\V", desc = "Reverse Literal Search" },
    ["g/"] = { "/\\v", desc = "Regex Search" },
    ["g?"] = { "?\\v", desc = "Reverse Regex Search" },

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
    ["."] = { "iw", desc = "inner word" },
    [","] = { "aW", desc = "a WORD (with white space)" },

    ["ae"] = {
      function()
        vim.cmd("norm! m'vV")
        vim.cmd("keepjumps 0")
        vim.cmd("norm! o")
        vim.cmd("keepjumps $")
      end,
      desc = "Entire Buffer",
    },
  },
}
