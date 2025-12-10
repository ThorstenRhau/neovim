---@module "lazy"
---@type LazySpec
return {
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',

    ---@module 'trouble'
    ---@type trouble.Config
    opts = {
      auto_close = true, -- Close Trouble when no items remain
      focus = true, -- Focus the Trouble window on open
      preview = {
        type = 'float',
        relative = 'editor',
        border = 'rounded',
        title = 'Preview',
        title_pos = 'center',
        position = { 0.7, 1 },
        size = { width = 0.3, height = 0.3 },
        zindex = 200,
      },
    },
    keys = {
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Trouble: Diagnostics (Workspace)',
      },
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Trouble: Diagnostics (Buffer)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Trouble: Symbols',
      },
      {
        '<leader>co',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'Trouble: LSP References / Definitions',
      },
      {
        '<leader>xl',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Trouble: Location List',
      },
      {
        '<leader>xq',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Trouble: Quickfix List',
      },
    },
  },
}
