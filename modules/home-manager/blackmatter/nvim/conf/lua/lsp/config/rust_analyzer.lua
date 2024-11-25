local M = {}

function M.setup(opts)
	local lspconfig = require("lspconfig")

	local rust_analyzer_opts = vim.tbl_extend("force", {
		rustfmt = {
			enableRangeFormatting = true,
			extraArgs = {},
		},
	}, opts)

	lspconfig.rust_analyzer.setup(rust_analyzer_opts)
end

return M
