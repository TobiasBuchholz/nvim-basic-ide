-- Neovim resolves its clipboard provider to pbcopy on any macOS host, which inside a
-- `herdr --remote` server is the remote pasteboard. OSC 52 reaches the machine rendering the
-- session instead. Nothing there answers an OSC 52 read, so paste serves the local register.
if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
  local osc52 = require "vim.ui.clipboard.osc52"

  local function paste()
    local regtype = vim.fn.getregtype '"'
    -- The provider rejects the width suffix a blockwise regtype carries.
    if regtype:sub(1, 1) == "\22" then
      regtype = "\22"
    end
    return { vim.split(vim.fn.getreg '"', "\n", { plain = true }), regtype }
  end

  vim.g.clipboard = {
    name = "osc52",
    -- Both registers copy with selection "c": macOS has no primary selection, and herdr
    -- re-emits every clipboard write as "c" regardless.
    copy = { ["+"] = osc52.copy "+", ["*"] = osc52.copy "+" },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end
