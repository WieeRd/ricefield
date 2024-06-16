return {
  clipboard = "unnamedplus",
  mouse = "nv",

  -- recovery files
  undofile = false,
  swapfile = false,

  -- CursorHold event delay
  updatetime = 150,
  -- keymap sequence delay
  timeoutlen = 300,

  -- what to save in session files
  -- FIX: loading folds frequently fail when using semantic folding methods
  -- | like treesitter foldexpr or LSP foldingRange with nvim-ufo.
  -- | would be great if we can lazy load folds in sessions
  sessionoptions = {
    "blank",
    "curdir",
    -- "folds",
    "help",
    "localoptions",
    "tabpages",
    "terminal",
    "winsize",
  },

  -- window splits
  splitright = true,
  splitbelow = false,
  splitkeep = "cursor",

  -- statusline / tabline
  laststatus = 2,
  showtabline = 1,

  -- cmdline
  showcmd = false,
  showmode = false,
  shortmess = "fTOicoltxFn",

  -- 'gutter' section
  signcolumn = "auto",
  foldcolumn = "0",
  number = true,
  relativenumber = true,
  numberwidth = 3,

  -- scroll / line wrapping
  scrolloff = 7,
  sidescrolloff = 5,
  wrap = false,
  smoothscroll = true,
  virtualedit = "block",

  -- special characters
  list = false,
  listchars = { eol = "↲", tab = "» ", trail = "•" },
  fillchars = {
    diff = " ",
    eob = " ",
    fold = " ",
    foldopen = "",
    foldclose = "",
  },

  -- completion menu
  wildmode = "longest:full,full",
  wildmenu = true,
  pumheight = 10,
  pumblend = 0,
  completeopt = { "menu", "menuone", "noselect" },

  -- searching
  hlsearch = true,
  incsearch = true,
  ignorecase = true,
  smartcase = true,

  -- tabs / indentation
  expandtab = false,
  tabstop = 4,
  shiftwidth = 0,
  shiftround = true,
  smartindent = true,

  -- spell
  spelllang = "en",
  spelloptions = "camel",

  -- FEAT: `:h 'diffopt'`
}