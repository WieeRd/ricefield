local INSERT = "i"
local NORMAL = "n"
local VISUAL = "x"
local ACTION = { "n", "x" }
local MOTION = { "n", "x", "o" }
local TEXTOBJ = { "x", "o" }

return {
  [INSERT] = {
    -- ESC alternative
    ["kj"] = "<Esc>",

    -- I prefer manually triggering the signature help
    ["<C-s>"] = { vim.lsp.buf.signature_help, desc = "Signature Help" },
  },

  [NORMAL] = {
    -- frequently used commands
    ["<C-s>"] = "<Cmd>silent update<CR>",
    ["ZA"] = "<Cmd>xall<CR>",

    ["<Leader>="] = { ":lua =", desc = "Lua Prompt" },
    ["<Leader>\\"] = { ":vert ", desc = "vert {cmd}" },
    ["<Leader><Tab>"] = { ":tab ", desc = "tab {cmd}" },

    -- file explorer (netrw or oil.nvim if plugins are enabled)
    ["-"] = { "<Cmd>edit %:h", desc = "Browse Parent Dir" },
    ["_"] = { "<Cmd>edit .", desc = "Browse CWD" },

    -- tabpage management
    ["<Leader>+"] = "<Cmd>tabnew<CR>",
    ["<Leader>-"] = "<Cmd>tabclose<CR>",
    ["<Leader>_"] = "<Cmd>tabonly<CR>",

    ["]t"] = "<Cmd>tabnext<CR>",
    ["[t"] = "<Cmd>tabprevious<CR>",
    ["]T"] = "<Cmd>tabmove +1<CR>",
    ["[T"] = "<Cmd>tabmove -1<CR>",

    -- {N}<Tab> opens {N}th tabpage
    ["<Tab>"] = { "v:count == 0 ? '<C-i>' : 'gt'", expr = true },

    -- +term: open embedded terminal
    ["<Leader>t."] = { "<Cmd>term<CR>a", desc = "Current Window" },
    ["<Leader>ts"] = { "<Cmd>split +term<CR>a", desc = "Horizontal Split" },
    ["<Leader>tv"] = { "<Cmd>vsplit +term<CR>a", desc = "Vertical Split" },
    ["<Leader>t<Tab>"] = { "<Cmd>tab term<CR>a", desc = "New Tabpage" },

    -- +lsp: language server interactions
    ["<Leader>lr"] = { vim.lsp.buf.rename, desc = "Rename Symbol" },
    ["<Leader>la"] = { vim.lsp.buf.code_action, desc = "Code Actions" },
    ["<Leader>lo"] = { vim.lsp.codelens.run, desc = "Run CodeLens" },
    ["<Leader>li"] = {
      function()
        local hint = vim.lsp.inlay_hint
        hint.enable(not hint.is_enabled())
      end,
      desc = "Toggle Inlay Hints",
    },

    ["]d"] = { vim.diagnostic.goto_next, desc = "Next Diagnostic" },
    ["[d"] = { vim.diagnostic.goto_prev, desc = "Prev Diagnostic" },

    -- fzf package provides simple fuzzy finder plugin
    ["<C-p>"] = "<Cmd>FZF<CR>",
  },

  [VISUAL] = {
    -- ["<"] = "<gv",
    -- [">"] = ">gv",
  },

  [ACTION] = {
    -- move based on display (wrapped) lines rather than real lines
    -- NOTE: excluded from operator-pending mode because
    -- | gj, gk are char-wise while j, k are line-wise
    ["j"] = { "v:count == 0 ? 'gj' : 'j'", expr = true },
    ["k"] = { "v:count == 0 ? 'gk' : 'k'", expr = true },
    ["<Down>"] = { "v:count == 0 ? 'gj' : 'j'", expr = true },
    ["<Up>"] = { "v:count == 0 ? 'gk' : 'k'", expr = true },

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

  [MOTION] = {
    ["<Leader>"] = "<Nop>",

    -- I hate the semi-regex 'magic' search mode (:h /magic)
    ["/"] = { "/\\V", desc = "Literal Search" },
    ["?"] = { "?\\V", desc = "Reverse Literal Search" },
    ["g/"] = { "/\\v", desc = "Regex Search" },
    ["g?"] = { "?\\v", desc = "Reverse Regex Search" },
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
