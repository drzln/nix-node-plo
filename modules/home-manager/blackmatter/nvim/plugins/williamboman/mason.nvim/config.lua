local M = {}
function M.setup()
  local mason = require("mason")
  local mason_lspconfig = require("mason-lspconfig")

  mason.setup()

  local available_servers = mason_lspconfig.get_available_servers()

  mason_lspconfig.setup(
    {
      ensure_installed = available_servers,
      automatic_installation = true
    }
  )

  local lspconfig = require("lspconfig")

  for _, server in ipairs(available_servers) do
      lspconfig[server].setup {}
  end
end

return M
