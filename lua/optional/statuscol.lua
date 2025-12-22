---@module "lazy"
---@type LazySpec
return {
  'luukvbaal/statuscol.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    local builtin = require('statuscol.builtin')
    require('statuscol').setup({
      relculright = true,
      segments = {
        { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
        {
          sign = { namespace = { 'gitsigns' }, maxwidth = 1, colwidth = 1, auto = false },
          click = 'v:lua.ScSa',
        },
        {
          sign = { namespace = { '.*' }, name = { '.*' }, maxwidth = 1, colwidth = 2, auto = false },
          click = 'v:lua.ScSa',
        },
        { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
      },
      clickhandlers = {
        gitsigns = builtin.gitsigns_click,
      },
    })
  end,
}
