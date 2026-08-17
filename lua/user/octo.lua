local status_ok, octo = pcall(require, "octo")
if not status_ok then
  return
end

octo.setup({
  picker = "telescope", -- one of 'telescope', 'fzf-lua' or 'snacks'
  use_local_fs = false, -- use local files on right side of reviews
  enable_builtin = true, -- shows a list of builtin actions when no action is provided
  default_to_projects_v2 = false,
  default_merge_method = "merge", -- "merge", "squash" or "rebase"
  default_delete_branch = false, -- whether to delete the branch after merging a PR
  gh_cmd = "gh",
  timeout = 5000,
  ui = {
    use_signcolumn = false, -- show "modified" marks on the sign column
    use_statuscolumn = true, -- show "modified" marks on the status column
  },
  issues = {
    order_by = {
      field = "CREATED_AT",
      direction = "DESC",
    },
  },
  pull_requests = {
    order_by = {
      field = "CREATED_AT",
      direction = "DESC",
    },
    always_select_remote_on_create = false,
  },
  file_panel = {
    size = 10, -- changed files panel rows
    icons = true, -- true = nvim-web-devicons, false = disabled, function = custom provider
  },
})
