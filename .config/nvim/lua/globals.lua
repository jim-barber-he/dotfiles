local g = vim.g

-- Set <space> as the leader key. See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
g.mapleader = ' '
g.maplocalleader = ' '

-- Variables I use for toggling settings via functions.
g.check_spell = false
g.copilot_suggestions = true  -- Set to whatever suggestion.enabled is set to when you load the module (default is true).
g.diagnostics_active = true
g.list_active = false

-- Set to true if you have a Nerd Font installed and selected in the terminal.
g.have_nerd_font = true

-- Disable netrw (The vim file explorer you see when opening a directory)
-- g.loaded_netrw       = 1
-- g.loaded_netrwPlugin = 1

-- Disable providers
g.loaded_node_provider    = 0
g.loaded_perl_provider    = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider    = 0
