local status_ok, parrot = pcall(require, "parrot")
if not status_ok then
  return
end

parrot.setup({
  providers = {
    openai = {
      api_key = io.popen('op read op://Private/OpenAI-secret-key-ChatGPT.nvim/credential --no-newline'):read()
    }
  }
})
