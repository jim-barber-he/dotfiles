return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function(_, opts)
    local configs = require 'nvim-treesitter.configs'
    local parser_config = require 'nvim-treesitter.parsers'.get_parser_configs()

    configs.setup(opts)

    -- Define a `inject-tmpl!` directive used for handling nested syntax handling where a templating language like
    -- gotmpl or jinja2 is used in a file.
    -- It sets the `injection.language` metadata to the file extension of the file being parsed.
    --   For file.ext.tmpl, (where ext is the language, and tmpl is template language) it sets the injection language to `ext`.
    --   For file.ext it sets the injection language to `ext`.
    -- Needs a injectors.scm query file to use it to perform the work.
    vim.treesitter.query.add_directive('inject-tmpl!', function(_, _, bufnr, _, metadata)
      local fname = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr))
      -- Try to match the filename with two extensions where the first is the language and the second is the template language.
      local _, _, ext, _ = string.find(fname, '.*%.(%w+)(%.%w+)$')
      if ext == nil then
        -- Failing that fall back to assuming the extension is the language.
        _, _, ext = string.find(fname, '.*%.(%w+)$')
      end
      -- Since ext defines the language some adjustments are needed in some cases.
      if ext == "txt" then
        ext = "text"
      end
      metadata['injection.language'] = ext
      if ext == nil then
        vim.notify('Unable to determine language for injection for ' .. fname)
      else
        vim.notify('Injecting ' .. ext .. ' into ' .. fname)
      end
    end, {})

    -- Install the parser for jinja2 from the grammar defined in a git repo since nvim-treesitter doesn't have one.
    -- Need the tree-sitter binary in your PATH.
    parser_config.jinja2 = {
      install_info = {
        -- Locally built https://github.com/uros-5/tree-sitter-jinja2 with changes to get multiline comments working.
        -- Unfortunately this is the best option I've found so far.
        url = '~/src/tree-sitter-jinja2/local',
        files = {'src/parser.c'},

        -- This one has a bug with multiline comments.
        --url = 'https://github.com/uros-5/tree-sitter-jinja2',
        --files = {'src/parser.c'},

        -- Couldn't get this one to work.
        -- url = 'https://github.com/cathaysia/tree-sitter-jinja',
        -- files = {'tree-sitter-jinja/src/parser.c'},
        -- This one is what is linked to from treesitter bit it hasn't exposed comments properly.
        --url = 'https://github.com/dbt-labs/tree-sitter-jinja2',
        --files = {'src/parser.c'},
        --branch = 'main',

        -- generate_requires_npm = true,
        -- requires_generate_from_grammar = false,
      },
    }
  end,
  enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= 'true',
  opts = {
    ensure_installed = {
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
      'robots',
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
    },
    highlight = {enable = true},
    -- Commenting out for now since I think it's not working well.
    -- indent = {enable = true},
    sync_install = false,
  },
}
