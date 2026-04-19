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
      backdrop = 80,
    },
  }
})
