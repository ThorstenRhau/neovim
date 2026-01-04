-- https://github.com/miikanissi/modus-themes.nvim/
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
        -- Make indent lines subtle but visible
        highlights.IblIndent = { fg = colors.bg_active, nocombine = true }
        highlights.IblScope = { fg = colors.cyan_faint, nocombine = true }

        if colors.bg_main == '#f5f5f5' then
          -- Light mode color tweaks
          highlights.LineNrAbove = { fg = colors.fg_dim, bg = '#efefef' }
          highlights.LineNr = { fg = colors.fg_main, bg = '#efefef' }
          highlights.LineNrBelow = { fg = colors.fg_dim, bg = '#efefef' }
          highlights.SignColumn = { bg = '#efefef' }
        elseif colors.bg_main == '#141414' then
          -- Dark mode color tweaks
          highlights.LineNrAbove = { fg = colors.fg_dim, bg = '#242424' }
          highlights.LineNr = { fg = colors.fg_main, bg = '#242424' }
          highlights.LineNrBelow = { fg = colors.fg_dim, bg = '#242424' }
          highlights.SignColumn = { bg = '#242424' }
        end

        -- Blink.cmp completion menu
        highlights.BlinkCmpMenu = { bg = colors.bg_dim }
        highlights.BlinkCmpMenuBorder = { fg = colors.border, bg = colors.bg_dim }
        highlights.BlinkCmpMenuSelection = { bg = colors.bg_active }
        highlights.BlinkCmpScrollBarThumb = { bg = colors.fg_dim }
        highlights.BlinkCmpScrollBarGutter = { bg = colors.bg_dim }
        highlights.BlinkCmpLabel = { fg = colors.fg_main }
        highlights.BlinkCmpLabelDeprecated = { fg = colors.fg_dim, strikethrough = true }
        highlights.BlinkCmpLabelMatch = { fg = colors.blue, bold = true }
        highlights.BlinkCmpLabelDetail = { fg = colors.fg_dim }
        highlights.BlinkCmpLabelDescription = { fg = colors.fg_dim }
        highlights.BlinkCmpKind = { fg = colors.magenta }
        highlights.BlinkCmpSource = { fg = colors.fg_dim }
        highlights.BlinkCmpGhostText = { fg = colors.fg_dim, italic = true }
        highlights.BlinkCmpDoc = { bg = colors.bg_dim }
        highlights.BlinkCmpDocBorder = { fg = colors.border, bg = colors.bg_dim }

        -- LSP kind colors
        highlights.BlinkCmpKindFunction = { fg = colors.magenta }
        highlights.BlinkCmpKindMethod = { fg = colors.magenta }
        highlights.BlinkCmpKindConstructor = { fg = colors.magenta }
        highlights.BlinkCmpKindVariable = { fg = colors.cyan }
        highlights.BlinkCmpKindField = { fg = colors.cyan }
        highlights.BlinkCmpKindProperty = { fg = colors.cyan }
        highlights.BlinkCmpKindClass = { fg = colors.yellow }
        highlights.BlinkCmpKindInterface = { fg = colors.yellow }
        highlights.BlinkCmpKindStruct = { fg = colors.yellow }
        highlights.BlinkCmpKindModule = { fg = colors.yellow }
        highlights.BlinkCmpKindKeyword = { fg = colors.blue }
        highlights.BlinkCmpKindSnippet = { fg = colors.green }
        highlights.BlinkCmpKindText = { fg = colors.fg_main }
        highlights.BlinkCmpKindConstant = { fg = colors.blue_cooler }
        highlights.BlinkCmpKindEnum = { fg = colors.yellow }
        highlights.BlinkCmpKindEnumMember = { fg = colors.cyan }
        highlights.BlinkCmpKindValue = { fg = colors.cyan }
        highlights.BlinkCmpKindFile = { fg = colors.blue }
        highlights.BlinkCmpKindFolder = { fg = colors.blue }

        -- nvim-dap-ui
        highlights.DapUIScope = { fg = colors.cyan }
        highlights.DapUIType = { fg = colors.magenta }
        highlights.DapUIValue = { fg = colors.fg_main }
        highlights.DapUIModifiedValue = { fg = colors.cyan, bold = true }
        highlights.DapUIDecoration = { fg = colors.cyan }
        highlights.DapUIThread = { fg = colors.green }
        highlights.DapUIStoppedThread = { fg = colors.cyan }
        highlights.DapUISource = { fg = colors.magenta }
        highlights.DapUILineNumber = { fg = colors.fg_dim }
        highlights.DapUIFloatBorder = { fg = colors.cyan }
        highlights.DapUIWatchesEmpty = { fg = colors.red }
        highlights.DapUIWatchesValue = { fg = colors.green }
        highlights.DapUIWatchesError = { fg = colors.red }
        highlights.DapUIBreakpointsPath = { fg = colors.cyan }
        highlights.DapUIBreakpointsInfo = { fg = colors.green }
        highlights.DapUIBreakpointsCurrentLine = { fg = colors.green, bold = true }
        highlights.DapUIBreakpointsDisabledLine = { fg = colors.fg_dim }
        highlights.DapUIStepOver = { fg = colors.cyan }
        highlights.DapUIStepInto = { fg = colors.cyan }
        highlights.DapUIStepBack = { fg = colors.cyan }
        highlights.DapUIStepOut = { fg = colors.cyan }
        highlights.DapUIStop = { fg = colors.red }
        highlights.DapUIPlayPause = { fg = colors.green }
        highlights.DapUIRestart = { fg = colors.green }
        highlights.DapUIUnavailable = { fg = colors.fg_dim }

        -- diffview.nvim
        highlights.DiffviewFilePanelTitle = { fg = colors.blue, bold = true }
        highlights.DiffviewFilePanelCounter = { fg = colors.magenta, bold = true }
        highlights.DiffviewFilePanelFileName = { fg = colors.fg_main }
        highlights.DiffviewFilePanelSelected = { fg = colors.magenta }
        highlights.DiffviewFilePanelPath = { fg = colors.fg_dim }
        highlights.DiffviewFilePanelInsertions = { fg = colors.green }
        highlights.DiffviewFilePanelDeletions = { fg = colors.red }
        highlights.DiffviewFilePanelConflicts = { fg = colors.yellow }
        highlights.DiffviewFolderName = { fg = colors.blue }
        highlights.DiffviewFolderSign = { fg = colors.blue }
        highlights.DiffviewHash = { fg = colors.magenta }
        highlights.DiffviewReference = { fg = colors.cyan }
        highlights.DiffviewStatusAdded = { fg = colors.green }
        highlights.DiffviewStatusModified = { fg = colors.yellow }
        highlights.DiffviewStatusRenamed = { fg = colors.yellow }
        highlights.DiffviewStatusDeleted = { fg = colors.red }
        highlights.DiffviewStatusUntracked = { fg = colors.green }
        highlights.DiffviewStatusIgnored = { fg = colors.fg_dim }
        highlights.DiffviewDim1 = { fg = colors.fg_dim }
        highlights.DiffviewPrimary = { fg = colors.blue }
        highlights.DiffviewSecondary = { fg = colors.cyan }

        -- oil.nvim
        highlights.OilDir = { fg = colors.blue, bold = true }
        highlights.OilDirIcon = { fg = colors.blue }
        highlights.OilSocket = { fg = colors.magenta }
        highlights.OilLink = { fg = colors.cyan }
        highlights.OilOrphanLink = { fg = colors.red }
        highlights.OilLinkTarget = { fg = colors.fg_dim }
        highlights.OilOrphanLinkTarget = { fg = colors.red }
        highlights.OilFile = { fg = colors.fg_main }
        highlights.OilCreate = { fg = colors.green }
        highlights.OilDelete = { fg = colors.red }
        highlights.OilMove = { fg = colors.yellow }
        highlights.OilCopy = { fg = colors.cyan }
        highlights.OilChange = { fg = colors.yellow }
        highlights.OilTrash = { fg = colors.red }
        highlights.OilTrashSourcePath = { fg = colors.fg_dim }

        -- mason.nvim
        highlights.MasonHeader = { fg = colors.bg_main, bg = colors.blue, bold = true }
        highlights.MasonHeaderSecondary = { fg = colors.bg_main, bg = colors.cyan, bold = true }
        highlights.MasonHighlight = { fg = colors.cyan }
        highlights.MasonHighlightBlock = { fg = colors.bg_main, bg = colors.cyan }
        highlights.MasonHighlightBlockBold = { fg = colors.bg_main, bg = colors.cyan, bold = true }
        highlights.MasonHighlightSecondary = { fg = colors.yellow }
        highlights.MasonHighlightBlockSecondary = { fg = colors.bg_main, bg = colors.yellow }
        highlights.MasonMuted = { fg = colors.fg_dim }
        highlights.MasonMutedBlock = { fg = colors.bg_main, bg = colors.fg_dim }
      end,
    })
    vim.cmd.colorscheme('modus')
  end,
}
