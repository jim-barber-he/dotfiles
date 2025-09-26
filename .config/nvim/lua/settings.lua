-- Set a black background on any colorscheme that is loaded.
-- vim.cmd('highlight Normal guibg=black')
-- vim.cmd('highlight EndOfBuffer guibg=black')

-- vim.cmd('colorscheme vim')

-- Disable the `How-to disable mouse` and the blank separator above it in the right-click mouse button.
-- Unnecessary if `set mouse=` is on since the right-click menu no longer exists.
vim.cmd([[
  aunmenu PopUp.How-to\ disable\ mouse
  aunmenu PopUp.-1-
]])
