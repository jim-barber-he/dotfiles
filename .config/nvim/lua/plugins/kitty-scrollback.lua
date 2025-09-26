return {
  'mikesmithgh/kitty-scrollback.nvim',
  cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth', 'KittyScrollbackGenerateCommandLineEditing' },
  config = function()
    require('kitty-scrollback').setup()
  end,
  enabled = true,
  event = { 'User KittyScrollbackLaunch' },
  lazy = true,
}
