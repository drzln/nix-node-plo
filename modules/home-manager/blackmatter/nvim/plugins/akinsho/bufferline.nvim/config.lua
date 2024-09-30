local M = {}
function M.setup()
	require("bufferline").setup {
		options = {
			numbers = "buffer_id",
			diagnostics = "nvim_lsp",
			separator_style = "slant",
			show_buffer_close_icons = true,
			show_close_icon = true,
			enforce_regular_tabs = false,
			always_show_bufferline = true,
			offsets = { {
				filetype = "NvimTree",
				text = "File Explorer",
				text_align = "left",
			} },
		}
	}
end

return M
