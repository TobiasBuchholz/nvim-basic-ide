local status_ok, claudecode = pcall(require, "claudecode")
if not status_ok then
  return
end

claudecode.setup({
  config = true,
  terminal = {
    snacks_win_opts = {
      position = "float",
      width = 0.9,
      height = 0.9,
      border = "double",
      backdrop = 50,
    },
  },
  diff_opts = {
      layout = "horizontal", -- "vertical" or "horizontal"
      open_in_new_tab = false,
      keep_terminal_focus = false, -- If true, moves focus back to terminal after diff opens
      hide_terminal_in_new_tab = false
    }
})
