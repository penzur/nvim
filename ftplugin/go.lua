vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = true

vim.keymap.set("n", "<C-x>", ":!go run .<cr>")

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		-- Organize imports (only if LSP is ready)
		if vim.lsp.get_clients({ bufnr = 0 })[1] then
			local params = vim.lsp.util.make_range_params(0, "utf-16")
			params.context = { only = { "source.organizeImports" } }

			-- Call organizeImports synchronously
			local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
			for _, res in pairs(result or {}) do
				for _, r in pairs(res.result or {}) do
					vim.lsp.util.apply_workspace_edit(r.edit, "utf-16")
				end
			end
		end
		vim.lsp.buf.format({ async = false })
	end,
})
