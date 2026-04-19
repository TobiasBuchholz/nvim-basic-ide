-- Suppress lspconfig deprecation warning for tailwind-tools.nvim
local orig_notify = vim.notify
vim.notify = function(msg, level, opts)
  if type(msg) == "string" and (msg:match("lspconfig.*deprecated") or msg:match("traceback.*function '__index'")) then
    return
  end
  orig_notify(msg, level, opts)
end

require("tailwind-tools").setup({})

-- Restore vim.notify afterwards
vim.notify = orig_notify
