return {
  'miikanissi/modus-themes.nvim',
  init = function()
    -- Detect if Neovim is in diff mode
    local is_diff = vim.opt.diff:get()

    if is_diff then
      -- Load a different colorscheme for diff mode
      vim.cmd.colorscheme('vim')
    else
      -- Use modus as default
      vim.cmd.colorscheme 'modus'
    end
  end,
  lazy = false,
  opts = {
    variant = 'default',
  },
  -- Make sure to load this before all the other start plugins.
  priority = 1000,
}
