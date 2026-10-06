-- neomd composes in neomd-*.md buffers and turns `[attach] <path>` lines into MIME attachments.
local function attach()
  local target_buf = vim.api.nvim_get_current_buf()
  local target_win = vim.api.nvim_get_current_win()
  local cursor_row = vim.api.nvim_win_get_cursor(target_win)[1]
  local chooser = vim.fn.tempname()

  local width = math.floor(vim.o.columns * 0.85)
  local height = math.floor(vim.o.lines * 0.85)
  local float_win = vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
    title = " attach file — <Enter> select, q quit ",
    title_pos = "center",
  })

  vim.fn.termopen({ "spf", "--chooser-file", chooser }, {
    on_exit = function()
      if vim.api.nvim_win_is_valid(float_win) then
        vim.api.nvim_win_close(float_win, true)
      end
      vim.schedule(function()
        local ok, lines = pcall(vim.fn.readfile, chooser)
        vim.fn.delete(chooser)
        if not ok or #lines == 0 then
          return
        end

        local inserts, skipped = {}, {}
        for _, path in ipairs(lines) do
          path = vim.trim(path)
          if path ~= "" then
            local stat = vim.uv.fs_stat(path)
            if stat and stat.type == "file" then
              table.insert(inserts, "[attach] " .. path)
            else
              table.insert(skipped, path)
            end
          end
        end
        if #skipped > 0 then
          vim.notify("neomd: skipped non-file path(s):\n  " .. table.concat(skipped, "\n  "), vim.log.levels.WARN)
        end
        if #inserts == 0 then
          return
        end

        vim.api.nvim_buf_set_lines(target_buf, cursor_row, cursor_row, false, inserts)
        if vim.api.nvim_win_is_valid(target_win) then
          vim.api.nvim_win_set_cursor(target_win, { cursor_row + #inserts, 0 })
        end
      end)
    end,
  })
  vim.cmd "startinsert"
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "neomd-*.md" },
  callback = function()
    vim.keymap.set("n", "<leader>a", attach, { buffer = true, desc = "neomd: attach file via spf" })
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "de,en_us"
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})
