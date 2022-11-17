-- disable netrw, we will use alternative tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- syntax highlighting
vim.cmd 'syntax on'
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
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- keybinds
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>')


-- packages (auto bootstrap)
require 'plugins'

-- theme
vim.g.nord_italic = false
vim.g.nord_disable_background = true

require('nord').set()
vim.cmd 'colorscheme nord'

-- tree
require('nvim-tree').setup {
  open_on_setup = true,
  update_focused_file = {
    enable = true,
    update_root = true
  }
}

require('neogit').setup {
  disable_commit_confirmation = true,
  disable_insert_on_commit = false
}

-- lsp and completion
-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

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
        globals = {'vim'},
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

-- custom commands
vim.api.nvim_create_user_command('EditConfig', 'edit $MYVIMRC', {})
vim.api.nvim_create_user_command('ReloadConfig', 'source $MYVIMRC', {})
vim.api.nvim_create_user_command('EditPlugins', 'exe "edit" stdpath("config") . "/lua/plugins.lua"', {})
