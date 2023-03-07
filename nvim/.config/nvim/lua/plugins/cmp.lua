return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"David-Kunz/cmp-npm",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lua",
		"f3fora/cmp-spell",
	},
	config = function()
		local status, cmp = pcall(require, "cmp")
		if (not status) then return end


		local status2, lspkind = pcall(require, "lspkind")
		if (not status2) then return end

		local status3, npm = pcall(require, "cmp-npm")
		if (not status3) then return end

		npm.setup({})

		local status4, luasnip = pcall(require, "luasnip")

		if (not status4) then return end

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		function getAllData(t, prevData)
			-- if prevData == nil, start empty, otherwise start with prevData
			local data = prevData or {}

			-- copy all the attributes from t
			for k, v in pairs(t) do
				data[k] = data[k] or v
			end

			-- get t's metatable, or exit if not existing
			local mt = getmetatable(t)
			if type(mt) ~= 'table' then return data end

			-- get the __index from mt, or exit if not table
			local index = mt.__index
			if type(index) ~= 'table' then return data end

			-- include the data from index into data, recursively, and return
			return getAllData(index, data)
		end

		cmp.setup({
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
					['<C-d>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
					['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.close(),
					["<C-n>"] = cmp.mapping(function(fallback)
					-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
					-- they way you will only jump inside the snippet region
					if luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
					["<C-p>"] = cmp.mapping(function(fallback)
					-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
					-- they way you will only jump inside the snippet region
					if luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
					['<Tab>'] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true
				}),
			}),
			sources = cmp.config.sources({
				{
					name = "nvim_lsp",
					entry_filter = function(entry, ctx)
						-- print(entry)
						-- for i, v in ipairs(entry) do print(v) end
						print(getAllData(entry))





						return true
					end
				},
				{ name = 'luasnip' },
				{ name = 'buffer' },
				{ name = 'npm' },
				{ name = 'nvim_lua' },
				{
					name = 'spell',
					option = {
						keep_all_entries = false,
						enable_in_context = function()
							return require('cmp.config.context').in_treesitter_capture('spell')
						end,
					},
				},
				{ name = 'path' },
			}),
			formatting = {
				format = lspkind.cmp_format({
					with_text = false,
					menu = {
						buffer = "[buf]",
						nvim_lsp = "[LSP]",
						spell = "[spell]",
						nvim_lua = "[vim]",
						path = "[path]",
						luasnip = "[snip]",
					}
				})
			},
			experimental = {
				native_menu = false,
				ghost_text = true,
			}
		})

		vim.cmd [[
  set completeopt=menuone,noinsert,noselect
  highlight! default link CmpItemKind CmpItemMenuDefault
]]
	end
}
