-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Lua functions used by many plugins
  "nvim-lua/plenary.nvim",

  -- Colorscheme
  "Mofiqul/vscode.nvim",

  -- Essential plugins
  "tpope/vim-surround",
  "vim-scripts/ReplaceWithRegister",
  "numToStr/Comment.nvim",

  -- File explorer
  "nvim-tree/nvim-tree.lua",

  -- VSCode-like icons
  "kyazdani42/nvim-web-devicons",

  -- Statusline
  "nvim-lualine/lualine.nvim",

  -- Fuzzy finder
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  "nvim-telescope/telescope.nvim",

  -- Autocompletion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",

  -- Snippets
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",

  -- LSP
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  "hrsh7th/cmp-nvim-lsp",
  { "glepnir/lspsaga.nvim", branch = "main" },
  "onsails/lspkind.nvim",

  -- Formatting
  "stevearc/conform.nvim",

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
  },

  -- Auto-closing
  "windwp/nvim-autopairs",
  { "windwp/nvim-ts-autotag", dependencies = { "nvim-treesitter/nvim-treesitter" } },

  -- TODO comment highlighting
  "travisvroman/todo-comments.nvim",

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- DAP
  "mfussenegger/nvim-dap",
  "jay-babu/mason-nvim-dap.nvim",
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  },
})
