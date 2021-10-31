-----------------------------------------------------------
-- Neovim settings
-----------------------------------------------------------

-----------------------------------------------------------
-- Neovim API aliases
-----------------------------------------------------------
--local map = vim.api.nvim_set_keymap  -- set global keymap
local cmd = vim.cmd     				-- execute Vim commands
local exec = vim.api.nvim_exec 	-- execute Vimscript
local fn = vim.fn       				-- call Vim functions
local g = vim.g         				-- global variables
local opt = vim.opt         		-- global/buffer/windows-scoped options
local notify = vim.notify     -- adding notifications

-----------------------------------------------------------
-- General
-----------------------------------------------------------
g.mapleader = ','             -- change leader to a comma
opt.mouse = 'a'               -- enable mouse support
opt.clipboard = 'unnamedplus' -- copy/paste to system clipboard. Using 'xclip' if it's not detected.
opt.swapfile = false          -- don't use swapfile

-----------------------------------------------------------
-- Autocompletion
-----------------------------------------------------------
opt.completeopt = 'menuone,noselect,noinsert'

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
opt.number = true             -- show line number
opt.showmatch = true          -- highlight matching parenthesis
opt.foldmethod = 'syntax'     -- enable folding (default 'foldmarker')
opt.colorcolumn = '190'       -- line lenght marker at 140 columns
opt.splitright = true         -- vertical split to the right
opt.splitbelow = true         -- horizontal split to the bottom
opt.ignorecase = true         -- ignore case letters when search
opt.smartcase = true          -- ignore lowercase for the whole pattern
opt.linebreak = true          -- wrap on word boundary
--notify = require("notify")  -- changing to notify

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.hidden = true             -- enable background buffers
opt.history = 5000            -- remember n lines in history
opt.lazyredraw = true         -- faster scrolling
opt.synmaxcol = 2400          -- max column for syntax highlight

-----------------------------------------------------------
-- Colorscheme
-----------------------------------------------------------
opt.termguicolors = true      -- enable 24-bit RGB colors
cmd [[colorscheme ayu-dark]]  -- Using Ayu as main themes

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.expandtab = true          -- use spaces instead of tabs
opt.shiftwidth = 4            -- shift 4 spaces when tab
opt.tabstop = 4               -- 1 tab == 4 spaces
opt.smartindent = true        -- autoindent new lines

-- IndentLine
g.indentLine_setColors = 0    -- set indentLine color
g.indentLine_char = '|'       -- set indentLine character

-- disable IndentLine for markdown files (avoid concealing)
cmd [[autocmd FileType markdown let g:indentLine_enabled=0]]

-----------------------------------------------------------
-- Terminal
-----------------------------------------------------------
-- open a terminal pane on the right using :Term
cmd [[command Term :botright vsplit term://$SHELL]]

-- Terminal visual tweaks
--- enter insert mode when switching to terminal
--- close terminal buffer on process exit
cmd [[
    autocmd TermOpen * setlocal listchars= nonumber norelativenumber nocursorline
    autocmd TermOpen * startinsert
    autocmd BufLeave term://* stopinsert
]]
