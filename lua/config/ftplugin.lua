local M = {}

local indent_guide_exclude = {
  [''] = true,
  NeogitStatus = true,
  NvimTree = true,
  checkhealth = true,
  git = true,
  gitcommit = true,
  ['gitsigns-blame'] = true,
  help = true,
  lspinfo = true,
  man = true,
  notify = true,
  oil = true,
  qf = true,
}

-- ponytail: native guides omit scope and empty-line inference; revisit if Neovim exposes both without per-buffer timers
local function set_indent_guides(buf)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buf then
      vim.api.nvim_win_call(win, function()
        local listchars = vim.opt_local.listchars:get()
        local enabled = vim.bo.buftype == '' and not indent_guide_exclude[vim.bo.filetype]

        if enabled then
          local width = vim.bo.shiftwidth > 0 and vim.bo.shiftwidth or vim.bo.tabstop
          listchars.leadmultispace = '│' .. string.rep(' ', width - 1)
        else
          listchars.leadmultispace = nil
        end

        vim.opt_local.listchars = listchars
      end)
    end
  end
end

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
  opts = opts or {}
  local ok = pcall(vim.treesitter.start)
  if not ok then
    return M
  end
  if opts.indent ~= false then
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
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
  gitattributes = { indent = 2, treesitter = true },
  gitconfig = { indent = 4, treesitter = true },
  gitignore = { indent = 2, treesitter = true },
  gitrebase = { indent = 2, treesitter = true },
  go = { treesitter = { indent = false } },
  gomod = { treesitter = { indent = false } },
  gosum = { treesitter = { indent = false } },
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
  toml = { indent = 2, treesitter = true },
  typescript = { indent = 2, treesitter = true },
  typescriptreact = { indent = 2, treesitter = true },
  vim = { indent = 2, treesitter = true },
  xml = { indent = 2, treesitter = true },
  yaml = { indent = 2, treesitter = true },
  yang = { indent = 2, treesitter = true },
  zsh = { indent = 2, treesitter = true },
}

local ftplugin_group = vim.api.nvim_create_augroup('ftplugin_settings', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  group = ftplugin_group,
  pattern = '*',
  callback = function(ev)
    local s = settings[ev.match]
    if not s then
      set_indent_guides(ev.buf)
      return
    end
    if s.prose then
      M.prose()
    end
    if s.indent then
      M.indent(s.indent)
    end
    if s.treesitter then
      M.treesitter(type(s.treesitter) == 'table' and s.treesitter or nil)
    end
    set_indent_guides(ev.buf)
  end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  group = ftplugin_group,
  callback = function(ev)
    set_indent_guides(ev.buf)
  end,
})

vim.api.nvim_create_autocmd('OptionSet', {
  group = ftplugin_group,
  pattern = { 'buftype', 'shiftwidth', 'tabstop' },
  callback = function()
    set_indent_guides(vim.api.nvim_get_current_buf())
  end,
})

return M
