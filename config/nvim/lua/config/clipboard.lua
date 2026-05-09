-- クリップボード連携
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    -- name = "WslClipboard",
    -- copy = {
    --   ["+"] = { "bash", "-lc", "iconv -f utf-8 -t utf-16le | clip.exe" },
    --   ["*"] = { "bash", "-lc", "iconv -f utf-8 -t utf-16le | clip.exe" },
    -- },
    -- paste = {
    --   ["+"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    --   ["*"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    -- },
    -- cache_enabled = 0,
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
end
