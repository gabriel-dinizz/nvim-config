-- ============================================================================
-- COMPATIBILITY SHIMS (Neovim 0.11+)
-- ============================================================================
-- ft_to_lang was removed in Neovim 0.11 and nvim-treesitter;
-- some plugins (Telescope) still reference it via nvim-treesitter.parsers
local get_lang = vim.treesitter.language.get_lang or function(ft) return ft end

if not vim.treesitter.language.ft_to_lang then
    vim.treesitter.language.ft_to_lang = get_lang
end

-- Patch immediately in case plugins are already loaded
local ok, parsers = pcall(require, "nvim-treesitter.parsers")
if ok and not parsers.ft_to_lang then
    parsers.ft_to_lang = get_lang
end

-- ============================================================================
-- PLUGINS SETUP
-- ============================================================================
require("plugins-setup")

-- ============================================================================
-- VIM OPTIONS
-- ============================================================================
local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Line wrapping
opt.wrap = false

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard (use system clipboard)
opt.clipboard:append("unnamedplus")

-- Split windows
opt.splitright = true
opt.splitbelow = true

-- Colorscheme
vim.o.background = "dark"
local vscode_ok, vscode = pcall(require, "vscode")
if vscode_ok then
    vscode.setup({ style = "dark" })
    vscode.load()
end

-- Miscellaneous
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true
opt.updatetime = 50

-- ============================================================================
-- KEYMAPS
-- ============================================================================
vim.g.mapleader = " "

local keymap = vim.keymap

-- Disable F1 help (prevent accidental triggers)
keymap.set("", "<F1>", "<Nop>")
keymap.set("i", "<F1>", "<Nop>")

-- General keymaps
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "x", '"_x', { desc = "Delete char without copying" })

-- Increment/decrement
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Split management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Equal split sizes" })
keymap.set("n", "<leader>sx", ":close<CR>", { desc = "Close current split" })

-- Tab management
keymap.set("n", "<leader>to", ":tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "Close tab" })
keymap.set("n", "<leader>tn", ":tabn<CR>", { desc = "Next tab" })
keymap.set("n", "<leader>tp", ":tabp<CR>", { desc = "Previous tab" })

-- Diagnostics
keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Show diagnostics" })
keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- Config shortcuts
keymap.set("n", "<leader>1", ":source $MYVIMRC<CR>", { desc = "Source nvim config" })
keymap.set("n", "<leader>2", ":e $MYVIMRC<CR>", { desc = "Edit nvim config" })

-- Move selected lines in visual mode
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered when scrolling
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

-- ============================================================================
-- PLUGIN CONFIGURATIONS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Colorscheme (Adwaita)
-- ----------------------------------------------------------------------------
local colorscheme_status = pcall(vim.cmd, "colorscheme adwaita")
if colorscheme_status then
    vim.g.adwaita_darker = true
end

-- ----------------------------------------------------------------------------
-- Comment.nvim
-- ----------------------------------------------------------------------------
local comment_status, comment = pcall(require, "Comment")
if comment_status then
    comment.setup()
end

-- ----------------------------------------------------------------------------
-- nvim-tree
-- ----------------------------------------------------------------------------
-- Disable netrw (recommended by nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local nvimtree_status, nvimtree = pcall(require, "nvim-tree")
if nvimtree_status then
    nvimtree.setup({
        renderer = {
            icons = {
                glyphs = {
                    folder = {
                        arrow_closed = "",
                        arrow_open = "",
                    },
                },
            },
        },
        actions = {
            open_file = {
                window_picker = {
                    enable = false,
                },
            },
        },
    })
    keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
    keymap.set("n", "<leader>ef", ":NvimTreeFindFile<CR>", { desc = "Find file in explorer" })
end

-- ----------------------------------------------------------------------------
-- Lualine
-- ----------------------------------------------------------------------------
local lualine_status, lualine = pcall(require, "lualine")
if lualine_status then
    lualine.setup({
        options = {
            theme = "vscode",
        },
        sections = {
            lualine_x = { "encoding", { "fileformat", symbols = { unix = vim.fn.nr2char(0xf179), dos = vim.fn.nr2char(0xe70f), mac = vim.fn.nr2char(0xe711) } }, "filetype" },
        },
    })
end

-- ----------------------------------------------------------------------------
-- Telescope
-- ----------------------------------------------------------------------------
local telescope_status, telescope = pcall(require, "telescope")
if telescope_status then
    telescope.setup({
        defaults = {
            mappings = {
                i = {
                    ["<C-k>"] = require("telescope.actions").move_selection_previous,
                    ["<C-j>"] = require("telescope.actions").move_selection_next,
                },
            },
        },
    })
    telescope.load_extension("fzf")

    local builtin = require("telescope.builtin")
    keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files" })
    keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Fuzzy find in file content" })
    keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Fuzzy find open buffers" })
    keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Fuzzy find help tags" })
end

-- ----------------------------------------------------------------------------
-- Autocompletion (nvim-cmp)
-- ----------------------------------------------------------------------------
local cmp_status, cmp = pcall(require, "cmp")
if cmp_status then
    local luasnip_status, luasnip = pcall(require, "luasnip")
    local lspkind_status, lspkind = pcall(require, "lspkind")

    -- Load friendly-snippets
    if luasnip_status then
        require("luasnip.loaders.from_vscode").lazy_load()
    end

    cmp.setup({
        snippet = {
            expand = function(args)
                if luasnip_status then
                    luasnip.lsp_expand(args.body)
                end
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-k>"] = cmp.mapping.select_prev_item(),
            ["<C-j>"] = cmp.mapping.select_next_item(),
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = false }),
        }),
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "path" },
        }),
        formatting = {
            format = lspkind_status and lspkind.cmp_format({
                maxwidth = 50,
                ellipsis_char = "...",
            }) or nil,
        },
    })
end

-- ----------------------------------------------------------------------------
-- LSP Configuration
-- ----------------------------------------------------------------------------

-- Suppress lspconfig deprecation warning on Neovim 0.11+
-- (nvim-lspconfig hasn't migrated to vim.lsp.config yet)
local orig_deprecate = vim.deprecate
vim.deprecate = function(old, new, version, plugin, ...)
    if plugin and plugin:match("lspconfig") then
        return
    end
    if old and type(old) == "string" and old:match("lspconfig") then
        return
    end
    return orig_deprecate(old, new, version, plugin, ...)
end

local mason_status, mason = pcall(require, "mason")
if mason_status then
    mason.setup()
end

local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if mason_lspconfig_status then
    mason_lspconfig.setup({
        ensure_installed = {
            "pyright",
            "clangd",
            "lua_ls",
            "jdtls",
        },
        automatic_installation = true,
    })
end

local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if lspconfig_status then
    local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local capabilities = cmp_nvim_lsp_status
        and cmp_nvim_lsp.default_capabilities()
        or vim.lsp.protocol.make_client_capabilities()

    -- On-attach keybindings
    local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr, silent = true }

        keymap.set("n", "<leader>gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Goto definition" }))
        keymap.set("n", "<leader>gi", vim.lsp.buf.implementation,
            vim.tbl_extend("force", opts, { desc = "Goto implementation" }))
        keymap.set("n", "<leader>gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Show references" }))
        keymap.set("n", "<leader>ds", vim.lsp.buf.document_symbol,
            vim.tbl_extend("force", opts, { desc = "Document symbols" }))
        keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol,
            vim.tbl_extend("force", opts, { desc = "Workspace symbols" }))
        keymap.set("n", "<leader>dws", vim.lsp.buf.dynamic_workspace_symbol or vim.lsp.buf.workspace_symbol,
            vim.tbl_extend("force", opts, { desc = "Dynamic workspace symbols" }))
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
        keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code actions" }))
        keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
    end

    -- Python (pyright)
    lspconfig.pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
    })

    -- C/C++ (clangd)
    lspconfig.clangd.setup({
        capabilities = capabilities,
        on_attach = on_attach,
    })

    -- Java (jdtls)
    lspconfig.jdtls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
    })

    -- Lua (for nvim config editing)
    lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.stdpath("config") .. "/lua"] = true,
                    },
                },
            },
        },
    })
end

-- Lspsaga
local saga_status, saga = pcall(require, "lspsaga")
if saga_status then
    saga.setup({
        ui = {
            border = "rounded",
        },
    })
end

-- ----------------------------------------------------------------------------
-- Conform (Formatting)
-- ----------------------------------------------------------------------------
local conform_status, conform = pcall(require, "conform")
if conform_status then
    conform.setup({
        formatters_by_ft = {
            python = { "black" },
            lua = { "stylua" },
            c = { "clang-format" },
            cpp = { "clang-format" },
        },
        format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
        },
    })
end

-- ----------------------------------------------------------------------------
-- Treesitter
-- ----------------------------------------------------------------------------
local treesitter_status, treesitter = pcall(require, "nvim-treesitter.configs")
if treesitter_status then
    treesitter.setup({
        ensure_installed = {
            "c",
            "cpp",
            "python",
            "java",
            "lua",
            "vim",
            "vimdoc",
            "query",
            "javascript",
            "typescript",
            "json",
            "yaml",
            "markdown",
            "bash",
        },
        highlight = { enable = true },
        indent = { enable = true },
        auto_install = true,
    })
end

-- ----------------------------------------------------------------------------
-- Autopairs
-- ----------------------------------------------------------------------------
local autopairs_status, autopairs = pcall(require, "nvim-autopairs")
if autopairs_status then
    autopairs.setup({
        check_ts = true,
    })

    -- Integrate with nvim-cmp
    if cmp_status then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end
end

-- Autotag
local autotag_status, autotag = pcall(require, "nvim-ts-autotag")
if autotag_status then
    autotag.setup()
end

-- ----------------------------------------------------------------------------
-- TODO Comments
-- ----------------------------------------------------------------------------
local todo_status, todo = pcall(require, "todo-comments")
if todo_status then
    todo.setup()
end

-- ============================================================================
-- DAP (Debug Adapter Protocol)
-- ============================================================================
require("gdninizcr.dap_config")

-- DAP Keymaps
keymap.set("n", "<F5>", function() require("dap").continue() end, { desc = "Debug: Start/Continue" })
keymap.set("n", "<F9>", function() require("dap").toggle_breakpoint() end, { desc = "Debug: Toggle breakpoint" })
keymap.set("n", "<F10>", function() require("dap").step_over() end, { desc = "Debug: Step over" })
keymap.set("n", "<F11>", function() require("dap").step_into() end, { desc = "Debug: Step into" })
keymap.set("n", "<S-F11>", function() require("dap").step_out() end, { desc = "Debug: Step out" })
keymap.set("n", "<S-F5>", function() require("dap").terminate() end, { desc = "Debug: Terminate" })
keymap.set("n", "<leader>dt", function()
    local dapui_ok, dapui = pcall(require, "dapui")
    if dapui_ok then dapui.toggle() end
end, { desc = "Debug: Toggle UI" })
