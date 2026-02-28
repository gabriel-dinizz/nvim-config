-- Bootstrap Packer automatically
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Auto-recompile when this file is saved
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

local status, packer = pcall(require, "packer")
if not status then
  return
end

return packer.startup(function(use)
  -- Plugin manager
  use("wbthomason/packer.nvim")

  -- Lua functions used by many plugins
  use("nvim-lua/plenary.nvim")

  -- Colorscheme
  use("travisvroman/adwaita.nvim")

  -- Essential plugins
  use("tpope/vim-surround")
  use("vim-scripts/ReplaceWithRegister")
  use("numToStr/Comment.nvim")

  -- File explorer
  use("nvim-tree/nvim-tree.lua")

  -- VSCode-like icons
  use("kyazdani42/nvim-web-devicons")

  -- Statusline
  use("nvim-lualine/lualine.nvim")

  -- Fuzzy finder
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
  use({ "nvim-telescope/telescope.nvim" })

  -- Autocompletion
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")

  -- Snippets (required by nvim-cmp)
  use("L3MON4D3/LuaSnip")
  use("saadparwaiz1/cmp_luasnip")
  use("rafamadriz/friendly-snippets")

  -- Managing & configuring LSP servers
  use("williamboman/mason.nvim")
  use("williamboman/mason-lspconfig.nvim")
  use("neovim/nvim-lspconfig")
  use("hrsh7th/cmp-nvim-lsp")
  use({ "glepnir/lspsaga.nvim", branch = "main" })
  use("onsails/lspkind.nvim")

  -- Formatting & linting
  use("stevearc/conform.nvim")

  -- Treesitter (syntax highlighting)
  use({
    "nvim-treesitter/nvim-treesitter",
    run = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
  })

  -- Auto-closing
  use("windwp/nvim-autopairs")
  use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" })

  -- TODO comment highlighting
  use("travisvroman/todo-comments.nvim")

  -- Visual debugger
  use("mfussenegger/nvim-dap")
  use("jay-babu/mason-nvim-dap.nvim")
  use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } })

  if packer_bootstrap then
    require("packer").sync()
  end
end)
