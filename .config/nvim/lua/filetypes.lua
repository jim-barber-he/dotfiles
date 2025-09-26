vim.filetype.add({
  extension = {
    gotmpl = 'gotmpl',
    j2 = 'jinja2',
  },
  pattern = {
    [".*%.ya?ml%.gotmpl"] = { "yaml.gotmpl", { priority = 50 } },
    [".*%.ya?ml%.j2"] = "yaml.j2",
    ['.*[^/][^c][^f]/templates/.*%.txt'] = 'gotmpl',
    ['.*[^/][^c][^f]/templates/.*'] = 'helm',
    ['%.helmignore'] = 'gitignore',
    ['helmfile.*%.ya?ml'] = { 'helm', { priority = 90 } },
    ['helmfile.*%.ya?ml%.gotmpl'] = { 'helm', { priority = 100 } },
    ['.*/cf/config/.*%.ya?ml'] = 'jinja2',
  },
})
