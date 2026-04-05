local M = {}

function M.prose()
  vim.opt_local.wrap = true
  if vim.bo.buftype == '' then
    vim.opt_local.spell = true
  end
  return M
end

function M.indent(size)
  vim.opt_local.tabstop = size
  vim.opt_local.shiftwidth = size
  vim.opt_local.softtabstop = size
  return M
end

function M.treesitter()
  vim.treesitter.start()
  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  vim.wo[0][0].foldmethod = 'expr'
  vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  return M
end

-- Table-driven filetype settings
local settings = {
  bash = { indent = 2, treesitter = true },
  css = { indent = 2, treesitter = true },
  diff = { indent = 4, treesitter = true },
  editorconfig = { indent = 2, treesitter = true },
  fish = { indent = 4, treesitter = true },
  gitattributes = { indent = 2, treesitter = true },
  gitconfig = { indent = 4, treesitter = true },
  gitignore = { indent = 2, treesitter = true },
  gitrebase = { indent = 2, treesitter = true },
  hcl = { indent = 2, treesitter = true },
  html = { indent = 2, treesitter = true },
  javascript = { indent = 2, treesitter = true },
  javascriptreact = { indent = 2, treesitter = true },
  json = { indent = 2, treesitter = true },
  jsonc = { indent = 2, treesitter = true },
  less = { indent = 2, treesitter = true },
  lua = { indent = 2, treesitter = true },
  markdown = { prose = true, treesitter = true },
  python = { indent = 4, treesitter = true },
  query = { indent = 2, treesitter = true },
  scss = { indent = 2, treesitter = true },
  sh = { indent = 2, treesitter = true },
  toml = { indent = 2, treesitter = true },
  typescript = { indent = 2, treesitter = true },
  typescriptreact = { indent = 2, treesitter = true },
  vim = { indent = 2, treesitter = true },
  xml = { indent = 2, treesitter = true },
  yaml = { indent = 2, treesitter = true },
  yang = { indent = 2, treesitter = true },
  zsh = { indent = 2 },
}

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('ftplugin_settings', { clear = true }),
  pattern = vim.tbl_keys(settings),
  callback = function(ev)
    local s = settings[ev.match]
    if not s then
      return
    end
    if s.prose then
      M.prose()
    end
    if s.indent then
      M.indent(s.indent)
    end
    if s.treesitter then
      M.treesitter()
    end
  end,
})

return M
