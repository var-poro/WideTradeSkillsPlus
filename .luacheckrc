-- Luacheck configuration for WideTradeSkillsPlus WoW addon

-- Standard Lua globals (minimal set, we'll add what we need)
std = "min"

-- Lua standard library functions used
read_globals = {
    -- Core WoW API
    "CreateFrame",
    "GetSpellInfo",
    "GetNumSkillLines",
    "GetSkillLineInfo",
    "IsAddOnLoaded",
    "UnitAffectingCombat",
    "IsCurrentSpell",
    "IsPassiveSpell",
    "CloseTradeSkill",
    "CloseCraft",
    "hooksecurefunc",
    "FauxScrollFrame_GetOffset",
    "FauxScrollFrame_OnVerticalScroll",
    "GetAddOnMetadata",
    "UnitClass",
    "IsUsableSpell",
    "GetTradeSkillLine",
    "GetCraftDisplaySkillLine",
    "GetNumTradeSkills",
    "GetTradeSkillInfo",
    "GetNumCrafts",
    "GetCraftInfo",
    "GetTradeSkillSelectionIndex",
    "GetCraftSelectionIndex",
    "GetTradeSkillDisplaySkillLine",
    "TradeSkillFrame_Update",
    "CraftFrame_Update",
    "TradeSkillFrame_SetSelection",
    "CraftFrame_SetSelection",
    "FauxScrollFrame_Update",
    "GetCursorPosition",
    "CastSpellByID",
    "Settings",
    "Settings.RegisterCanvasLayoutCategory",
    "Settings.RegisterAddOnCategory",
    
    -- WoW frames
    "TradeSkillFrame",
    "CraftFrame",
    "Minimap",
    "GameTooltip",
    
    -- WoW constants and addon globals
    "C_AddOns",
    "Aurora",
    "ElvUI",
    
    -- Math functions (Lua standard)
    "cos",
    "sin",
    "atan2",
    
    -- Lua standard library functions
    "select",
    "unpack",
    "pairs",
    "ipairs",
    "type",
    "tostring",
    "tonumber",
    "error",
    "pcall",
    "xpcall",
    
    -- WoW global variables that may be set
    "TRADE_SKILLS_DISPLAYED",
    "CRAFTS_DISPLAYED",
    "ClassicProfessionFilterSearchBoxMixIn",
    
    -- Module namespaces (read-only access)
    "WideTradeSkillsPlus_Config",
    "WideTradeSkillsPlus_Utils",
    "WideTradeSkillsPlus_Professions",
    "WideTradeSkillsPlus_Tabs",
    "WideTradeSkillsPlus_UI",
    "WideTradeSkillsPlus_Minimap",
    "WideTradeSkillsPlus_Options",
}

-- Globals that can be written to
globals = {
    "WTSPlusDB",
    -- Module namespaces (can be written during initialization)
    "WideTradeSkillsPlus_Config",
    "WideTradeSkillsPlus_Utils",
    "WideTradeSkillsPlus_Professions",
    "WideTradeSkillsPlus_Tabs",
    "WideTradeSkillsPlus_UI",
    "WideTradeSkillsPlus_Minimap",
    "WideTradeSkillsPlus_Options",
}

-- Ignore unused arguments in callbacks
unused_args = false

-- Allow unused variables that start with underscore
ignore = {
    "212", -- unused argument
}

-- Files to check
files = {
    "*.lua",
}

-- Exclude patterns
exclude_files = {
    "*.toc",
}
