-- ~/.config/nvim/lua/ftplugins/terraform.lua

-- Create an autocommand group for Terraform configurations
vim.api.nvim_create_augroup("TerraformConfig", { clear = true })

-- Set commentstring for Terraform files
vim.api.nvim_create_autocmd("FileType", {
	group = "TerraformConfig",
	pattern = { "terraform", "terraform-vars" },
	callback = function()
		vim.opt_local.commentstring = "# %s"
	end,
})