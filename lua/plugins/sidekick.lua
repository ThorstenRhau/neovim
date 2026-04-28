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
    tools = {
      codex = {
        cmd = { 'codex' },
      },
    },
  },
  copilot = {
    status = {
      enabled = false,
    },
  },
})
