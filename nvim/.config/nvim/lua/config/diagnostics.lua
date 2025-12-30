-- “{‚ç‚ê‚élsp‚ª‚í‚©‚é
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
    end,
  },
  float = {
    border = "rounded",
    source = false,
    format = function(d)
      local code = d.code and (" [" .. d.code .. "]") or ""
      local src = d.source and (" (" .. d.source .. ")") or ""
      return d.message .. code .. src
    end,
  },
})

