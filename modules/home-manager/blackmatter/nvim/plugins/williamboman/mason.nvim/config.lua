local M = {}
function M.setup()
  local mason = require("mason")
  local mason_lspconfig = require("mason-lspconfig")

  mason.setup()

  local available_servers = mason_lspconfig.get_available_servers()

  local exclude_servers = {
      -- "rubocop",
      -- "standardrb",
      -- "theme_check",
      -- "solargraph",
      "erlangls",
      "teal_ls",
      "foam_ls",
      "asm_lsp",
      "beancount",
      "salt_ls",
      "java_language_server",
      "move_analyzer",
      "r_language_server",
      "ruby_ls",
      "clarity_lsp",
      "awk_ls",
      "nimls",
      "tsserver",
      "ocamllsp",
      "csharp_ls",
      "vala_ls",
      "vuels",
      "hls",
      "als"
  }

  local function is_excluded(server)
    return vim.tbl_contains(exclude_servers, server)
  end

  local servers_to_install = vim.tbl_filter(function(server)
      return not is_excluded(server)
  end, available_servers)

  mason_lspconfig.setup(
    {
      ensure_installed = servers_to_install,
      automatic_installation = false
    }
  )


  local lspconfig = require("lspconfig")

  local server_configs = {}
  for _, server in ipairs(available_servers) do
    if not is_excluded(server) then
      local success, err = pcall(function()
          local config = server_configs[server] or {}
          lspconfig[server].setup(config)
      end)
      if not success then
        print("Error setting up " .. server .. ": " .. err)
      end
    end
  end
end

return M
