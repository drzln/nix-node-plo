local M = {}

function M.setup(opts)
	local lspconfig = require("lspconfig")

	local rust_analyzer_opts = vim.tbl_extend("force", {
		on_attach = function(client, _)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end,
		settings = {
			["rust-analyzer"] = {
				diagnostics = {
					disabled = { "unresolved-proc-macro" }
				},
			}
		}
	}, opts)

	lspconfig.rust_analyzer.setup(rust_analyzer_opts)
end

return M
