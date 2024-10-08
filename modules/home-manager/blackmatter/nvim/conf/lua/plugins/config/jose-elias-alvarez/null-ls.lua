local M = {}

function M.setup()
  local nls = require("null-ls")

  local nlssources = {
    nls.builtins.formatting.phpcsfixer.with({
      command = "php-cs-fixer",
    }),
    nls.builtins.formatting.black,
    nls.builtins.formatting.prettier,
    nls.builtins.formatting.prettier.with({
      filetypes = { "xml", "html", "xhtml", "js", "tsx", "json", "yaml", "yml" },
    }),
    -- commenting out rubocop so solargraph can take over
    -- nls.builtins.formatting.rubocop,
    nls.builtins.code_actions.gitsigns,
    nls.builtins.code_actions.eslint_d,
    nls.builtins.code_actions.gitrebase,
    nls.builtins.code_actions.refactoring,
    nls.builtins.formatting.terraform_fmt.with({
      filetypes = { "terraform", "tf", "hcl" },
    }),
    -- nls.builtins.diagnostics.shellcheck.with({
    -- 	extra_args = { "--format=json" },
    -- 	diagnostics_format = "#{message}",
    -- }),
    nls.builtins.formatting.shfmt.with({
      extra_args = { "-i", "2", "-sr" },
    }),
  }
  nls.setup({
    sources = nlssources,
    on_attach = function(client, _)
      if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_command [[augroup Format]]
        vim.api.nvim_command [[autocmd! * <buffer>]]
        vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
        vim.api.nvim_command [[augroup END]]
      end
    end,
  })
end

return M
