local map = vim.keymap.set

map('n', '<Esc>', '<cmd>nohlsearch<cr>', {noremap = true, silent = true, desc = 'Clear search highlighting'})

-- Get Mouse cut and paste to the * buffer (PRIMARY X11 selection)
-- See if this is more workable than the autocmd method I tried.
map('v', '<LeftRelease>', '"*ygv', {noremap = true, silent = true, desc = 'Copy to * buffer'})
map('v', '<2-LeftRelease>', '"*ygv', {noremap = true, silent = true, desc = 'Copy to * buffer'})
map('v', '<3-LeftRelease>', '"*ygv', {noremap = true, silent = true, desc = 'Copy to * buffer'})

-- Keybinds to make split navigation easier.
-- Use CTRL+<hjkl> to switch between windows.
-- See `:help wincmd` for a list of all window commands
map('n', '<C-h>', '<C-w><C-h>', {noremap = true, silent = true, desc = 'Go to Left window'})
map('n', '<C-l>', '<C-w><C-l>', {noremap = true, silent = true, desc = 'Go to Right window'})
map('n', '<C-j>', '<C-w><C-j>', {noremap = true, silent = true, desc = 'Go to Lower window'})
map('n', '<C-k>', '<C-w><C-k>', {noremap = true, silent = true, desc = 'Go to Upper window'})

-- Resize window using <ctrl> arrow keys.
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move Lines.
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- Buffers.
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- n always goes to the next search result, N always goes to the previous search result.
-- It is not affected by the direction of the last search (/ vs ?).
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Diagnostic keymaps.
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
-- Line Diagnostics shows a floating window with the diagnostics for the current line.
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
map('n', '<leader>dl', vim.diagnostic.setloclist, {noremap = true, silent = true, desc = 'Open diagnostic list'})

map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- Toggles.
map('n', '<leader>dt', Toggle_diagnostics, {noremap = true, silent = true, desc = 'Toggle diagnostics'})
map('n', '<leader>st', Toggle_spell, {noremap = true, silent = true, desc = 'Toggle spell checking'})
map('n', '<leader>wt', Toggle_list, {noremap = true, silent = true, desc = 'Toggle whitelist display'})

-- Reselect visual block after changing indent.
map('v', '<', '<gv', {noremap = true, silent = true, desc = 'Reselect visual block after outdenting'})
map('v', '>', '>gv', {noremap = true, silent = true, desc = 'Reselect visual block after indenting'})

-- Commenting.
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- Tabs.
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
