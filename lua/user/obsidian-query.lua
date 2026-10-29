local status_ok, obsidian_query = pcall(require, "obsidian-query")
if not status_ok then
  return
end

obsidian_query.setup({
  picker = {
    backend = "telescope",
    style = "rich",
  },
})
