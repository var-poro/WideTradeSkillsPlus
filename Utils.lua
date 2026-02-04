local Utils = {}

Utils.tinsert = table.insert
Utils._G = _G
Utils.GetSpellInfo = GetSpellInfo
Utils.GetNumSkillLines = GetNumSkillLines
Utils.GetSkillLineInfo = GetSkillLineInfo
Utils.IsAddOnLoaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or _G.IsAddOnLoaded
Utils.UnitAffectingCombat = UnitAffectingCombat
Utils.IsCurrentSpell = IsCurrentSpell
Utils.IsPassiveSpell = IsPassiveSpell
Utils.CloseTradeSkill = CloseTradeSkill
Utils.CloseCraft = CloseCraft
Utils.hooksecurefunc = hooksecurefunc
Utils.FauxScrollFrame_GetOffset = FauxScrollFrame_GetOffset
Utils.GetAddOnMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or _G.GetAddOnMetadata

Utils.DISPLAY_SIZE = 22

WideTradeSkillsPlus_Utils = Utils
