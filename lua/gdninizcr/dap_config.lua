-- DAP (Debug Adapter Protocol) configuration
-- This file can be required/excluded from init.lua to toggle debugging support

local dap_status, dap = pcall(require, "dap")
if not dap_status then
  return
end

local dapui_status, dapui = pcall(require, "dapui")
if not dapui_status then
  return
end

-- DAP UI setup
dapui.setup()

-- Mason DAP setup
require("mason-nvim-dap").setup({
  ensure_installed = { "codelldb", "debugpy" },
  automatic_installation = true,
})

-- Automatically open/close DAP UI
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- C/C++ configuration (using codelldb)
dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
    args = { "--port", "${port}" },
  },
}

dap.configurations.c = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}
dap.configurations.cpp = dap.configurations.c

-- Python configuration (using debugpy)
dap.adapters.python = {
  type = "executable",
  command = vim.fn.stdpath("data") .. "/mason/bin/debugpy-adapter",
}

dap.configurations.python = {
  {
    name = "Launch file",
    type = "python",
    request = "launch",
    program = "${file}",
    pythonPath = function()
      local venv = os.getenv("VIRTUAL_ENV")
      if venv then
        return venv .. "/bin/python"
      end
      return "python3"
    end,
  },
}
