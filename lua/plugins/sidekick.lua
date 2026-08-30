local map = vim.keymap.set
local cli = require('sidekick.cli')

require('sidekick').setup({
  nes = {
    enabled = false,
  },
  cli = {
    picker = 'fzf-lua',
    win = {
      layout = 'right',
      keys = {
        esc = { '<esc><esc>', 'blur', mode = 't', desc = 'go back to the previous window' },
      },
    },
  },
  copilot = {
    status = {
      enabled = false,
    },
  },
})

map('n', '<leader>aa', function()
  cli.toggle({ name = 'codex', focus = true })
end, { desc = 'toggle codex' })
map('n', '<leader>as', function()
  cli.select({ filter = { installed = true }, focus = true })
end, { desc = 'select ai cli' })
map({ 'n', 'x' }, '<leader>ap', function()
  cli.prompt()
end, { desc = 'prompt ai' })
map('n', '<leader>af', function()
  cli.send({ msg = '{file}' })
end, { desc = 'send file' })
map({ 'n', 'x' }, '<leader>aD', function()
  cli.send({ prompt = 'diagnostics' })
end, { desc = 'send diagnostics' })
map('n', '<leader>aA', function()
  cli.send({ prompt = 'diagnostics_all' })
end, { desc = 'send all diagnostics' })
map({ 'n', 'x' }, '<leader>at', function()
  cli.send({ msg = '{this}' })
end, { desc = 'send this' })
map('x', '<leader>av', function()
  cli.send({ msg = '{selection}' })
end, { desc = 'send selection' })
map('n', '<leader>ad', function()
  cli.close()
end, { desc = 'detach ai cli' })
