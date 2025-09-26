return {
  'mfussenegger/nvim-lint',
  config = function()
    local lint = require('lint')

    -- Defines the linters that are run when lint.try_lint() is run.
    lint.linters_by_ft = {
      python = {'ruff'},
      sh = {'bash', 'shellcheck'},
      yaml = {'yamllint'},
    }

    -- Add the codespell linter to all file types except bib and css.
    for ft, _ in pairs(lint.linters_by_ft) do
      if ft ~= 'bib' and ft ~= 'css' then table.insert(lint.linters_by_ft[ft], 'codespell') end
    end

    local lint_augroup = vim.api.nvim_create_augroup('lint', {clear = true})

    -- Other events: 'BufEnter', 'BufReadPost', 'TextChanged'
    vim.api.nvim_create_autocmd({'BufReadPost', 'BufWritePost', 'InsertLeave'}, {
      callback = function()
        lint.try_lint()
      end,
      group = lint_augroup,
    })

    -- Run once on start
    lint.try_lint()
  end,
  enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= 'true',
  event = {'BufReadPost', 'BufWritePost', 'InsertLeave'},
  keys = {
    {
      '<leader>ll',
      function()
        require('lint').try_lint()
      end,
      desc = 'Trigger linting for current file'
    }
  },
}
