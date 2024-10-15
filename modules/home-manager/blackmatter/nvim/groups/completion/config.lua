local M = {}

local function has_words_before()
	if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
		return false
	end
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

function M.getTextSymbolMap()
	return {
		Text = "[-]",
		Method = "[M]",
		Function = "[ƒ]",
		Constructor = "[C]",
		Field = "[.]",
		Variable = "[V]",
		Class = "[#]",
		Interface = "[I]",
		Module = "[M]",
		Property = "[P]",
		Unit = "[U]",
		Value = "[v]",
		Enum = "[E]",
		Keyword = "[K]",
		Snippet = "[S]",
		Color = "[C]",
		File = "[F]",
		Reference = "[R]",
		Folder = "[D]",
		EnumMember = "[e]",
		Constant = "[C]",
		Struct = "[S]",
		Event = "[@]",
		Operator = "[O]",
		TypeParameter = "[T]"
	}
end

local function set_lspkind_config(kind_config)
	local lspkind = require('lspkind')

	if kind_config == "text" then
		lspkind.init({
			mode = 'symbol_text',
			symbol_map = M.getTextSymbolMap(),
		})
	elseif kind_config == "codicons" then
		lspkind.init({
			mode = 'symbol_text',
			preset = 'codicons',
		})
	else
		error("Invalid kind_config value, it must be 'text' or 'codicons'")
	end

	M.setup_cmp()
end

function M.setup_cmp()
	local cmp = require("cmp")
	local luasnip = require('luasnip')
	local lspkind = require('lspkind')

	cmp.setup({
		formatting = {
			format = lspkind.cmp_format({
				mode = 'symbol_text', -- show both symbol and text
				maxwidth = 50,
				ellipsis_char = '...',
				before = function(entry, vim_item)
					local source = entry.source.name
					vim_item.menu = string.format(
						"%s (%s)",
						vim_item.menu or "",
						source
					)
					return vim_item
				end
			}),
		},
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		mapping = M.getCmpMapping(),
		sources = cmp.config.sources(M.getCmpSources())
	})
end

function M.getCmpMapping()
	local cmp = require("cmp")
	local luasnip = require('luasnip')
	return {
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		['<C-y>'] = cmp.config.disable,
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
		['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
		['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
		['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
		['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
		['<C-e>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close(), }),
	}
end

function M.getCmpSources()
	return {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'buffer' },
		{ name = 'treesitter' },
		{ name = 'path' },
		-- Add additional sources if needed
	}
end

function M.setup()
	vim.cmd [[ set completeopt=menu,menuone,noselect ]]
	local map = require("utils.map")
	set_lspkind_config("codicons")
	map('i', '<C-n>', "<cmd>lua require('cmp').complete()<CR>", {
		noremap = false, expr = false
	})
end

return M

