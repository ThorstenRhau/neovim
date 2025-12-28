-- Toggle keymaps (replaces snacks.toggle)

local function notify(msg)
  vim.notify(msg, vim.log.levels.INFO)
end

local function map(key, fn, desc)
  vim.keymap.set('n', '<leader>' .. key, fn, { desc = desc })
end

-- Spell
map('uz', function()
  vim.o.spell = not vim.o.spell
  notify('Spell: ' .. (vim.o.spell and 'on' or 'off'))
end, 'Toggle Spelling')

-- Wrap
map('uw', function()
  vim.o.wrap = not vim.o.wrap
  notify('Wrap: ' .. (vim.o.wrap and 'on' or 'off'))
end, 'Toggle Wrap')

-- Relative number
map('uL', function()
  vim.o.relativenumber = not vim.o.relativenumber
  notify('Relative Number: ' .. (vim.o.relativenumber and 'on' or 'off'))
end, 'Toggle Relative Number')

-- Diagnostics
local diagnostics_enabled = true
map('ud', function()
  diagnostics_enabled = not diagnostics_enabled
  if diagnostics_enabled then
    vim.diagnostic.enable()
  else
    vim.diagnostic.enable(false)
  end
  notify('Diagnostics: ' .. (diagnostics_enabled and 'on' or 'off'))
end, 'Toggle Diagnostics')

-- Line number
map('ul', function()
  vim.o.number = not vim.o.number
  notify('Line Number: ' .. (vim.o.number and 'on' or 'off'))
end, 'Toggle Line Number')

-- Conceal level
map('uc', function()
  if vim.o.conceallevel == 0 then
    vim.o.conceallevel = 2
  else
    vim.o.conceallevel = 0
  end
  notify('Conceal Level: ' .. vim.o.conceallevel)
end, 'Toggle Conceal')

-- Treesitter
map('uT', function()
  if vim.b.ts_highlight then
    vim.treesitter.stop()
  else
    vim.treesitter.start()
  end
  notify('Treesitter: ' .. (vim.b.ts_highlight and 'on' or 'off'))
end, 'Toggle Treesitter')

-- Background (light/dark)
map('ub', function()
  if vim.o.background == 'dark' then
    vim.o.background = 'light'
  else
    vim.o.background = 'dark'
  end
  notify('Background: ' .. vim.o.background)
end, 'Toggle Background')

-- Inlay hints
map('uh', function()
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
  notify('Inlay Hints: ' .. (not enabled and 'on' or 'off'))
end, 'Toggle Inlay Hints')
