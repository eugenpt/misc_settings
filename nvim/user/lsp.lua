-- lsp.lua
local lspconfig = require("lspconfig")
local cmp = require("cmp")

-- Completion
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = { { name = "nvim_lsp" } },
})

-- Python LSP (pyright)
lspconfig.pyright.setup({
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

require("lspconfig").html.setup({
  -- Optional: adjust settings if needed
  --
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  -- {ukk
})


require("lspconfig").ts_ls.setup({
  -- Optional: adjust settings if needed
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})
require("lspconfig").cssls.setup({
  -- Optional: custom settings for CSS
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})



