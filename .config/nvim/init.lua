-- --- 1. CORE SETTINGS ---
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.cursorline = true

-- --- 3. PLUGIN MANAGER (LAZY.NVIM) ---
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

require("lazy").setup({
  { "rebelot/kanagawa.nvim" }, 
  { "nvim-tree/nvim-tree.lua", config = function() require("nvim-tree").setup() end },
  { "neovim/nvim-lspconfig" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "hrsh7th/nvim-cmp" },      -- The completion engine
  { "hrsh7th/cmp-nvim-lsp" },  -- Connects LSP to completion engine
  { "L3MON4D3/LuaSnip" },      -- Snippet engine
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } }
})



-- --- FORCE TRUE BLACK BACKGROUND ---
local function black_out()
    local highlights = {
        "Normal", "NormalFloat", "NvimTreeNormal", "NvimTreeNormalNC",
        "SignColumn", "StatusLine", "StatusLineNC", "EndOfBuffer"
    }
    for _, group in ipairs(highlights) do
        vim.api.nvim_set_hl(0, group, { bg = "#000000" })
    end
end

-- Run it immediately and whenever the colorscheme changes
black_out()
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function() black_out() end,
})

-- 1. Inactive line numbers (Deep Blood/Dark Red)
vim.api.nvim_set_hl(0, "LineNr", { fg = "#5f0000", bg = "#000000" })

-- 2. Active line number (Bright Crimson - The number you are actually on)
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#DC143C", bg = "#000000", bold = true })

-- 3. The horizontal line highlight (The "foreground" where you are)
-- We set bg to #0a0000 (a very faint red tint) so it doesn't look gray
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#0a0000" })

-- 4. If you want the text itself on the current line to stay white/normal
-- instead of turning gray, we ensure the foreground isn't touched
vim.opt.cursorlineopt = "number" -- This only highlights the NUMBER, not the whole line

-- --- BERSERK CODE HIGHLIGHTS ---

-- Functions: Pure White (The Action)
vim.api.nvim_set_hl(0, "@function", { fg = "#FFFFFF", bold = true })

-- Keywords: Crimson (if, return, import, class)
vim.api.nvim_set_hl(0, "@keyword", { fg = "#DC143C", bold = true, italic = true })
vim.api.nvim_set_hl(0, "@keyword.return", { fg = "#DC143C", bold = true })

-- Strings: Deep Red (Text/Data)
vim.api.nvim_set_hl(0, "@string", { fg = "#990000" })

-- Numbers/Booleans: Amber/Gold (Constants)
vim.api.nvim_set_hl(0, "@number", { fg = "#FF8800" })
vim.api.nvim_set_hl(0, "@boolean", { fg = "#FF8800" })

-- Comments: Dark Gray (Subtle)
vim.api.nvim_set_hl(0, "Comment", { fg = "#545454", italic = true })

-- --- 4. LSP & INTELLISENSE (Modern 0.11 Style) ---

-- Enable the servers (This uses the configs from nvim-lspconfig automatically)
-- Make sure these are installed via ':Mason' or 'dnf'
local servers = { 'pyright', 'vtsls', 'jsonls', 'yamlls' }
for _, server in ipairs(servers) do
    vim.lsp.enable(server)
end

-- Setup Auto-Completion (The VS Code dropdown menu)
local cmp = require('cmp')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

cmp.setup({
  snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

-- --- 5. KEYMAPPINGS ---
local map = vim.keymap.set
map('n', '<leader>e', ':NvimTreeToggle<CR>')        -- Toggle Sidebar
map('n', '<leader>ff', ':Telescope find_files<CR>') -- Ctrl+P equivalent
map('n', 'gd', vim.lsp.buf.definition)              -- Go to definition
map('n', 'K', vim.lsp.buf.hover)                    -- Hover doc
map('n', '<leader>rn', vim.lsp.buf.rename)          -- Rename variable

-- 1. Show the error in a floating window (Space + d)
map('n', '<leader>d', vim.diagnostic.open_float)
-- 2. Jump to the next error ( ] + d )
map('n', ']d', vim.diagnostic.goto_next)
-- 3. Jump to the previous error ( [ + d )
map('n', '[d', vim.diagnostic.goto_prev)
