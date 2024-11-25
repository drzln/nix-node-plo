local M = {}

function M.setup(opts)
	local lspconfig = require("lspconfig")

	-- Override bashls
	local rust_analyzer_opts = vim.tbl_extend("force", {
		-- on_attach = function(client, bufnr)
		-- 	-- Enable formatting on save
		-- 	-- if client.server_capabilities.documentFormattingProvider then
		-- 	-- 	vim.api.nvim_create_autocmd("BufWritePre", {
		-- 	-- 		group = vim.api.nvim_create_augroup("Format", { clear = true }),
		-- 	-- 		buffer = bufnr,
		-- 	-- 		callback = function()
		-- 	-- 			vim.lsp.buf.format({ async = false })
		-- 	-- 		end,
		-- 	-- 	})
		-- 	-- end
		-- end,
		settings = {
			["rust-analyzer"] = {
				diagnostics = {
					disabled = { "unresolved-proc-macro" }
				},
				rustfmt = {
					extraArgs = {},
				},
			}
		}
	}, opts)

	-- Enable rust_analyzer
	lspconfig.rust_analyzer.setup(rust_analyzer_opts)
end

return M
