-- Configure the Rose-Pine theme
require("rose-pine").setup({
  variant = "moon", -- Options: "main", "moon", "dawn"
  dark_variant = "moon",
  disable_background = false,
})

-- Load your plugins configuration
require("plugins.plugins")
-- Lazy.nvim setup
require("lazy").setup("plugins.plugins")

-- Set the colorscheme
vim.cmd.colorscheme("rose-pine")
