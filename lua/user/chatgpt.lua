local status_ok, chatgpt = pcall(require, "chatgpt")
if not status_ok then
  return
end

chatgpt.setup({
  api_key_cmd = "op read op://Private/OpenAI-secret-key-ChatGPT.nvim/credential --no-newline"
})
