local Minimap = {}
local Utils = WideTradeSkillsPlus_Utils
local Professions = WideTradeSkillsPlus_Professions

local minimapButton = nil
local MinimapFrame = _G.Minimap

local function getMinimapButtonPosition(angle)
  local radius = 80
  local x = cos(angle) * radius
  local y = sin(angle) * radius
  return x, y
end

local function updateMinimapIcon()
  if not minimapButton then return end

  local mainTabs = Professions.GetProfessions()
  if mainTabs[1] then
    local _, _, icon = Utils.GetSpellInfo(mainTabs[1])
    minimapButton.icon:SetTexture(icon or "Interface\\Icons\\INV_Misc_Gear_01")
    minimapButton.icon:SetDesaturated(false)
  else
    minimapButton.icon:SetTexture("Interface\\Icons\\INV_Misc_Gear_01")
    minimapButton.icon:SetDesaturated(true)
  end
end

function Minimap.Create()
  minimapButton = CreateFrame("Button", "WTSPlusMinimapButton", MinimapFrame)
  minimapButton:SetSize(32, 32)
  minimapButton:SetFrameStrata("MEDIUM")
  minimapButton:SetFrameLevel(8)
  minimapButton:EnableMouse(true)
  minimapButton:SetMovable(true)
  minimapButton:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp")
  minimapButton:RegisterForDrag("LeftButton")

  minimapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

  local overlay = minimapButton:CreateTexture(nil, "OVERLAY")
  overlay:SetSize(53, 53)
  overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
  overlay:SetPoint("TOPLEFT")

  local background = minimapButton:CreateTexture(nil, "BACKGROUND")
  background:SetSize(24, 24)
  background:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
  background:SetPoint("CENTER", 0, 0)

  local icon = minimapButton:CreateTexture(nil, "ARTWORK")
  icon:SetSize(18, 18)
  icon:SetTexture("Interface\\Icons\\INV_Misc_Gear_01")
  icon:SetPoint("CENTER", 0, 2)
  minimapButton.icon = icon

  local function updatePosition()
    local x, y = getMinimapButtonPosition(WTSPlusDB.Minimap.position)
    minimapButton:ClearAllPoints()
    minimapButton:SetPoint("CENTER", MinimapFrame, "CENTER", x, y)
  end

  minimapButton:SetScript("OnDragStart", function(self)
    self.isDragging = true
  end)

  minimapButton:SetScript("OnDragStop", function(self)
    self.isDragging = false
  end)

  minimapButton:SetScript("OnUpdate", function(self)
    if self.isDragging then
      local mx, my = MinimapFrame:GetCenter()
      local cx, cy = GetCursorPosition()
      local scale = MinimapFrame:GetEffectiveScale()
      cx, cy = cx / scale, cy / scale
      WTSPlusDB.Minimap.position = atan2(cy - my, cx - mx)
      updatePosition()
    end
  end)

  minimapButton:SetScript("OnClick", function(self, button)
    local mainTabs = Professions.GetProfessions()
    if not mainTabs[1] then return end

    if button == "LeftButton" then
      CastSpellByID(mainTabs[1])
    elseif button == "RightButton" then
      CastSpellByID(mainTabs[2] or mainTabs[1])
    elseif button == "MiddleButton" then
      WTSPlusDB.Minimap.show = false
      self:Hide()
    end
  end)

  minimapButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("WideTradeSkillsPlus")
    GameTooltip:AddLine(" ")

    local mainTabs = Professions.GetProfessions()
    local name1 = mainTabs[1] and Utils.GetSpellInfo(mainTabs[1]) or "|cff888888not learned yet|r"
    local name2 = mainTabs[2] and Utils.GetSpellInfo(mainTabs[2]) or "|cff888888not learned yet|r"
    GameTooltip:AddLine("|cff00ff00Left-click:|r " .. name1)
    GameTooltip:AddLine("|cff00ff00Right-click:|r " .. name2)
    GameTooltip:AddLine("|cff00ff00Middle-click:|r Hide button")
    GameTooltip:AddLine("|cff00ff00Drag:|r Move")
    GameTooltip:Show()
  end)

  minimapButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)

  updatePosition()
  updateMinimapIcon()

  if WTSPlusDB.Minimap.show then
    minimapButton:Show()
  else
    minimapButton:Hide()
  end
end

function Minimap.UpdateIcon()
  updateMinimapIcon()
end

function Minimap.GetButton()
  return minimapButton
end

WideTradeSkillsPlus_Minimap = Minimap
