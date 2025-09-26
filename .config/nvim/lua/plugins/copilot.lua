return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= 'true',
  event = 'InsertEnter',
  init = function()
    vim.keymap.set(
      'n',
      '<leader>cp',
      function()
        require('copilot.panel').open()
        vim.opt.filetype='copilot'
      end,
      {noremap = true, silent = true, desc = 'Open Copilot'}
    )
    vim.keymap.set(
      'n',
      '<leader>ct',
      function()
        require('copilot.suggestion').toggle_auto_trigger()
        vim.g.copilot_suggestions = not vim.g.copilot_suggestions
        vim.cmd.echo('"Copilot Suggestions are now"' .. (vim.g.copilot_suggestions and '"enabled"' or '"disabled"'))
      end,
      {noremap = true, silent = true, desc = 'Toggle Copilot Suggestions'}
    )
  end,
  opts = {
    -- copilot_model = "gpt-4o-copilot",
    -- Example of how to only allow specific file types and disable for all other filetypes and ignore default `filetypes`.
    -- filetypes = {
    --   go = true,
    --   javascript = true,
    --   typescript = true,
    --   ['*'] = false,
    -- },
    panel = {
      -- Suggestions are refreshed as you type in the buffer.
      auto_refresh = true,
      -- This is the default keymap, but I'm putting it here for documentation purposes.
      -- The open doesn't happen while in normal mode.
      -- keymap = {
      --   jump_prev = '[[',
      --   jump_next = ']]',
      --   accept = '<CR>',
      --   refresh = 'gr',
      --   open = '<M-CR>'
      -- },
      layout = {
        position = 'left',
        -- On a 1920 pixel wide screen with my font size, this end up as an 80 col window for Copilot and 132 for code. Perfect.
        ratio = 0.38
      },
    },
    suggestion = {
      -- If auto_trigger is true, Copilot starts suggesting as soon as you enter insert mode.
      -- When false (the default), use the `next` or `prev` keymap to trigger suggestions.
      -- To toggle auto trigger for the current buffer, use `require('copilot.suggestion').toggle_auto_trigger()`
      auto_trigger = true,
      keymap = {
        accept = '<C-f>',
        accept_word = '<C-k>',
        accept_line = '<C-l>',
        next = '<M-]>',
        prev = '<M-[>',
        dismiss = '<C-]>',
      },
    },
  },
}
