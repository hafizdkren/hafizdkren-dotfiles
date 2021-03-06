-----------------------------------------------------------
-- Plugin manager configuration file
-----------------------------------------------------------

-- Plugin manager: paq-nvim
-- https://github.com/savq/paq-nvim

vim.cmd 'packadd paq-nvim'            -- load paq
local paq = require('paq-nvim').paq   -- import module with `paq` function
paq{'savq/paq-nvim', opt=true}     -- Let Paq manage itself

-- Add packages
-- for package info see: init.lua (Lua modules)
require('paq') {
  'savq/paq-nvim';  -- let paq manage itself

  'famiu/feline.nvim';                  --statusline
  'kyazdani42/nvim-web-devicons';       --icon
  'kyazdani42/nvim-tree.lua';           --file manager
  'lukas-reineke/indent-blankline.nvim';
  'Yggdroot/indentLine';                
  'liuchengxu/vista.vim';
  'nvim-treesitter/nvim-treesitter';
  'neovim/nvim-lspconfig';
  'hrsh7th/nvim-cmp';
  'hrsh7th/cmp-nvim-lsp';
  'hrsh7th/cmp-path';
  'hrsh7th/cmp-buffer';
  'saadparwaiz1/cmp_luasnip';
  'L3MON4D3/LuaSnip';
  'windwp/nvim-autopairs';
  'tanvirtin/monokai.nvim';
  'nvim-lua/plenary.nvim';
  'lewis6991/gitsigns.nvim';
  'andweeb/presence.nvim';
  'wakatime/vim-wakatime';
  'nvim-telescope/telescope.nvim';
  'ibhagwan/fzf-lua';
  'Shatur/neovim-ayu';
  'ajmwagar/vim-deus';
  'lervag/vimtex';
  'tzachar/cmp-tabnine';
}

