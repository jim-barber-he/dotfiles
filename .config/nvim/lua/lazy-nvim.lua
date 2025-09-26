-- lazy.nvim is a plugin manager for neovim.

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath})
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      {'Failed to clone lazy.nvim:\n', 'ErrorMsg'},
      {out, 'WarningMsg'},
      {'\nPress any key to exit...'},
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require('lazy').setup(
  {
    -- Automatically checks and notifies if there are plugin updates.
    -- To update them run :Lazy update
    checker = {enabled = true},
    -- The colorscheme that is used for the popup that is shown when installing updates.
    install = {colorscheme = {'modus'}},
    -- Disable laurocks support.
    rocks = {enabled = false},
    -- Import plugins from the plugins directory.
    spec = {{import = 'plugins'}},
    -- If using a Nerd Font, set icons to an empty table to use the default lazy.vim Nerd Font icons.
    -- Otherwise, define a table with unicode icons to make things look nicer for more basic fonts.
    ui = {
      icons = vim.g.have_nerd_font and {} or {
        cmd = '⌘',
        config = '🛠 ',
        event = '📅',
        ft = '📂',
        init = '⚙',
        keys = '🗝 ',
        plugin = '🔌',
        runtime = '💻',
        require = '🌙',
        source = '📄',
        start = '🚀',
        task = '📌',
        lazy = '💤 ',
      },
    },
  }
)
