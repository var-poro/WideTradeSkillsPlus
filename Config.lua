local Config = {}

local IsAddOnLoaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or _G.IsAddOnLoaded

function Config.Initialize()
  WTSPlusDB = WTSPlusDB or {}
  WTSPlusDB.Tabs = WTSPlusDB.Tabs or {}
  WTSPlusDB.Minimap = WTSPlusDB.Minimap or {
    show = true,
    position = 220,
  }

  local skinUI
  if IsAddOnLoaded("Aurora") then
    skinUI = "Aurora"
  elseif IsAddOnLoaded("ElvUI") then
    skinUI = "ElvUI"
  end

  return skinUI
end

WideTradeSkillsPlus_Config = Config
