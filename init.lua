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
