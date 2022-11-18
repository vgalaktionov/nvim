-- disable netrw, we will use alternative tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- colors
vim.opt.termguicolors = true

-- line numbers
vim.opt.number = true

-- mouse support
vim.opt.mouse = 'a'

-- clipboard
vim.opt.clipboard = 'unnamedplus'

-- sane search case
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- hide previous search result
vim.opt.hlsearch = false

-- word wrap
vim.opt.wrap = true
vim.opt.breakindent = true

-- reasonable tabs
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- always write
vim.opt.autowriteall = true

-- keybinds
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>g', '<cmd>Neogit<cr>')
vim.keymap.set('n', 'd', '"dd', { remap = false })
vim.keymap.set('n', 'D', '"dD', { remap = false })
vim.keymap.set('n', 'dd', '"ddd', { remap = false })
vim.keymap.set('n', 'x', '"_x', { remap = false })
vim.keymap.set('n', '<leader>p', '"dp', { remap = false })
vim.keymap.set('n', '<leader>P', '"dP', { remap = false })

-- packages (auto bootstrap)

require 'plugins'

-- modern save behavior
require('nvim-lastplace').setup {}

-- better ui
require("dressing").setup()

require('nvim-cursorline').setup {
    cursorline = {
        enable = true,
        timeout = 1000,
        number = false,
    },
    cursorword = {
        enable = true,
        min_length = 3,
        hl = { underline = true },
    }
}

local wilder = require("wilder")
wilder.setup({ modes = { ':', '/', '?' } })
wilder.set_option('renderer', wilder.popupmenu_renderer(
    wilder.popupmenu_border_theme({
        highlighter = wilder.basic_highlighter(),
        min_width = '100%', -- minimum height of the popupmenu, can also be a number
        min_height = '5%', -- to set a fixed height, set max_height to the same value
        reverse = 0, -- if 1, shows the candidates from bottom to top
        left = { ' ', wilder.popupmenu_devicons() },
        right = { ' ', wilder.popupmenu_scrollbar() },
    })
))

vim.cmd [[
    augroup ScrollbarInit
        autocmd!
        autocmd WinScrolled,VimResized,QuitPre * silent! lua require('scrollbar').show()
        autocmd WinEnter,FocusGained           * silent! lua require('scrollbar').show()
        autocmd WinLeave,BufLeave,BufWinLeave,FocusLost            * silent! lua require('scrollbar').clear()
    augroup end
]]


-- fast movement
require("leap").setup {}
require("leap").add_default_mappings()

-- session support
require('session_manager').setup {}

-- theme
vim.g.nord_italic = false
vim.g.nord_disable_background = true

require('nord').set()
vim.cmd 'colorscheme nord'

-- css colors
require("colorizer").setup()

-- headlines
require("headlines").setup({
    markdown = {
        headline_highlights = {
            "Headline1",
            "Headline2",
            "Headline3",
            "Headline4",
            "Headline5",
            "Headline6",
        },
        codeblock_highlight = "CodeBlock",
        dash_highlight = "Dash",
        quote_highlight = "Quote",
        fat_headlines = false
    },
})


-- better syntax highlighting
require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
    ensure_installed = "all",

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    highlight = {
        -- `false` will disable the whole extension
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        -- disable = { "c", "rust" },
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        -- disable = function(lang, buf)
        --     local max_filesize = 100 * 1024 -- 100 KB
        --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        --     if ok and stats and stats.size > max_filesize then
        --         return true
        --     end
        -- end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
}

-- auto close pairs
require("nvim-autopairs").setup()

-- comment
require('nvim_comment').setup()

-- tree
require('nvim-tree').setup {
    open_on_setup = true,
    update_focused_file = {
        enable = true,
        update_root = true
    }
}

-- statusline
require('lualine').setup {
    options = {
        theme = 'nord', -- lualine theme
        component_separators = '',
        section_separators = '',
        disabled_filetypes = { 'packer', 'NvimTree' }
    }
}

-- git integration
require('neogit').setup {
    kind = "tab",
    disable_commit_confirmation = true,
    disable_insert_on_commit = false,
    integrations = {
        diffview = true
    }
}
require("gitsigns").setup()
require('git-conflict').setup()

-- tabs
require('bufferline').setup()

local nvim_tree_events = require('nvim-tree.events')
local bufferline_api = require('bufferline.api')

local function get_tree_size()
    return require 'nvim-tree.view'.View.width
end

nvim_tree_events.subscribe('TreeOpen', function()
    bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe('Resize', function()
    bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe('TreeClose', function()
    bufferline_api.set_offset(0)
end)

-- lsp and completion
-- Mason
require("mason").setup()
require("mason-lspconfig").setup {
    automatic_installation = true
}
-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lspconfig = require('lspconfig')

lspconfig.sumneko_lua.setup {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
        capabilities = capabilities
    },
    on_attach = on_attach
}
lspconfig.pyright.setup {
    on_attach = on_attach,
    settings = {
        capabilities = capabilities
    }
}
lspconfig.tsserver.setup {
    on_attach = on_attach,
    settings = {
        capabilities = capabilities
    }

}
lspconfig.gopls.setup {
    on_attach = on_attach,
    settings = {
        capabilities = capabilities
    }

}
lspconfig.marksman.setup {
    on_attach = on_attach,
    settings = {
        capabilities = capabilities
    }
}
lspconfig.bashls.setup {
    on_attach = on_attach,
    settings = {
        capabilities = capabilities
    }
}
lspconfig.html.setup {
    on_attach = on_attach,
    settings = {
        capabilities = capabilities
    }
}
lspconfig.cssls.setup {
    on_attach = on_attach,
    settings = {
        capabilities = capabilities
    }
}
lspconfig.yamlls.setup {
    on_attach = on_attach,
    settings = {
        capabilities = capabilities
    }
}
lspconfig.jsonls.setup {
    on_attach = on_attach,
    settings = {
        capabilities = capabilities
    }
}
lspconfig.dockerls.setup {
    on_attach = on_attach,
    settings = {
        capabilities = capabilities
    }
}
lspconfig.clangd.setup {
    on_attach = on_attach,
    settings = {
        capabilities = capabilities
    }
}
lspconfig.rust_analyzer.setup {
    on_attach = on_attach,
    -- Server-specific settings...
    settings = {
        capabilities = capabilities,
        ["rust-analyzer"] = {}
    }
}


-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
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
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
}

-- telescope setup
require('telescope').setup()
require('telescope').load_extension('fzf')
require("cheatsheet").setup({})
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- custom commands
vim.api.nvim_create_user_command('EditConfig', 'edit $MYVIMRC', {})
vim.api.nvim_create_user_command('ReloadConfig', 'source $MYVIMRC', {})
vim.api.nvim_create_user_command('EditPlugins', 'exe "edit" stdpath("config") . "/lua/plugins.lua"', {})

-- format on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    command = [[%s/\s\+$//e]],
})
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    command = [[lua vim.lsp.buf.formatting_sync()]],
})
