local status_ok, winbar = pcall(require, "winbar")
if not status_ok then
  return
end

winbar.setup({
    enabled = true,

    show_file_path = true,
    show_symbols = true,

    colors = {
        path = '#606060',
        file_name = '#909090',
        symbols = '',
    },

    icons = {
        file_icon_default = '',
        seperator = '>',
        editor_state = '●',
        lock_icon = '',
    },

    exclude_filetype = {
        'help',
        'startify',
        'dashboard',
        'packer',
        'neogitstatus',
        'NvimTree',
        'Trouble',
        'alpha',
        'lir',
        'Outline',
        'spectre_panel',
        'toggleterm',
        'qf',
    }
})
