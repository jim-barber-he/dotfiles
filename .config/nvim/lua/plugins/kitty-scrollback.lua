return {
  'mikesmithgh/kitty-scrollback.nvim',
  cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth', 'KittyScrollbackGenerateCommandLineEditing' },
  config = function()
    require('kitty-scrollback').setup()
  end,
  enabled = function()
    return vim.env.TERM == "xterm-kitty"
  end,
  event = { 'User KittyScrollbackLaunch' },
  lazy = true,
  version = "v7.0.0"  -- Needed for kitty version 0.41.1 that comes with Debian.
}
