return {
  'nvim-lualine/lualine.nvim',
  dependencies = {'nvim-tree/nvim-web-devicons'},
  opts = {
    options = {
      globalstatus = true,
    },
    sections = {
      lualine_b = {
        'branch',
        {
          'diff',
          diff_color = {
              added = {fg = '#00ff00'},
              modified = {fg = 'yellow'},
              removed = {fg = 'red'},
          },
          symbols = {added = ' ', modified = ' ', removed = ' '},
        },
        'diagnostics'
      },
      lualine_x = {'fileformat', 'filetype'},
      lualine_z = {
        function()
          local line = vim.fn.line('.')
          local ccol = vim.fn.charcol('.')
          local vcol = vim.fn.virtcol('.')
          if ccol == vcol then
            return string.format('%3d:%-2d', line, ccol)
          else
            return string.format('%3d:%d-%d', line, ccol, vcol)
          end
        end,
      },
    },
  },
}
