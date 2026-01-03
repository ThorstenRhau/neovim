---@module "lazy"
---@type LazySpec
return {
  'luukvbaal/statuscol.nvim',
  event = 'VeryLazy',
  config = function()
    local builtin = require('statuscol.builtin')
    require('statuscol').setup({
      relculright = true,
      ft_ignore = { 'help', 'Trouble', 'lazy', 'mason', 'notify', 'toggleterm' },
      bt_ignore = { 'nofile', 'terminal' },
      segments = {
        { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
        {
          sign = {
            namespace = { 'diagnostic', 'gitsigns' },
            maxwidth = 1,
            colwidth = 1,
            auto = ' ',
          },
          click = 'v:lua.ScSa',
        },
        { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
      },
      clickhandlers = {
        gitsigns = builtin.gitsigns_click,
        Lnum = builtin.lnum_click,
        FoldClose = builtin.foldclose_click,
        FoldOpen = builtin.foldopen_click,
        FoldOther = builtin.foldother_click,
      },
    })
  end,
}
