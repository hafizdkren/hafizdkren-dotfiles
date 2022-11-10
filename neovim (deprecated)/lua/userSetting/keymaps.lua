-----------------------------------------------------------
-- Keymaps configuration file: keymaps of neovim
-- and plugins.
-----------------------------------------------------------

local map = vim.api.nvim_set_keymap
local default_opts = {noremap = true, silent = true}
local cmd = vim.cmd

-----------------------------------------------------------
-- Neovim shortcuts:
-----------------------------------------------------------

-- clear search highlighting
map('n', '<leader>c', ':nohl<CR>', default_opts)

-- fast saving with <leader> and s
map('n', '<leader>s', ':w<CR>', default_opts)
map('i', '<leader>s', '<C-c>:w<CR>', default_opts)

-- mapping arrow key with right configuration
--map('n', '<h>', '<Left>', default_opts)
--map('n', '<j>', '<Up>', default_opts)
--map('n', '<k>', '<Down>', default_opts)
--map('n', '<l>', '<Right>', default_opts)

-- mapping window move keybind
map('n', '<A-h>', '<C-W>H', default_opts)
map('n', '<A-j>', '<C-W>J', default_opts)
map('n', '<A-k>', '<C-W>K', default_opts)
map('n', '<A-l>', '<C-W>L', default_opts)

-- mapping window move cursor
map('i', '<C-h>', '<Left>', default_opts)
map('i', '<C-j>', '<Down>', default_opts)
map('i', '<C-k>', '<Up>', default_opts)
map('i', '<C-l>', '<Right>', default_opts)

-- move around splits using Ctrl + {h,j,k,l}
map('n', '<C-h>', '<C-w>h', default_opts)
map('n', '<C-j>', '<C-w>j', default_opts)
map('n', '<C-k>', '<C-w>k', default_opts)
map('n', '<C-l>', '<C-w>l', default_opts)

-- close all windows and exit from neovim
map('n', '<leader>q', ':quitall<CR>', default_opts)

-- resizing window
map('n', '<leader>=', ':vertical resize +10<CR>', default_opts)
map('n', '<leader>+', ':vertical resize +5<CR>', default_opts)
map('n', '<leader>-', ':vertical resize -10<CR>', default_opts)
map('n', '<leader>_', ':vertical resize -5<CR>', default_opts)

-----------------------------------------------------------
-- Applications & Plugins shortcuts:
-----------------------------------------------------------
-- open terminal
map('n', '<C-t>', ':Term<CR>', {noremap = true})

-- nvim-tree
map('n', '<C-n>', ':NvimTreeToggle<CR>', default_opts)       -- open/close
map('n', '<leader>r', ':NvimTreeRefresh<CR>', default_opts)  -- refresh
map('n', '<leader>n', ':NvimTreeFindFile<CR>', default_opts) -- search file

-- Vista tag-viewer
map('n', '<C-m>', ':Vista!!<CR>', default_opts)   -- open/close
