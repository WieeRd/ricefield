return {
  clipboard = "unnamedplus",
  mouse = "nv",

  -- recovery files
  undofile = false,
  swapfile = false,

  -- CursorHold event delay
  updatetime = 150,
  -- keymap sequence delay
  timeoutlen = 400,

  -- what to save and restore through sessions
  sessionoptions = {
    "curdir",
    "folds",
    "globals",
    "help",
    "skiprtp",
    "localoptions",
    "tabpages",
    "terminal",
    "winsize",
  },

  -- stack-like jumplist and preserve the viewport upon jumping
  jumpoptions = { "stack", "view" },

  -- always open all fold of new buffers
  foldlevelstart = 99,

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
  shortmess = "aoOscCF",

  -- 'gutter' section
  signcolumn = "auto:1",
  foldcolumn = "0",
  number = true,
  relativenumber = true,
  numberwidth = 3,

  -- scrolling
  scrolloff = 7,
  sidescrolloff = 5,
  smoothscroll = true,
  virtualedit = "block",

  -- cursorline
  cursorline = true,
  cursorlineopt = "number",

  -- special characters
  list = false,
  listchars = { eol = "↲", tab = "󰌒 ", trail = "•" },
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
  expandtab = true,
  tabstop = 4,
  shiftwidth = 0,
  shiftround = true,
  smartindent = true,

  -- line wrapping
  wrap = true,
  showbreak = "↪ ",
  linebreak = true,
  breakat = " 	!;:,./?",
  breakindent = true,

  -- spell
  spelllang = "en",
  spelloptions = "camel",

  -- FEAT: LATER: adjust diff options (:h 'diffopt`)
}
