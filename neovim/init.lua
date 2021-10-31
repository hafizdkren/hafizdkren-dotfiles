--[[

  ██╗███╗   ██╗██╗████████╗██╗     ██╗   ██╗ █████╗
  ██║████╗  ██║██║╚══██╔══╝██║     ██║   ██║██╔══██╗
  ██║██╔██╗ ██║██║   ██║   ██║     ██║   ██║███████║
  ██║██║╚██╗██║██║   ██║   ██║     ██║   ██║██╔══██║
  ██║██║ ╚████║██║   ██║██╗███████╗╚██████╔╝██║  ██║
  ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝

Neovim init file

Version: 0.1.0 - 2021/10/17
Owner and Maintainer: Hafizdkren
Forked from: Brainf+ck
Init Lua Config: https://github.com/hafizdkren/neovim-lua-config
Fork Website: https://github.com/brainfucksec/neovim-lua

--]]

-----------------------------------------------------------
-- Import Lua user setting
-----------------------------------------------------------
require('userSetting/settings')     -- settings
require('userSetting/keymaps')      -- keymaps

-----------------------------------------------------------
-- Import Lua modules
-----------------------------------------------------------
require('Plugins/paq-nvim')         -- plugin manager
require('Plugins/packer')           -- secondary plugin manager
require('Plugins/nvim-tree')	    -- file manager
require('Plugins/feline')           -- statusline
require('Plugins/nvim-cmp')         -- autocomplete
require('Plugins/nvim-autopairs')   -- autopairs
require('Plugins/nvim-lspconfig')   -- LSP settings
require('Plugins/vista')            -- tag viewer
require('Plugins/nvim-treesitter')  -- tree-sitter interface
require('Plugins/gitsigns')         -- git decorations
require('Plugins/indentBlankline')  -- another indent helper
require('Plugins/discordPresence')  -- Discord Presence
