local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', '<BS>', api.node.navigate.parent_close, opts('Close Directory'))
  vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
end

nvim_tree.setup({
  on_attach = my_on_attach,
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
