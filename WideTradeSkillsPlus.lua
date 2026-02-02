local Config = WideTradeSkillsPlus_Config
local Utils = WideTradeSkillsPlus_Utils
local Professions = WideTradeSkillsPlus_Professions
local Tabs = WideTradeSkillsPlus_Tabs
local UI = WideTradeSkillsPlus_UI
local Minimap = WideTradeSkillsPlus_Minimap
local Options = WideTradeSkillsPlus_Options

local skinUI
local delay

local f = CreateFrame("Frame", "WideTradeSkillsPlus")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("SKILL_LINES_CHANGED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")

f:SetScript("OnEvent", function(self, event, arg1)
  if event == "PLAYER_LOGIN" then
    skinUI = Config.Initialize()
    Tabs.Initialize(skinUI)
    UI.Initialize(skinUI)
    Minimap.Create()
    Tabs.Update(true)
    UI.UpdateSize("TradeSkill")
    UI.RefreshRecipes(TradeSkillFrame)

  elseif event == "ADDON_LOADED" and arg1 == "Blizzard_CraftUI" then
    if Utils.UnitAffectingCombat("player") then
      delay = true
    else
      Tabs.Update()
    end
    UI.UpdateSize("Craft")
    UI.RefreshRecipes(CraftFrame)
    CraftFrame:HookScript("OnShow", UI.SwitchPanel)
    TradeSkillFrame:HookScript("OnShow", UI.SwitchPanel)
    f:UnregisterEvent("ADDON_LOADED")

  elseif event == "SKILL_LINES_CHANGED" then
    Minimap.UpdateIcon()
    if Tabs.GetNumTabs() > 0 then
      if Utils.UnitAffectingCombat("player") then
        delay = true
      else
        Tabs.Update()
      end
    end

  elseif event == "PLAYER_REGEN_ENABLED" and delay then
    Tabs.Update()
    delay = false
  end
end)

Options.Create()
