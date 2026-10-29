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

local query_langs = { dataview = true, query = true }

-- Hides query bodies so only the results show; render-markdown's anti-conceal reveals them under the cursor.
local function parse(ctx)
  local marks = obsidian_query.handler.parse(ctx)
  local query = obsidian_query.fence_query()
  for _, match in query:iter_matches(ctx.root, ctx.buf) do
    local nodes = {}
    for id, captured in pairs(match) do
      nodes[query.captures[id]] = captured[#captured]
    end
    if nodes.lang and nodes.body and query_langs[vim.treesitter.get_node_text(nodes.lang, ctx.buf)] then
      local start_row, _, end_row, end_col = nodes.body:range()
      if end_col == 0 then
        end_row = end_row - 1
      end
      -- At EOF obsidian-query anchors results to the last body row, which would be concealed too
      for _, mark in ipairs(marks) do
        if mark.opts.virt_lines and mark.start_row >= start_row and mark.start_row <= end_row then
          mark.start_row = start_row - 1
          mark.opts.virt_lines_above = false
        end
      end
      marks[#marks + 1] = {
        conceal = true,
        start_row = start_row,
        start_col = 0,
        opts = {
          end_row = end_row,
          end_col = #vim.api.nvim_buf_get_lines(ctx.buf, end_row, end_row + 1, false)[1],
          conceal_lines = "",
        },
      }
    end
  end
  return marks
end

return {
  handler = { extends = true, parse = parse },
}
