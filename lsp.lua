-- Setup nvim-cmp for autocompletion
local cmp = require('cmp')
local luasnip = require('luasnip')
local compare = require('cmp.config.compare')
local types = require('cmp.types')

-- Keep track of seen completion items to prevent duplicates
local seen_entries = {}
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = {
        { name = 'nvim_lsp', priority = 1000 },
        { name = 'luasnip',  priority = 750 },
        { name = 'buffer',   priority = 500 },
        { name = 'path',     priority = 250 },
    },
    
    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snip]",
                buffer = "[Buf]",
                path = "[Path]",
            })[entry.source.name]
            return vim_item
        end
    },
    
    -- Disable preselection
    preselect = cmp.PreselectMode.None,
    
    -- Use a custom filtering function to deduplicate entries
    completion = {
        completeopt = 'menu,menuone,noinsert',
    },
    
    -- This is the key part - create a custom filter that discards duplicates
    experimental = {
        ghost_text = true,
        native_menu = false,
    },
    
    -- Custom sorting to prioritize LSP and handle duplicates
    sorting = {
        priority_weight = 2,
        comparators = {            -- Custom deduplication logic
            function(entry1, entry2)
                -- If labels are identical, remove duplicates from the same source
                local label1, label2 = entry1.completion_item.label, entry2.completion_item.label
                
                if label1 == label2 then
                    local s1, s2 = entry1.source.name, entry2.source.name
                    -- If both from same source (especially nvim_lsp), keep only one
                    if s1 == s2 then
                        -- Keep entry with lower id (typically first one found)
                        return entry1.id < entry2.id
                    end
                    -- Different sources with same label - prioritize LSP
                    if s1 == "nvim_lsp" then return true end
                    if s2 == "nvim_lsp" then return false end
                end
                return nil
            end,
            -- Use the dedicated under comparator for additional deduplication
            require('cmp-under-comparator').under,
            compare.offset,
            compare.exact,
            compare.score,
            compare.recently_used,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
        },
    },
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore)
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore)
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "bashls",
        "dockerls",
        "docker_compose_language_service",
        "yamlls",
        "html",
        "jsonls",
        "marksman",
        "pyright",
        "gopls",
    },
})

-- Keybindings
local on_attach = function(_, _)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {noremap = true, silent = true})
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {noremap = true, silent = true})
    vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, {noremap = true, silent = true})
    vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, {noremap = true, silent = true})
    vim.keymap.set('n', '<leader>gr', require("telescope.builtin").lsp_references, {noremap = true, silent = true})
    vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover, {noremap = true, silent = true})
    vim.keymap.set('n', '<leader>ds', vim.lsp.buf.document_symbol, {noremap = true, silent = true})
    vim.keymap.set('n', '<leader>ws', vim.lsp.buf.workspace_symbol, {noremap = true, silent = true})
end


-- Lua: LuaLS
require("lspconfig").lua_ls.setup({
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = {
                globals = {"vim"},
            },
        },
    },
})

-- Go: gopls
require("lspconfig").gopls.setup({
    on_attach = on_attach,
    cmd = {"gopls", "serve"},
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
            completeUnimported = true, -- Auto-import packages
            usePlaceholders = true,    -- Add parameter placeholders when completing functions
        },
    },
})


-- Python: pyright
require("lspconfig").pyright.setup({
    on_attach = on_attach,
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
            },
        },
    },
})
