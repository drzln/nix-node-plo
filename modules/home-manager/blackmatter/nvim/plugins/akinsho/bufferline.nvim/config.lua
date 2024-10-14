local M = {}
function M.setup()
	require("bufferline").setup {
		highlights = {
			fill = {
				bg = "#81A1C1",
			},
			background = {
				bg = "#81A1C1",
			},
			tab = {
				bg = "#81A1C1",
			},
			tab_selected = {
				fg = "#ECEFF4",
				bg = "#5E81AC",
			},
			tab_close = {
				bg = "#81A1C1",
			},
			close_button = {
				bg = "#81A1C1",
			},
			close_button_selected = {
				bg = "#5E81AC",
			},
			buffer_visible = {
				bg = "#81A1C1",
			},
			buffer_selected = {
				fg = "#ECEFF4",
				bg = "#5E81AC",
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
