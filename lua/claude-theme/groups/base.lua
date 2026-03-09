---@param p table palette
---@return table
local function base(p)
  return {
    -- Editor UI
    Normal = { fg = p.fg0, bg = p.bg3 },
    NormalNC = { fg = p.fg0, bg = p.bg2 },
    NormalFloat = { fg = p.fg0, bg = p.bg0 },
    FloatBorder = { fg = p.fg3, bg = p.bg0 },
    FloatTitle = { fg = p.accent, bg = p.bg0, bold = true },
    FloatFooter = { fg = p.fg2, bg = p.bg0 },

    Cursor = { fg = p.bg3, bg = p.fg0 },
    CursorIM = { link = 'Cursor' },
    CursorLine = { bg = p.bg5 },
    CursorColumn = { bg = p.bg5 },
    TermCursor = { link = 'Cursor' },
    CursorLineFold = { fg = p.fg3, bg = p.bg5 },
    CursorLineSign = { fg = p.fg3, bg = p.bg5 },
    CursorLineNr = { fg = p.accent2, bold = true },

    LineNr = { fg = p.fg3 },
    LineNrAbove = { fg = p.fg3 },
    LineNrBelow = { fg = p.fg3 },
    SignColumn = { fg = p.fg3, bg = p.bg3 },
    FoldColumn = { fg = p.fg3, bg = p.bg3 },
    Folded = { fg = p.fg2, bg = p.bg4 },

    ColorColumn = { bg = p.bg4 },
    VertSplit = { fg = p.bg4 },
    WinSeparator = { fg = p.bg4 },

    StatusLine = { fg = p.fg1, bg = p.bg1 },
    StatusLineNC = { fg = p.fg3, bg = p.bg1 },
    WinBar = { fg = p.fg1, bg = p.bg3 },
    WinBarNC = { fg = p.fg3, bg = p.bg2 },

    TabLine = { fg = p.fg2, bg = p.bg1 },
    TabLineFill = { fg = p.fg3, bg = p.bg1 },
    TabLineSel = { fg = p.fg0, bg = p.bg3, bold = true },

    Pmenu = { fg = p.fg0, bg = p.bg1 },
    PmenuSel = { fg = p.fg0, bg = p.sel, bold = true },
    PmenuSbar = { bg = p.bg2 },
    PmenuThumb = { bg = p.fg3 },
    PmenuKind = { fg = p.blue, bg = p.bg1 },
    PmenuKindSel = { fg = p.blue, bg = p.sel },
    PmenuExtra = { fg = p.fg2, bg = p.bg1 },
    PmenuExtraSel = { fg = p.fg2, bg = p.sel },
    PmenuMatch = { fg = p.accent, bg = p.bg1, bold = true },
    PmenuMatchSel = { fg = p.accent, bg = p.sel, bold = true },

    Visual = { bg = p.sel },
    VisualNOS = { bg = p.sel },

    Search = { fg = p.fg0, bg = p.match },
    IncSearch = { fg = p.bg3, bg = p.accent2 },
    CurSearch = { fg = p.bg3, bg = p.accent },
    Substitute = { fg = p.bg3, bg = p.red },

    MatchParen = { fg = p.accent, bold = true, underline = true },
    SnippetTabstop = { bg = p.bg5 },

    WildMenu = { fg = p.bg3, bg = p.accent2 },
    QuickFixLine = { bg = p.bg5 },

    Directory = { fg = p.blue },
    Title = { fg = p.accent, bold = true },
    Question = { fg = p.green },
    MoreMsg = { fg = p.green },
    ModeMsg = { fg = p.fg1, bold = true },
    WarningMsg = { fg = p.yellow },
    ErrorMsg = { fg = p.red },
    MsgArea = { fg = p.fg0 },
    MsgSeparator = { fg = p.fg3, bg = p.bg4 },

    NonText = { fg = p.fg3 },
    Whitespace = { fg = p.fg3 },
    SpecialKey = { fg = p.fg3 },
    EndOfBuffer = { fg = p.bg4 },
    Conceal = { fg = p.fg2 },

    SpellBad = { undercurl = true, sp = p.red },
    SpellCap = { undercurl = true, sp = p.yellow },
    SpellLocal = { undercurl = true, sp = p.blue },
    SpellRare = { undercurl = true, sp = p.purple },

    -- Diff
    DiffAdd = { bg = p.diff_add },
    DiffDelete = { bg = p.diff_del },
    DiffChange = { bg = p.diff_change },
    DiffText = { bg = p.diff_text },
    Added = { fg = p.green },
    Changed = { fg = p.yellow },
    Removed = { fg = p.red },

    -- Diagnostics
    DiagnosticError = { fg = p.red },
    DiagnosticWarn = { fg = p.yellow },
    DiagnosticInfo = { fg = p.blue },
    DiagnosticHint = { fg = p.green },
    DiagnosticOk = { fg = p.green },

    DiagnosticUnderlineError = { undercurl = true, sp = p.red },
    DiagnosticUnderlineWarn = { undercurl = true, sp = p.yellow },
    DiagnosticUnderlineInfo = { undercurl = true, sp = p.blue },
    DiagnosticUnderlineHint = { undercurl = true, sp = p.green },
    DiagnosticUnderlineOk = { undercurl = true, sp = p.green },

    DiagnosticVirtualTextError = { fg = p.red, bg = p.diff_del },
    DiagnosticVirtualTextWarn = { fg = p.yellow, bg = p.diff_text },
    DiagnosticVirtualTextInfo = { fg = p.blue, bg = p.diff_change },
    DiagnosticVirtualTextHint = { fg = p.green, bg = p.diff_add },

    DiagnosticSignError = { fg = p.red },
    DiagnosticSignWarn = { fg = p.yellow },
    DiagnosticSignInfo = { fg = p.blue },
    DiagnosticSignHint = { fg = p.green },

    DiagnosticFloatingError = { fg = p.red },
    DiagnosticFloatingWarn = { fg = p.yellow },
    DiagnosticFloatingInfo = { fg = p.blue },
    DiagnosticFloatingHint = { fg = p.green },
    DiagnosticFloatingOk = { fg = p.green },

    DiagnosticDeprecated = { strikethrough = true },
    DiagnosticUnnecessary = { fg = p.fg3 },

    DiagnosticVirtualTextOk = { fg = p.green, bg = p.diff_add },
    DiagnosticSignOk = { fg = p.green },

    DiagnosticVirtualLinesError = { fg = p.red },
    DiagnosticVirtualLinesWarn = { fg = p.yellow },
    DiagnosticVirtualLinesInfo = { fg = p.blue },
    DiagnosticVirtualLinesHint = { fg = p.green },
    DiagnosticVirtualLinesOk = { fg = p.green },

    -- LSP references
    LspReferenceText = { bg = p.bg5 },
    LspReferenceRead = { bg = p.bg5 },
    LspReferenceWrite = { bg = p.bg5, bold = true },
    LspReferenceTarget = { bg = p.bg5 },
    LspInlayHint = { fg = p.fg3, bg = p.bg4, italic = true },
    LspCodeLens = { fg = p.fg2 },
    LspCodeLensSeparator = { fg = p.fg3 },
    LspSignatureActiveParameter = { fg = p.accent, bold = true },

    -- Legacy syntax groups
    Comment = { fg = p.fg2, italic = true },
    Constant = { fg = p.purple },
    String = { fg = p.green },
    Character = { fg = p.green },
    Number = { fg = p.purple },
    Boolean = { fg = p.accent2, bold = true },
    Float = { fg = p.purple },

    Identifier = { fg = p.fg0 },
    Function = { fg = p.accent },

    Statement = { fg = p.accent2 },
    Conditional = { fg = p.accent2 },
    Repeat = { fg = p.accent2 },
    Label = { fg = p.accent2 },
    Operator = { fg = p.fg1 },
    Keyword = { fg = p.accent2 },
    Exception = { fg = p.red },

    PreProc = { fg = p.purple },
    Include = { fg = p.purple },
    Define = { fg = p.purple },
    Macro = { fg = p.purple },
    PreCondit = { fg = p.purple },

    Type = { fg = p.blue },
    StorageClass = { fg = p.accent2 },
    Structure = { fg = p.blue },
    Typedef = { fg = p.blue },

    Special = { fg = p.purple },
    SpecialChar = { fg = p.purple },
    Tag = { fg = p.purple },
    Delimiter = { fg = p.fg1 },
    SpecialComment = { fg = p.fg2, italic = true },
    Debug = { fg = p.red },

    Underlined = { underline = true },
    Bold = { bold = true },
    Italic = { italic = true },
    Ignore = { fg = p.fg3 },
    Error = { fg = p.red, bold = true },
    Todo = { fg = p.yellow, bold = true },

    -- Misc UI
    ComplMatchIns = { fg = p.accent, bold = true },
    FloatShadow = { bg = p.bg0, blend = 50 },
    FloatShadowThrough = { bg = p.bg0, blend = 80 },

    -- Quickfix / Location list
    qfLineNr = { fg = p.fg2 },
    qfFileName = { fg = p.blue },
  }
end

return base
