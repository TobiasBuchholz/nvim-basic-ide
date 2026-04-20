local status_ok, copilot = pcall(require, "copilot")
if not status_ok then
  return
end

copilot.setup({
  copilot_node_command = vim.fn.expand("$HOME") .. "/.asdf/shims/node",
  server = {
    type = "binary",
    custom_server_filepath = "copilot-language-server",
  },
  -- nes = {
  --   enabled = true,
  --   keymap = {
  --     accept_and_goto = "<leader>p",
  --     accept = false,
  --     dismiss = "<Esc>",
  --   },
  -- },
  suggestion = { enabled = false },
  panel = { enabled = false }
})
