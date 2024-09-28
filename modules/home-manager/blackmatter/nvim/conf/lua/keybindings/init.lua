local M = {}

function M.setup()
	local opts = { noremap = true, silent = true }

	-- Set up keybinding helper function
	local keymap = vim.api.nvim_set_keymap

	-- Normal mode keybindings
	keymap('n', '<C-h>', '<C-w>h', opts)  -- Move to left window
	keymap('n', '<C-j>', '<C-w>j', opts)  -- Move to below window
	keymap('n', '<C-k>', '<C-w>k', opts)  -- Move to above window
	keymap('n', '<C-l>', '<C-w>l', opts)  -- Move to right window

	-- Telescope keybindings (plugin-dependent)
	keymap('n', '<Leader>fi', '<Cmd>Telescope find_files<CR>', opts)
	keymap('n', '<Leader>fg', '<Cmd>Telescope live_grep<CR>', opts)
	keymap('n', '<Leader>fb', '<Cmd>Telescope buffers<CR>', opts)
	keymap('n', '<Leader>fh', '<Cmd>Telescope help_tags<CR>', opts)
end

return M
