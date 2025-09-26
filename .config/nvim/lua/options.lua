-- See `:help vim.opt`
-- For more options, you can see `:help option-list`

local opt = vim.opt

-- Wrapped line repeats indent. (Nope, don't like this).
-- opt.breakindent = true

-- Use the clipboard as the unnamed register.
-- Syncs the clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
-- See `:help 'clipboard'`
-- Commented out since I can't see it doing anything.
-- vim.schedule(function()
--   opt.clipboard = 'unnamedplus'
-- end)

-- fillchars
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  diff = "╱",
  eob = " ",
}

-- Ignore case when searching.
opt.ignorecase = true

-- Preview substitutions live, as you type.
opt.inccommand = 'split'

-- Disable incremental search
-- opt.incsearch = false

opt.laststatus = 3

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
opt.list = false
opt.listchars = {lead = '·', nbsp = '␣', tab = '│ ', trail = '·'}

-- Disable all the extra mouse stuff.
-- opt.mouse = ''

-- Right click will not move the cursor. To extend selection use shift+left click.
opt.mousemodel = 'popup'

-- Show relative line numbers.
-- opt.relativenumber = true

-- How many lines of the buffer to keep above and below the cursor.
-- Disabled because mouse selection moves the cursor and it's annoying when it jumps doing this.
-- opt.scrolloff = 10

-- Don't show the mode, since it's already in the status line.
opt.showmode = false

-- Don't ignore case when searching with capital letters.
opt.smartcase = true

-- Spelling
opt.spelllang = 'en_au,en_gb,en_us'

-- Configure how new splits should be opened.
opt.splitbelow = true

-- Use the 16 colour palette and choose the vim theme.
-- The colours look awful to me when using the vim colorscheme with 256+ colour palettes.
-- Not disabled while using a better colorscheme.
-- opt.termguicolors = false

-- Decrease mapped sequence wait time from the default of 1000ms.
-- Displays which-key popup sooner. (I disabled which-key as it is interferring with nvim-lint)
-- Also this forces me to use the leader key faster than I like.
-- opt.timeoutlen = 300

-- Save undo history.
-- opt.undofile = true

-- Decrease update time from default of 4000ms.
-- If this many milliseconds nothing is typed the swap file will be written to disk.
opt.updatetime = 250
