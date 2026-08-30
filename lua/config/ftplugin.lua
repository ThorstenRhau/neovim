local M = {}
local settings

vim.filetype.add({
  extension = {
    gotmpl = 'gotmpl',
  },
})

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

function M.treesitter(opts)
  local filetype_settings = settings and settings[vim.bo.filetype]
  if opts == nil and filetype_settings and type(filetype_settings.treesitter) == 'table' then
    opts = filetype_settings.treesitter
  end
  opts = opts or {}
  local ok = pcall(vim.treesitter.start)
  if not ok then
    return M
  end
  if opts.indent ~= false then
    local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
    if lang and vim.treesitter.query.get(lang, 'indents') then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end
  vim.wo[0][0].foldmethod = 'expr'
  vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  return M
end

-- Table-driven filetype settings
settings = {
  bash = { indent = 2, treesitter = true },
  css = { indent = 2, treesitter = true },
  diff = { indent = 4, treesitter = true },
  editorconfig = { indent = 2, treesitter = true },
  gitattributes = { indent = 2, treesitter = true },
  gitconfig = { indent = 4, treesitter = { indent = false } },
  gitignore = { indent = 2, treesitter = true },
  gitrebase = { indent = 2, treesitter = true },
  go = { treesitter = { indent = false } },
  gomod = { treesitter = { indent = false } },
  gosum = { treesitter = { indent = false } },
  gotmpl = { indent = 2, treesitter = true },
  gowork = { treesitter = { indent = false } },
  hcl = { indent = 2, treesitter = true },
  html = { indent = 2, treesitter = true },
  javascript = { indent = 2, treesitter = true },
  javascriptreact = { indent = 2, treesitter = true },
  json = { indent = 2, treesitter = true },
  jsonc = { indent = 2, treesitter = true },
  less = { indent = 2 },
  lua = { indent = 2, treesitter = true },
  markdown = { prose = true, treesitter = true },
  python = { indent = 4, treesitter = true },
  query = { indent = 2, treesitter = true },
  rust = { treesitter = { indent = false } },
  scss = { indent = 2, treesitter = true },
  sh = { indent = 2, treesitter = true },
  swift = { indent = 2, treesitter = true },
  toml = { indent = 2, treesitter = true },
  typescript = { indent = 2, treesitter = true },
  typescriptreact = { indent = 2, treesitter = true },
  vim = { indent = 2, treesitter = { indent = false } },
  xml = { indent = 2, treesitter = true },
  yaml = { indent = 2, treesitter = true },
  yang = { indent = 2, treesitter = true },
  zsh = { indent = 2, treesitter = true },
}

local ftplugin_group = vim.api.nvim_create_augroup('ftplugin_settings', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  group = ftplugin_group,
  pattern = vim.tbl_keys(settings),
  callback = function(ev)
    local s = settings[ev.match]
    if s.prose then
      M.prose()
    end
    if s.indent then
      M.indent(s.indent)
    end
    if s.treesitter then
      M.treesitter(type(s.treesitter) == 'table' and s.treesitter or nil)
    end
  end,
})

return M
