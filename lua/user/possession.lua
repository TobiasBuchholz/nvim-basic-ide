local status_ok, possession = pcall(require, "possession")
if not status_ok then
  return
end

possession.setup {
  session_dir = vim.fn.stdpath('data') .. '/possession',
  silent = false,
  load_silent = true,
  debug = false,
  logfile = false,
  prompt_no_cr = false,
  autosave = {
      current = false,  -- or fun(name): boolean
      tmp = false,  -- or fun(): boolean
      tmp_name = 'tmp',
      on_load = true,
      on_quit = true,
  },
  commands = {
      save = 'PossessionSave',
      load = 'PossessionLoad',
      close = 'PossessionClose',
      delete = 'PossessionDelete',
      show = 'PossessionShow',
      list = 'PossessionList',
      migrate = 'PossessionMigrate',
  },
  hooks = {
      before_save = function(name) return {} end,
      after_save = function(name, user_data, aborted) end,
      before_load = function(name, user_data) return user_data end,
      after_load = function(name, user_data) end,
  },
  plugins = {
      close_windows = {
          hooks = {'before_save', 'before_load'},
          preserve_layout = true,  -- or fun(win): boolean
          match = {
              floating = true,
              buftype = {},
              filetype = {},
              custom = false,  -- or fun(win): boolean
          },
      },
      delete_hidden_buffers = false, -- Remove the deletion of hidden buffers without windows
      delete_buffers = true, -- Delete all buffers before loading another session
      nvim_tree = true,
      dap = true,
  },
}

local tele_status_ok, telescope = pcall(require, "telescope")
if not tele_status_ok then
  return
end

telescope.load_extension "possession"
