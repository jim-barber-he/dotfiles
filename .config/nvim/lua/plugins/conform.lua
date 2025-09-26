-- A plug for formatting code.

return {
  'stevearc/conform.nvim',
  cmd = {'ConformInfo'},
  enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= 'true',
  event = {'BufReadPre', 'BufNewFile'},
  keys = {
    {
      '<leader>cf',
      function()
        require('conform').format({async = false, lsp_format = 'fallback'})
      end,
      desc = 'Format file or range (in visual mode)',
      mode = {'n', 'v'},
    },
  },
  opts = {
    formatters = {
      jq = {
        prepend_args = {'--sort-keys'},
      },
    },
    formatters_by_ft = {
      json = {'jq'},
      -- ruff_format, ruff_organize_imports
      python = {'black', 'ruff_fix'},
      -- shellharden, shfmt
      sh = {'shellcheck'},
      terraform = {'terraform_fmt'},
    },
    -- format_on_save = {async = false, lsp_fallback = true},
    format_on_save = function(bufnr)
        -- Disable `format_on_save lsp_fallback` for languages that don't have a well standardized coding style.
        -- You can add additional languages here or re-enable it for the disabled ones.
        local disable_filetypes = {c = true, cpp = true}
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          aync = false,
          lsp_format = lsp_format_opt,
          timeout_ms = 500,
        }
      end,
  },
}
