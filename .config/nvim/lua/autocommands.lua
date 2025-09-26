--  See `:help lua-guide-autocommands`

-- Automatically upgrade the plugins managed by Lazy when starting the editor.
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    if require("lazy.status").has_updates then
      -- If we're running under sudo as a different user, skip updating if the home directory is still the invoking user's.
      if os.getenv("SUDO_USER") then
        -- Determine the user that we have sudo'ed to.
        local current_user = os.getenv("USER") or vim.loop.os_get_passwd().username

        -- Get the passwd entry for the current user to find their home directory.
        local pw = vim.loop.os_get_passwd(current_user)
        local current_user_home = pw and pw.homedir or nil

        -- If the current user's real home doesn't match $HOME, skip the update.
        if current_user_home and current_user_home ~= os.getenv("HOME") then
          return
        end
      end

      -- Perform the auto-update
      require("lazy").update({ show = false })
    end
  end,
  desc = 'Auto-update Lazy plugins',
})

-- When editing a file jump to the last known cursor position like vim does.
-- Don't do it when the position is invalid.
-- The '" refers to a mark that records the last known cursor position.
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local last_pos = vim.fn.getpos([['"]])
    local line = last_pos[2]
    local col = last_pos[3]

    -- Check if the last known cursor position is valid.
    if line > 0 and line <= vim.fn.line('$') then
      -- Jump to the last known cursor position.
      -- col - 1 for 0-based index.
      vim.api.nvim_win_set_cursor(0, {line, col - 1})
    end
  end,
  desc = 'Jump to the last known cursor position',
})

-- Set cursor position to top-left for gitcommit filetypes though instead of the last known cursor position.
-- The FileType event runs after the BufReadPost event, and the filetype is set after the BufReadPost event.
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    vim.api.nvim_win_set_cursor(0, {1, 0})
  end,
  desc = 'Set cursor to top-left for git commit messages',
  pattern = 'gitcommit',
})

-- Close some filetypes with `q`.
vim.api.nvim_create_autocmd('FileType', {
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', {
      buffer = event.buf,
      desc = 'Close buffer',
      silent = true,
    })
  end,
  desc = 'Close some filetypes with q',
  pattern = {
    'checkhealth',
    'copilot',
    'help',
    'notify',
    'qf',
  },
})

-- Spell check in text files.
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    vim.g.check_spell = true
    vim.opt.spell = vim.g.check_spell
  end,
  pattern = { 'text', 'plaintex', 'typst', 'gitcommit', 'markdown' },
})

-- Have the whitespace display turned on by default for certain filetypes.
--[[
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    vim.g.list_active = true
    vim.opt.list = vim.g.list_active
  end,
  pattern = {
    'sh',
  },
})
--]]

-- Set some options for the `helm` file type.
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    vim.opt.expandtab = true
    vim.opt.shiftwidth = 2
    vim.opt.tabstop = 2
  end,
  pattern = {
    'helm',
  },
})

-- Stop the mouse from moving the cursor when clicking to focus a window.
-- IMPROVEMENT would be to get the current mouse state so that can be used on the restore.
--
-- Disable the mouse before losing focus
vim.api.nvim_create_autocmd("FocusLost", {
  callback = function()
    vim.opt.mouse = ""
  end
})
-- Re-enable the mouse shortly after regaining focus
vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
    vim.defer_fn(function()
      vim.opt.mouse = "nvi"
    end, 300)
  end
})

-- Highlight when yanking (copying) text.
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  desc = 'Highlight when yanking (copying) text',
})

-- Rebalance windows when the terminal is resized.
vim.api.nvim_create_autocmd('VimResized', {
  callback = function()
    vim.cmd('wincmd =')
  end,
  desc = 'Rebalance windows when the terminal is resized',
})

-- Change how mouse selection works. This is more like the usual X11 selection.
-- See: https://github.com/neovim/neovim/issues/27675
-- Also when using visual selection via the keyboard the results ends up in the PRIMARY selection too.
-- An alternative to this might to just set the following?
-- But this might copy to "* on every cursor move so might be slow for large selections.
--   vmap <LeftRelease> "*ygv
--   vmap <2-LeftRelease> "*ygv
--   vmap <3-LeftRelease> "*ygv
-- vim.api.nvim_create_autocmd("CursorMoved", {
--   callback = function()
--     local mode = vim.fn.mode(false)
--     if mode == "v" or mode == "V" or mode == "\22" then
--       local selection = vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.'), { type = mode })
--       local trimmed_selection = vim.fn.trim(table.concat(selection, '\n'))
--       vim.fn.setreg('*', trimmed_selection)
--     end
--   end,
--   desc = "Keep * synced with selection",
-- })
