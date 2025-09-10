-- leader must be first
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- add lazy.nvim to runtime
vim.opt.rtp:prepend("~/.local/share/nvim/lazy/lazy.nvim")

-- ================= Plugins =================
require("lazy").setup({
    -- LSP
    { "neovim/nvim-lspconfig" },

    -- Treesitter
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "VeryLazy",
        keys = {
            { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
            { "<leader>fg", function() require("telescope.builtin").live_grep() end,  desc = "Live grep" },
            { "<leader>fb", function() require("telescope.builtin").buffers() end,    desc = "Buffers" },
            { "<leader>fh", function() require("telescope.builtin").help_tags() end,  desc = "Help tags" },
        },
        config = function()
            require("telescope").setup({})
        end,
    },

    -- Autocomplete core + sources
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            -- for :cmdline completion:
            "hrsh7th/cmp-cmdline",
        },
    },

    -- File tree
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup()
            vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { silent = true, desc = "File tree" })
        end,
    },

    -- GitHub Copilot
    {
        "github/copilot.vim",
        event = "InsertEnter", -- load when entering insert mode
    },
})

-- ================= Treesitter =================
require("nvim-treesitter.configs").setup({
    ensure_installed = { "lua", "python", "javascript", "java", "c" },
    highlight = { enable = true },
})

-- ================= LSP =================
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
for _, server in ipairs({ "pyright", "ts_ls", "lua_ls" }) do
    lspconfig[server].setup({ capabilities = capabilities })
end

-- ================= nvim-cmp (insert-mode completion) =================
local cmp = require("cmp")
cmp.setup({
    snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
    mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"]      = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
    }),
})

-- === nvim-cmp for command-line ===
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
})
cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = "buffer" } },
})

-- ================= General opts =================
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
