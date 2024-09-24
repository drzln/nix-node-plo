local M = {}

function M.setup()
  -- by default make gitblame on line off
  vim.cmd [[ let g:gitblame_enabled = 0 ]]

  -- recognize prisma files
  vim.cmd([[ au BufNewFile,BufRead *.prisma set filetype=prisma ]])

  local utils = require('utils')

  -- find everything in this directory
  -- and run its setup hook.
  utils.load_files('~/.config/nvim/lua/plugins/config')

  -- load language server configurations
  require("lsp").setup()

  -- load all language specific configs
  -- utils.load_files('~/.config/nvim/lua/config/langs')

  -- load testing configurations
  -- utils.load_files('~/.config/nvim/lua/config/testing')
end

return M
