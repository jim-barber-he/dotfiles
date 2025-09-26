vim.filetype.add({
  extension = {
    gotmpl = 'gotmpl',
    j2 = 'jinja2',
  },
  pattern = {
    ['.*[^/][^c][^f]/templates/.*%.txt'] = 'gotmpl',
    ['.*[^/][^c][^f]/templates/.*'] = 'helm',
    ['helmfile.*%.ya?ml'] = 'helm',
    ['helmfile.*%.ya?ml%.gotmpl'] = 'helm',
    ['.*/cf/config/.*%.ya?ml'] = 'jinja2',
  },
})
