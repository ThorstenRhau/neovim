---@param background 'dark'|'light'
---@return table
local function palette(background)
  if background == 'light' then
    return {
      bg0 = '#edece8',
      bg1 = '#f1f0ec',
      bg2 = '#f5f4f1',
      bg3 = '#faf9f5',
      bg4 = '#f0efeb',
      bg5 = '#eae9e5',
      fg0 = '#2a2920',
      fg1 = '#3d3929',
      fg2 = '#8b8780',
      fg3 = '#c4c0b8',
      accent = '#C8633F',
      accent2 = '#A67842',
      blue = '#5A7FA0',
      green = '#5B8A58',
      red = '#B05555',
      yellow = '#A89040',
      purple = '#8B6FA8',
      diff_add = '#d6ead4',
      diff_del = '#f0d0d0',
      diff_change = '#e8e4d8',
      diff_text = '#d8cca8',
      sel = '#dddcd6',
      match = '#e8d8b0',
    }
  end

  -- dark
  return {
    bg0 = '#191918',
    bg1 = '#1d1d1c',
    bg2 = '#212120',
    bg3 = '#262624',
    bg4 = '#2f2f2d',
    bg5 = '#383835',
    fg0 = '#e8e4dc',
    fg1 = '#d4cfc6',
    fg2 = '#8b8780',
    fg3 = '#5a5955',
    accent = '#D97757',
    accent2 = '#C4956A',
    blue = '#7B9EBD',
    green = '#7DA47A',
    red = '#C07070',
    yellow = '#C4A855',
    purple = '#A68BBF',
    diff_add = '#292f26',
    diff_del = '#362728',
    diff_change = '#2b2b29',
    diff_text = '#444039',
    sel = '#3d3d3a',
    match = '#4a4030',
  }
end

return palette
