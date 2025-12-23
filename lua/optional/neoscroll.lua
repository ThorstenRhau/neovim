---@module "lazy"
---@type LazySpec
return {
  'karb94/neoscroll.nvim',
  event = 'VeryLazy',
  opts = {
    duration_multiplier = 0.8,
    easing = 'sine',
    hide_cursor = true,
    stop_eof = true,
    cursor_scrolls_alone = true,
    respect_scrolloff = false,
  },
}
