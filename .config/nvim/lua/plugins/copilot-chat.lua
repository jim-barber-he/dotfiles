return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    build = 'make tiktoken',
    config = function(_, opt)
      local chat = require('CopilotChat')
      chat.setup(opt)

      -- Open the Copilot chat window if the terminal is > 132 characters wide and only one window is open,
      -- then focus back to the buffer. If the window is not that wide, the user will have to open it themselves.
      -- if vim.api.nvim_get_option('columns') > 132 and vim.fn.winnr('$') == 1 then
      --   chat.open()
      --   vim.cmd.wincmd('p')
      -- end

      -- If the neovim window is resized, open the Copilot chat window if it's wider than 132 chars otherwise close it.
      -- vim.api.nvim_create_autocmd({'VimResized'}, {
      --   callback = function()
      --     if vim.api.nvim_get_option('columns') > 132 then
      --       -- Only auto-open the Copilot chat window if only one window is open.
      --       if vim.fn.winnr('$') == 1 then
      --         chat.open()
      --         vim.cmd.wincmd('p')
      --       end
      --     else
      --       chat.close()
      --     end
      --   end
      -- })

      -- Close the Copilot chat window when closing the last ordinary window.
      -- The QuitPre event is triggered just before quitting and closing a window,
      -- therefore the number of windows will be 2 if the Copilot chat window is open.
      vim.api.nvim_create_autocmd({'QuitPre'}, {
        callback = function()
          if vim.fn.winnr('$') == 2 then
            chat.close()
          end
        end
      })

      -- Key mapping to toggle the Copilot chat window.
      vim.keymap.set('n', '<leader>cc', '<cmd>CopilotChatToggle<CR>', {noremap = true, silent = true, desc = 'Open Copilot Chat'})
    end,
    dependencies = {
      {'nvim-lua/plenary.nvim'},
      {'zbirenbaum/copilot.lua'}, -- or github/copilot.vim
    },
    enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= 'true',
    event = 'VeryLazy',
    -- I don't know why this key mapping is not working...
    -- I've configured it in the config setting above instead.
    -- keys = {
    --   '<leader>cc',
    --   ':CopilotChatToggle<CR>',
    --   desc = 'Toggle Copilot Chat',
    -- },
    opts = {
      -- auto_insert_mode = true,
      -- model = 'gpt-4.1',   -- This is the default model.
      -- model = 'claude-sonnet-4',
      -- temperature = 0.1,  -- Lower = focused, higher = creative
      window = {
        -- Open the Copilot window on the left.
        col = 0,
        row = 0,
        -- Set the width to 38% of the buffer width.
        -- On a 1920 pixel wide screen with an 11 point font, it works out to 80 characters for Copilot and 132 for the buffer.
        width = 0.38,
      },
    },
  },
}
