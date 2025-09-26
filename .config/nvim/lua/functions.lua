-- Function to toggle the display of diagnostics.
-- Can be used to hide results from lints and so on.
function Toggle_diagnostics()
  vim.g.diagnostics_active = not vim.g.diagnostics_active
  vim.diagnostic.enable(vim.g.diagnostics_active)
  vim.cmd.echo('"Diagnostics are now"' .. (vim.g.diagnostics_active and '"enabled"' or '"disabled"'))
end

-- Function to toggle the display of whitespace characters via symbols.
function Toggle_list()
  vim.g.list_active = not vim.g.list_active
  vim.opt.list = vim.g.list_active
end

-- Function to toggle spell checking.
function Toggle_spell()
  vim.g.check_spell = not vim.g.check_spell
  vim.opt.spell = vim.g.check_spell
  vim.cmd.echo('"Spell checking is now"' .. (vim.g.check_spell and '"enabled"' or '"disabled"'))
end

-- Provide icons for diagnostics instead of using letters.
local diag_icons = {
  Error = '',
  Hint = '',
  Info = '',
  Warn = '',
}
for type, icon in pairs(diag_icons) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
end

-- Override vim.notify_once to stop copilot's annoying warning while I'm on neovim 0.10.x.
-- if vim.fn.has("nvim-0.11") == 0 then
--   local vim_notify_once = vim.notify_once
--   vim.notify_once = function(msg, level, opts)
--     if msg and msg:match("%[copilot.lua%] Neovim 0.11%+") then
--      return
--     end
--     return vim_notify_once(msg, level, opts)
--   end
-- end
