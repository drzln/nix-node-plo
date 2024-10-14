local M = {}
function M.setup()
	require("bufferline").setup {
		highlights = {
			fill = {
				bg = "#2E3440",
			},
			background = {
				bg = "#2E3440",
			},
			tab = {
				bg = "#2E3440",
			},
			tab_selected = {
				bg = "#2E3440",
				fg = "#2E3440",
			},
			tab_close = {
				bg = "#2E3440",
			},
			close_button = {
				bg = "#2E3440",
			},
			close_button_selected = {
				bg = "#2E3440",
			},
			buffer_visible = {
				bg = "#2E3440",
			},
			buffer_selected = {
				bg = "#2E3440",
				fg = "#2E3440",
				bold = true,
			},
		},
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
