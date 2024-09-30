local M = {}
function M.setup()
	require('telescope').load_extension('projects')
	require('telescope').setup {
		extensions = {
			projects = {}
		}
	};
end

return M
