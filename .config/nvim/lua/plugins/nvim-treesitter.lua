-- Enable treesitter syntax highlighting for all files.
vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    local ft = vim.bo[ev.buf].filetype
    if ft ~= '' and vim.treesitter.language.get_lang(ft) ~= nil then
      pcall(vim.treesitter.start, ev.buf)
    end
  end,
  pattern = { '*' },
})

-- Register a locally built jinja2 parser from https://github.com/uros-5/tree-sitter-jinja2 with changes.
vim.api.nvim_create_autocmd('User', {
  callback = function()
    require('nvim-treesitter.parsers').jinja2 = {
      install_info = {
        -- This files fields might not be needed (or even used).
        files = { 'src/parser.c' },
        path = '~/src/tree-sitter-jinja2/local',
      },
    }
  end,
  pattern = 'TSUpdate',
})

vim.treesitter.language.register("gotmpl", "yaml.gotmpl")
vim.treesitter.language.register("jinja2", "yaml.j2")

return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function(_, _)
    local ensure_installed = {
      'awk',
      'bash',
      'c',
      'css',
      'csv',
      'diff',
      'dockerfile',
      'editorconfig',
      'git_config',
      'git_rebase',
      'gitcommit',
      'gitignore',
      'go',
      'gomod',
      'gotmpl',
      'gpg',
      'hcl',
      'helm',
      'html',
      'javascript',
      'json',
      'json5',
      'lua',
      'make',
      'markdown',
      'markdown_inline',
      'nginx',
      'passwd',
      'pem',
      'perl',
      'php',
      'powershell',
      'printf',
      'python',
      'query',
      'regex',
      'ruby',
      'rust',
      'sql',
      'ssh_config',
      'terraform',
      'toml',
      'typescript',
      'udev',
      'vim',
      'vimdoc',
      'xml',
      'yaml',
    }

    local ok, nvim_treesitter = pcall(require, 'nvim-treesitter')
    if not ok then return end

    nvim_treesitter.install(ensure_installed):wait(300000)
  end,
  enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= 'true',
  lazy = false
}
