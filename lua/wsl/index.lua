local wslyank = function()
  -- 使用windows剪切板
  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = 1,
  }
  vim.opt.clipboard = "unnamedplus"
end
if vim.fn.has("wsl") == 1 then
  vim.notify("🚀启动在wsl中!", vim.log.levels.INFO, {
    timeout = 3000,
  })

  wslyank()
end
