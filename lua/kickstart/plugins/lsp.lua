return {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
		-- "williamboman/mason-lspconfig.nvim",
		{ "mason-org/mason.nvim" },
		{ "mason-org/mason-lspconfig.nvim" },
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				-- NOTE: Remember that Lua is a real programming language, and as such it is possible
				-- to define small helper and utility functions so you don't have to repeat yourself.
				--
				-- In this case, we create a function that lets us more easily define mappings specific
				-- for LSP related items. It sets the mode, buffer and description for us each time.
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				local offset_encoding = client and client.offset_encoding or "utf-16"

				map("gd", function()
					require("telescope.builtin").lsp_definitions({ offset_encoding = offset_encoding })
				end, "[G]oto [D]efinition")

				map("gr", function()
					require("telescope.builtin").lsp_references({ offset_encoding = offset_encoding })
				end, "[G]oto [R]eferences")

				map("gi", function()
					require("telescope.builtin").lsp_implementations({ offset_encoding = offset_encoding })
				end, "[G]oto [I]mplementation")

				map("<leader>D", function()
					require("telescope.builtin").lsp_type_definitions({ offset_encoding = offset_encoding })
				end, "Type [D]efinition")

				map("<leader>ds", function()
					require("telescope.builtin").lsp_document_symbols({ offset_encoding = offset_encoding })
				end, "[D]ocument [S]ymbols")

				map("<leader>ws", function()
					require("telescope.builtin").lsp_dynamic_workspace_symbols({ offset_encoding = offset_encoding })
				end, "[W]orkspace [S]ymbols")

				map("<leader>rn", ":IncRename ", "[R]e[n]ame")

				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		local servers = {
			clangd = {},
			gopls = {},
			rust_analyzer = {},
			eslint = {
				settings = {
					experimental = {
						useFlatConfig = false, -- Set to true if using eslint.config.js (flat config)
					},
				},
			},
			-- ts_ls = {},
			vtsls = {
				filetypes = {
					"typescript",
					"typescriptreact",
					"javascript",
					"javascriptreact",
				},
			},

			-- vue_ls = {
			--     on_init = function(client)
			--         client.handlers["workspace/executeCommand"] = function() end
			--     end,
			--     settings = {
			--         vue = {
			--             hybridMode = false, -- IMPORTANT when using vtsls
			--         },
			--     },
			--     init_options = {
			--         typescript = {
			--             tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
			--         },
			--     },
			-- },

			lua_ls = {
				-- cmd = {...},
				-- filetypes = { ...},
				-- capabilities = {},
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			},

			emmet_ls = {
				filetypes = {
					"css",
					"eruby",
					"html",
					"javascriptreact",
					"less",
					"sass",
					"scss",
					"svelte",
					"pug",
					"typescriptreact",
				},
				init_options = {
					html = {
						options = {
							-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
							["bem.enabled"] = true,
						},
					},
				},
			},
		}

		require("mason").setup()

		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, { "prettierd", "eslint_d", "stylua" })
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(servers or {}),
			automatic_installation = true,
			handlers = {
				-- Default handler
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,

				-- Ensure vtsls is registered BEFORE vue_ls
				["vtsls"] = function()
					local server = servers.vtsls or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig").vtsls.setup(server)
				end,

				["vue_ls"] = function()
					local server = servers.vue_ls or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})

					server.init_options = vim.tbl_deep_extend("force", server.init_options or {}, {
						typescript = {
							tsdk = vim.fn.stdpath("data")
								.. "/mason/packages/typescript-language-server/node_modules/typescript/lib",
						},
					})

					require("lspconfig").vue_ls.setup(server)
				end,
			},
		})
	end,
}
