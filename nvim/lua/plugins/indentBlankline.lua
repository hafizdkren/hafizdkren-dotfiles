-- This plugins is adding from Brainfck nvim config just to make me understand the tabbing location.
-- If you don't like it, just disable the plugins from plugins.lua or delete this file.

local status_ok, indent_blankline = pcall(require, 'indent_blankline')
if not status_ok then
  return
end

-----------------------------------------------------------
-- Neovim API aliases
-----------------------------------------------------------
--local map = vim.api.nvim_set_keymap  -- set global keymap
local cmd = vim.cmd     				-- execute Vim commands
local opt = vim.opt         		-- global/buffer/windows-scoped options

cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

--opt.listchars:append("space: ") --using this if want to not had dot on tabs

opt.list = true
opt.listchars:append("space:⋅")
opt.listchars:append("eol:↴")

require("indent_blankline").setup {
    char = "|",
    buftype_exclude = {"terminal"},
    space_char_blankline = " ",
    char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
        "IndentBlanklineIndent6",
    },
	  use_treesitter = true,
	  show_first_indent_level = false,
  	filetype_exclude = {
    	'lspinfo',
    	'packer',
    	'checkhealth',
    	'help',
    	'man',
    	'dashboard',
    	'git',
    	'markdown',
    	'text',
    	'terminal',
    	'NvimTree',
  	},
  	buftype_exclude = {
  	  'terminal',
  	  'nofile',
  	  'quickfix',
  	  'prompt',
  	},

}
