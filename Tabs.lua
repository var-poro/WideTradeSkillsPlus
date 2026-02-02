local Tabs = {}
local Utils = WideTradeSkillsPlus_Utils
local Professions = WideTradeSkillsPlus_Professions

local numTabs = 0
local skinUI

function Tabs.Initialize(skinUIValue)
  skinUI = skinUIValue
end

local function updateTabState(self)
  local frame = self:GetParent()
  if frame == CraftFrame and not Utils.UnitAffectingCombat("player") then
    local profEnchantName = Professions.GetEnchantSpellName()
    if profEnchantName and not Utils.IsCurrentSpell(profEnchantName) then
      self:Hide()
      return
    else
      self:Show()
    end
  end

  if self.id and Utils.IsCurrentSpell(self.id) then
    self:SetChecked(true)
    self:RegisterForClicks()
  else
    self:SetChecked(false)
    self:RegisterForClicks("AnyDown")
  end
end

local function addTab(id, index, isSub, frame)
  local name, _, icon = Utils.GetSpellInfo(id)
  if not (name and icon) then return end

  local tabName = "WTSPlusTab-" .. frame:GetName() .. "_" .. index
  local tab = Utils._G[tabName] or CreateFrame("CheckButton", tabName, frame, "SpellBookSkillLineTabTemplate, SecureActionButtonTemplate")
  tab:SetScript("OnEvent", updateTabState)
  tab:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")
  tab.id = id
  tab.isSub = isSub
  tab.tooltip = name
  tab:SetNormalTexture(icon)
  tab:SetAttribute("type", "spell")
  tab:SetAttribute("spell", id)
  updateTabState(tab)

  if skinUI and not tab.skinned then
    local checkedTexture
    if skinUI == "Aurora" then
      checkedTexture = "Interface\\AddOns\\Aurora\\media\\CheckButtonHilight"
    elseif skinUI == "ElvUI" then
      checkedTexture = tab:CreateTexture(nil, "HIGHLIGHT")
      checkedTexture:SetColorTexture(1, 1, 1, 0.3)
      checkedTexture:SetInside()
      tab:SetHighlightTexture("")
    end
    tab:SetCheckedTexture(checkedTexture)
    tab:GetNormalTexture():SetTexCoord(0.08, 0.92, 0.08, 0.92)
    tab:GetRegions():Hide()
    tab.skinned = true
  end
end

local function removeTabs()
  for _, frame in pairs({TradeSkillFrame, CraftFrame}) do
    for i = 1, numTabs do
      local tab = Utils._G["WTSPlusTab-" .. frame:GetName() .. "_" .. i]
      if tab and tab:IsShown() then
        tab:UnregisterEvent("CURRENT_SPELL_CAST_CHANGED")
        tab:Hide()
      end
    end
  end
end

local function sortTabs()
  local horizontalOffset = skinUI and -33 or -34
  local verticalSpacing = 50
  local bottomMargin = 100

  local mainTabs, subTabs = Professions.GetProfessions()
  local primaryCount = #mainTabs

  for _, frame in pairs({TradeSkillFrame, CraftFrame}) do
    local primaryIndex = 1
    for i = 1, primaryCount do
      local tab = Utils._G["WTSPlusTab-" .. frame:GetName() .. "_" .. i]
      if tab then
        local yOffset = -verticalSpacing * primaryIndex
        tab:ClearAllPoints()
        tab:SetPoint("TOPLEFT", frame, "TOPRIGHT", horizontalOffset, yOffset)
        tab:Show()
        primaryIndex = primaryIndex + 1
      end
    end

    local subIndex = 1
    for i = primaryCount + 1, primaryCount + #subTabs do
      local tab = Utils._G["WTSPlusTab-" .. frame:GetName() .. "_" .. i]
      if tab then
        local yOffset = bottomMargin + (verticalSpacing * (subIndex - 1))
        tab:ClearAllPoints()
        tab:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", horizontalOffset, yOffset)
        tab:Show()
        subIndex = subIndex + 1
      end
    end
  end
end

function Tabs.Update(init)
  local mainTabs, subTabs = Professions.GetProfessions()

  local _, playerClass = UnitClass("player")
  if playerClass == "ROGUE" and IsUsableSpell(1804) then
    Utils.tinsert(subTabs, 1804)
  end

  local totalTabs = #mainTabs + #subTabs
  numTabs = totalTabs

  removeTabs()
  for i = 1, numTabs do
    local id = mainTabs[i] or subTabs[i - #mainTabs]
    addTab(id, i, mainTabs[i] and 0 or 1, TradeSkillFrame)
    if CraftFrame then
      addTab(id, i, mainTabs[i] and 0 or 1, CraftFrame)
    end
  end
  sortTabs()
end

function Tabs.GetNumTabs()
  return numTabs
end

WideTradeSkillsPlus_Tabs = Tabs
