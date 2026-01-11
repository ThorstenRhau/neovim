-- https://github.com/miikanissi/modus-themes.nvim/

-- Highlight group definitions organized by plugin/purpose
-- Each function takes (highlights, colors) and mutates the highlights table

local function set_indent_blankline_highlights(highlights, colors)
  highlights.IblIndent = { fg = colors.bg_active, nocombine = true }
  highlights.IblScope = { fg = colors.cyan_faint, nocombine = true }
end

local function set_fzflua_highlights(highlights, colors)
  -- Preview window
  highlights.FzfLuaPreviewNormal = { bg = colors.bg_dim }
  highlights.FzfLuaPreviewBorder = { fg = colors.border, bg = colors.bg_dim }
  highlights.FzfLuaPreviewTitle = { fg = colors.fg_dim, bg = colors.bg_dim }
  highlights.FzfLuaCursorLine = { bg = colors.bg_hl_line }

  -- Fzf terminal colors
  highlights.FzfLuaFzfNormal = { fg = colors.fg_main, bg = colors.bg_main }
  highlights.FzfLuaFzfCursorLine = { bg = colors.bg_hl_line }
  highlights.FzfLuaFzfMatch = { fg = colors.magenta, bold = true }
  highlights.FzfLuaFzfBorder = { fg = colors.border }
  highlights.FzfLuaFzfPointer = { fg = colors.magenta_cooler }
  highlights.FzfLuaFzfMarker = { fg = colors.green }
  highlights.FzfLuaFzfPrompt = { fg = colors.blue_warmer }

  -- Path/file display
  highlights.FzfLuaDirPart = { fg = colors.fg_dim }
  highlights.FzfLuaFilePart = { fg = colors.fg_main }
  highlights.FzfLuaDirIcon = { fg = colors.blue }

  -- Buffer/lines
  highlights.FzfLuaBufLineNr = { fg = colors.fg_dim }
  highlights.FzfLuaBufId = { fg = colors.fg_dim }

  -- Search/live query
  highlights.FzfLuaSearch = { fg = colors.bg_main, bg = colors.yellow }
  highlights.FzfLuaLivePrompt = { fg = colors.magenta_warmer }
end

local function set_nvim_tree_highlights(highlights, colors)
  -- Git status
  highlights.NvimTreeGitStaged = { fg = colors.green }
  highlights.NvimTreeGitRenamed = { fg = colors.magenta }
  highlights.NvimTreeGitMerge = { fg = colors.yellow }
  highlights.NvimTreeGitIgnored = { fg = colors.fg_dim }

  -- Folder states
  highlights.NvimTreeFolderName = { fg = colors.blue }
  highlights.NvimTreeOpenedFolderName = { fg = colors.blue, bold = true }
  highlights.NvimTreeEmptyFolderName = { fg = colors.blue }

  -- Operations
  highlights.NvimTreeModifiedIcon = { fg = colors.yellow_warmer }
  highlights.NvimTreeCutHL = { fg = colors.red, strikethrough = true }
  highlights.NvimTreeCopiedHL = { fg = colors.cyan }

  -- UI elements
  highlights.NvimTreeWindowPicker = { fg = colors.bg_main, bg = colors.blue, bold = true }
  highlights.NvimTreeExecFile = { fg = colors.green }
end

local function set_line_number_highlights(highlights, colors)
  if colors.bg_main == '#f5f5f5' then
    -- Light mode
    highlights.LineNrAbove = { fg = colors.fg_dim, bg = '#efefef' }
    highlights.LineNr = { fg = colors.fg_main, bg = '#efefef' }
    highlights.LineNrBelow = { fg = colors.fg_dim, bg = '#efefef' }
    highlights.SignColumn = { bg = '#efefef' }
  elseif colors.bg_main == '#141414' then
    -- Dark mode
    highlights.LineNrAbove = { fg = colors.fg_dim, bg = '#242424' }
    highlights.LineNr = { fg = colors.fg_main, bg = '#242424' }
    highlights.LineNrBelow = { fg = colors.fg_dim, bg = '#242424' }
    highlights.SignColumn = { bg = '#242424' }
  end
end

local function set_blink_cmp_highlights(highlights, colors)
  -- Functions and methods
  highlights.BlinkCmpKindFunction = { fg = colors.magenta }
  highlights.BlinkCmpKindMethod = { fg = colors.magenta }
  highlights.BlinkCmpKindConstructor = { fg = colors.magenta }

  -- Variables and fields
  highlights.BlinkCmpKindVariable = { fg = colors.cyan }
  highlights.BlinkCmpKindField = { fg = colors.cyan }
  highlights.BlinkCmpKindProperty = { fg = colors.cyan }
  highlights.BlinkCmpKindEnumMember = { fg = colors.cyan }
  highlights.BlinkCmpKindValue = { fg = colors.cyan }

  -- Types and structures
  highlights.BlinkCmpKindClass = { fg = colors.yellow }
  highlights.BlinkCmpKindInterface = { fg = colors.yellow }
  highlights.BlinkCmpKindStruct = { fg = colors.yellow }
  highlights.BlinkCmpKindModule = { fg = colors.yellow }
  highlights.BlinkCmpKindEnum = { fg = colors.yellow }

  -- Keywords and constants
  highlights.BlinkCmpKindKeyword = { fg = colors.blue }
  highlights.BlinkCmpKindConstant = { fg = colors.blue_cooler }

  -- Files and folders
  highlights.BlinkCmpKindFile = { fg = colors.blue }
  highlights.BlinkCmpKindFolder = { fg = colors.blue }

  -- Other
  highlights.BlinkCmpKindSnippet = { fg = colors.green }
  highlights.BlinkCmpKindText = { fg = colors.fg_main }
end

local function set_diffview_highlights(highlights, colors)
  -- File panel
  highlights.DiffviewFilePanelTitle = { fg = colors.blue, bold = true }
  highlights.DiffviewFilePanelCounter = { fg = colors.magenta, bold = true }
  highlights.DiffviewFilePanelFileName = { fg = colors.fg_main }
  highlights.DiffviewFilePanelSelected = { fg = colors.magenta }
  highlights.DiffviewFilePanelPath = { fg = colors.fg_dim }
  highlights.DiffviewFilePanelInsertions = { fg = colors.green }
  highlights.DiffviewFilePanelDeletions = { fg = colors.red }
  highlights.DiffviewFilePanelConflicts = { fg = colors.yellow }

  -- Folders
  highlights.DiffviewFolderName = { fg = colors.blue }
  highlights.DiffviewFolderSign = { fg = colors.blue }

  -- Git info
  highlights.DiffviewHash = { fg = colors.magenta }
  highlights.DiffviewReference = { fg = colors.cyan }

  -- Status indicators
  highlights.DiffviewStatusAdded = { fg = colors.green }
  highlights.DiffviewStatusModified = { fg = colors.yellow }
  highlights.DiffviewStatusRenamed = { fg = colors.yellow }
  highlights.DiffviewStatusDeleted = { fg = colors.red }
  highlights.DiffviewStatusUntracked = { fg = colors.green }
  highlights.DiffviewStatusIgnored = { fg = colors.fg_dim }

  -- General UI
  highlights.DiffviewDim1 = { fg = colors.fg_dim }
  highlights.DiffviewPrimary = { fg = colors.blue }
  highlights.DiffviewSecondary = { fg = colors.cyan }
end

local function set_mason_highlights(highlights, colors)
  highlights.MasonHeader = { fg = colors.bg_main, bg = colors.blue, bold = true }
  highlights.MasonHeaderSecondary = { fg = colors.bg_main, bg = colors.cyan, bold = true }
  highlights.MasonHighlight = { fg = colors.cyan }
  highlights.MasonHighlightBlock = { fg = colors.bg_main, bg = colors.cyan }
  highlights.MasonHighlightBlockBold = { fg = colors.bg_main, bg = colors.cyan, bold = true }
  highlights.MasonHighlightSecondary = { fg = colors.yellow }
  highlights.MasonHighlightBlockSecondary = { fg = colors.bg_main, bg = colors.yellow }
  highlights.MasonMuted = { fg = colors.fg_dim }
  highlights.MasonMutedBlock = { fg = colors.bg_main, bg = colors.fg_dim }
end

local function set_treesitter_context_highlights(highlights, colors)
  highlights.TreesitterContext = { bg = colors.bg_dim }
  highlights.TreesitterContextLineNumber = { fg = colors.fg_dim, bg = colors.bg_dim }
  highlights.TreesitterContextSeparator = { fg = colors.border }
  highlights.TreesitterContextBottom = { underline = true, sp = colors.border }
  highlights.TreesitterContextLineNumberBottom = { underline = true, sp = colors.border }
end

local function set_neogit_highlights(highlights, colors)
  -- Section headers
  highlights.NeogitSectionHeader = { fg = colors.magenta_cooler, bold = true }
  highlights.NeogitSectionHeaderCount = { fg = colors.magenta_cooler }

  -- Branches and remotes
  highlights.NeogitBranch = { fg = colors.blue, bold = true }
  highlights.NeogitBranchHead = { fg = colors.blue, bold = true, underline = true }
  highlights.NeogitRemote = { fg = colors.green, bold = true }
  highlights.NeogitTagName = { fg = colors.yellow }
  highlights.NeogitTagDistance = { fg = colors.cyan_faint }

  -- Change status indicators
  highlights.NeogitChangeModified = { fg = colors.fg_changed_intense, italic = true }
  highlights.NeogitChangeAdded = { fg = colors.fg_added_intense, italic = true }
  highlights.NeogitChangeDeleted = { fg = colors.fg_removed_intense, italic = true }
  highlights.NeogitChangeRenamed = { fg = colors.magenta, italic = true }
  highlights.NeogitChangeUpdated = { fg = colors.yellow_warmer, italic = true }
  highlights.NeogitChangeCopied = { fg = colors.cyan, italic = true }
  highlights.NeogitChangeUnmerged = { fg = colors.yellow, italic = true }
  highlights.NeogitChangeNewFile = { fg = colors.fg_added_intense, italic = true }

  -- Diff display
  highlights.NeogitDiffHeader = { fg = colors.blue, bg = colors.bg_dim, bold = true }
  highlights.NeogitDiffHeaderHighlight = { fg = colors.yellow_warmer, bg = colors.bg_dim, bold = true }
  highlights.NeogitDiffContext = { bg = colors.bg_dim }
  highlights.NeogitDiffContextHighlight = { bg = colors.bg_active }
  highlights.NeogitDiffAdd = { fg = colors.fg_added, bg = colors.bg_added }
  highlights.NeogitDiffAddHighlight = { fg = colors.fg_added, bg = colors.bg_added_refine }
  highlights.NeogitDiffDelete = { fg = colors.fg_removed, bg = colors.bg_removed }
  highlights.NeogitDiffDeleteHighlight = { fg = colors.fg_removed, bg = colors.bg_removed_refine }

  -- Commit view
  highlights.NeogitCommitViewHeader = { fg = colors.magenta, bg = colors.bg_magenta_nuanced }
  highlights.NeogitFilePath = { fg = colors.blue, italic = true }

  -- Graph colors
  highlights.NeogitGraphAuthor = { fg = colors.cyan_faint }
  highlights.NeogitGraphRed = { fg = colors.red }
  highlights.NeogitGraphGreen = { fg = colors.green }
  highlights.NeogitGraphBlue = { fg = colors.blue }
  highlights.NeogitGraphYellow = { fg = colors.yellow }
  highlights.NeogitGraphPurple = { fg = colors.magenta }
  highlights.NeogitGraphCyan = { fg = colors.cyan }
  highlights.NeogitGraphOrange = { fg = colors.yellow_warmer }
  highlights.NeogitGraphGray = { fg = colors.fg_dim }
  highlights.NeogitGraphWhite = { fg = colors.fg_main }

  -- Popup UI
  highlights.NeogitPopupSectionTitle = { fg = colors.blue, bold = true }
  highlights.NeogitPopupBranchName = { fg = colors.magenta }
  highlights.NeogitPopupSwitchKey = { fg = colors.magenta_cooler }
  highlights.NeogitPopupSwitchEnabled = { fg = colors.green }
  highlights.NeogitPopupSwitchDisabled = { fg = colors.fg_dim }
  highlights.NeogitPopupOptionKey = { fg = colors.magenta_cooler }
  highlights.NeogitPopupOptionEnabled = { fg = colors.green }
  highlights.NeogitPopupOptionDisabled = { fg = colors.fg_dim }
  highlights.NeogitPopupActionKey = { fg = colors.magenta_cooler }
  highlights.NeogitPopupActionDisabled = { fg = colors.fg_dim }

  -- Signature verification
  highlights.NeogitSignatureGood = { fg = colors.green }
  highlights.NeogitSignatureBad = { fg = colors.red, bold = true }
  highlights.NeogitSignatureMissing = { fg = colors.magenta }
  highlights.NeogitSignatureNone = { fg = colors.fg_dim }
end

local function set_trouble_highlights(highlights, colors)
  -- Window and text
  highlights.TroubleNormal = { fg = colors.fg_main, bg = colors.bg_dim }
  highlights.TroubleNormalNC = { link = 'TroubleNormal' }
  highlights.TroubleText = { fg = colors.fg_main }
  highlights.TroublePreview = { link = 'Visual' }

  -- File and path display
  highlights.TroubleFilename = { fg = colors.blue }
  highlights.TroubleBasename = { fg = colors.blue }
  highlights.TroubleDirectory = { fg = colors.blue }

  -- Metadata
  highlights.TroubleSource = { fg = colors.fg_dim }
  highlights.TroubleCode = { fg = colors.magenta }
  highlights.TroublePos = { fg = colors.fg_dim }
  highlights.TroubleCount = { fg = colors.magenta, bg = colors.bg_active, bold = true }

  -- Indentation guides
  highlights.TroubleIndent = { fg = colors.fg_dim }
  highlights.TroubleIndentFoldClosed = { fg = colors.blue }
  highlights.TroubleIndentFoldOpen = { fg = colors.fg_dim }
  highlights.TroubleIndentTop = { fg = colors.fg_dim }
  highlights.TroubleIndentMiddle = { fg = colors.fg_dim }
  highlights.TroubleIndentLast = { fg = colors.fg_dim }
  highlights.TroubleIndentWs = { fg = colors.fg_dim }

  -- LSP kind icons (linked to treesitter captures)
  highlights.TroubleIconArray = { link = '@punctuation.bracket' }
  highlights.TroubleIconBoolean = { link = '@boolean' }
  highlights.TroubleIconClass = { link = '@type' }
  highlights.TroubleIconConstant = { link = '@constant' }
  highlights.TroubleIconConstructor = { link = '@constructor' }
  highlights.TroubleIconEnum = { link = '@type' }
  highlights.TroubleIconEnumMember = { link = '@constant' }
  highlights.TroubleIconEvent = { link = 'Special' }
  highlights.TroubleIconField = { link = '@variable.member' }
  highlights.TroubleIconFile = { link = 'Normal' }
  highlights.TroubleIconFunction = { link = '@function' }
  highlights.TroubleIconInterface = { link = '@type' }
  highlights.TroubleIconKey = { link = '@variable.member' }
  highlights.TroubleIconMethod = { link = '@function.method' }
  highlights.TroubleIconModule = { link = '@module' }
  highlights.TroubleIconNamespace = { link = '@module' }
  highlights.TroubleIconNull = { link = '@constant.builtin' }
  highlights.TroubleIconNumber = { link = '@number' }
  highlights.TroubleIconObject = { link = '@constant' }
  highlights.TroubleIconOperator = { link = '@operator' }
  highlights.TroubleIconPackage = { link = '@module' }
  highlights.TroubleIconProperty = { link = '@property' }
  highlights.TroubleIconString = { link = '@string' }
  highlights.TroubleIconStruct = { link = '@type' }
  highlights.TroubleIconTypeParameter = { link = '@type' }
  highlights.TroubleIconVariable = { link = '@variable' }
end

local function set_matchup_highlights(highlights, colors)
  highlights.MatchWord = { bg = colors.bg_paren_match }
  highlights.MatchWordCur = { bg = colors.bg_paren_match }
  highlights.MatchParenCur = { bg = colors.bg_paren_match, bold = true }
end

local function set_mini_jump2d_highlights(highlights, colors)
  highlights.MiniJump2dSpotAhead = { fg = colors.fg_dim, nocombine = true }
  highlights.MiniJump2dSpotUnique = { fg = colors.magenta_cooler, bold = true, nocombine = true }
  highlights.MiniJump2dDim = { fg = colors.fg_dim }
end

local function set_whichkey_highlights(highlights, colors)
  highlights.WhichKeyNormal = { fg = colors.fg_main, bg = colors.bg_dim }
  highlights.WhichKeyBorder = { fg = colors.border, bg = colors.bg_dim }
  highlights.WhichKeyTitle = { fg = colors.blue, bg = colors.bg_dim, bold = true }
  highlights.WhichKeyIcon = { fg = colors.blue }
end

---@module "lazy"
---@type LazySpec
return {
  'miikanissi/modus-themes.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('modus-themes').setup({
      style = 'auto',
      variant = 'default', -- default, tinted, deuteranopia
      transparent = false,
      line_nr_column_background = true,
      on_colors = function(colors)
        -- Override light (operandi) variant background
        -- to light grey instead of pure white
        if colors.bg_main == '#ffffff' then
          colors.bg_main = '#f5f5f5'
        end
        -- Override dark (vivendi) variant background
        -- to slightly lighter black
        if colors.bg_main == '#000000' then
          colors.bg_main = '#141414'
        end
      end,
      on_highlights = function(highlights, colors)
        -- Core UI
        set_indent_blankline_highlights(highlights, colors)
        set_line_number_highlights(highlights, colors)

        -- Fuzzy finder
        set_fzflua_highlights(highlights, colors)

        -- File explorer
        set_nvim_tree_highlights(highlights, colors)

        -- Completion
        set_blink_cmp_highlights(highlights, colors)

        -- Git plugins
        set_diffview_highlights(highlights, colors)
        set_neogit_highlights(highlights, colors)

        -- LSP/Mason
        set_mason_highlights(highlights, colors)

        -- Treesitter
        set_treesitter_context_highlights(highlights, colors)

        -- Diagnostics
        set_trouble_highlights(highlights, colors)

        -- Navigation and UI
        set_matchup_highlights(highlights, colors)
        set_mini_jump2d_highlights(highlights, colors)
        set_whichkey_highlights(highlights, colors)
      end,
    })
    vim.cmd.colorscheme('modus')

    -- Re-enable automatic background detection after initial colorscheme load
    -- (The default TermResponse handler was deleted because we set vim.o.background in init.lua)
    local function parsecolor(c)
      -- Parse a color value (0-65535 range or hex)
      if c:match('^%x+$') then
        local val = tonumber(c, 16)
        if #c == 4 then
          return val / 65535
        elseif #c == 2 then
          return val / 255
        end
      end
      return nil
    end

    vim.api.nvim_create_autocmd('TermResponse', {
      group = vim.api.nvim_create_augroup('modus_background_sync', { clear = true }),
      nested = true,
      desc = 'Update background based on terminal emulator response',
      callback = function(args)
        local resp = args.data.sequence
        local r, g, b = resp:match('^\027%]11;rgb:(%x+)/(%x+)/(%x+)')
        if r and g and b then
          local rr, gg, bb = parsecolor(r), parsecolor(g), parsecolor(b)
          if rr and gg and bb then
            local luminance = (0.299 * rr) + (0.587 * gg) + (0.114 * bb)
            local new_bg = luminance < 0.5 and 'dark' or 'light'
            if vim.o.background ~= new_bg then
              vim.o.background = new_bg
              vim.cmd.colorscheme('modus')
            end
          end
        end
      end,
    })
  end,
}
