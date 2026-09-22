local status_ok, obsidian = pcall(require, "obsidian")
if not status_ok then
  return
end

obsidian.setup({
  legacy_commands = false,
  workspaces = {
    { name = "notes", path = "~/Documents/obsidian-notes-vault" },
  },
  notes_subdir = "notes",
  new_notes_location = "notes_subdir",
  daily_notes = {
    folder = "dailies",
    date_format = "YYYY-MM-DD",
  },
  templates = {
    folder = "templates",
    date_format = "YYYY-MM-DD",
    time_format = "HH:mm",
  },
  completion = {
    min_chars = 2,
  },
  picker = {
    name = "telescope.nvim",
  },
  -- render-markdown.nvim already handles concealing and highlighting
  ui = { enable = false },
  attachments = {
    folder = "assets/imgs",
  },
  note_id_func = function(title)
    if title ~= nil then
      return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
    end
    return tostring(os.time())
  end,
})

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>nn", "<cmd>Obsidian new<cr>", opts)
vim.keymap.set("n", "<leader>no", "<cmd>Obsidian open<cr>", opts)
vim.keymap.set("n", "<leader>nq", "<cmd>Obsidian quick_switch<cr>", opts)
vim.keymap.set("n", "<leader>ns", "<cmd>Obsidian search<cr>", opts)
vim.keymap.set("n", "<leader>nb", "<cmd>Obsidian backlinks<cr>", opts)
vim.keymap.set("n", "<leader>ng", "<cmd>Obsidian tags<cr>", opts)
vim.keymap.set("n", "<leader>nt", "<cmd>Obsidian today<cr>", opts)
vim.keymap.set("n", "<leader>ny", "<cmd>Obsidian yesterday<cr>", opts)
vim.keymap.set("n", "<leader>nd", "<cmd>Obsidian dailies<cr>", opts)
vim.keymap.set("n", "<leader>nr", "<cmd>Obsidian rename<cr>", opts)
vim.keymap.set("n", "<leader>np", "<cmd>Obsidian paste_img<cr>", opts)
vim.keymap.set("n", "<leader>ne", "<cmd>Obsidian template<cr>", opts)
vim.keymap.set("n", "<leader>nw", "<cmd>Obsidian workspace<cr>", opts)
vim.keymap.set("n", "<leader>nc", "<cmd>Obsidian toggle_checkbox<cr>", opts)
vim.keymap.set("v", "<leader>nl", "<cmd>Obsidian link<cr>", opts)
vim.keymap.set("v", "<leader>nL", "<cmd>Obsidian link_new<cr>", opts)
vim.keymap.set("v", "<leader>nx", "<cmd>Obsidian extract_note<cr>", opts)

local vault = vim.fn.expand "~/Documents/obsidian-notes-vault"

local function git(args, on_exit)
  local cmd = { "git", "-C", vault }
  vim.list_extend(cmd, args)
  return vim.system(cmd, { text = true }, on_exit)
end

local function notify(msg, level)
  vim.schedule(function()
    vim.notify(msg, level)
  end)
end

local function timestamp()
  local t = os.date "*t"
  local hour = t.hour % 12
  if hour == 0 then
    hour = 12
  end
  local suffix = t.hour < 12 and "AM" or "PM"
  return ("%d/%d/%d, %d:%02d:%02d %s"):format(t.month, t.day, t.year, hour, t.min, t.sec, suffix)
end

vim.api.nvim_create_user_command("ObsidianPush", function()
  local function fail(res)
    notify(res.stdout .. res.stderr, vim.log.levels.ERROR)
  end

  git({ "pull", "--rebase", "--autostash" }, function(pull)
    if pull.code ~= 0 then
      return fail(pull)
    end

    git({ "add", "-A" }, function(add)
      if add.code ~= 0 then
        return fail(add)
      end

      local msg = "Commit from nvim on " .. timestamp()
      git({ "commit", "-m", msg }, function(commit)
        if commit.code ~= 0 then
          if commit.stdout:match "nothing to commit" then
            return notify "Vault already up to date"
          end
          return fail(commit)
        end

        git({ "push" }, function(push)
          if push.code ~= 0 then
            return fail(push)
          end
          notify "Vault synced"
        end)
      end)
    end)
  end)
end, { desc = "Commit and push the Obsidian vault" })

vim.keymap.set("n", "<leader>nS", "<cmd>ObsidianPush<cr>", opts)
