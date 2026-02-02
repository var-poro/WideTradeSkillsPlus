local UI = {}
local Utils = WideTradeSkillsPlus_Utils

local skinUI

function UI.Initialize(skinUIValue)
  skinUI = skinUIValue
end

function UI.UpdateSize(frame)
  if frame == "TradeSkill"
     and GetTradeSkillDisplaySkillLine
     and GetTradeSkillDisplaySkillLine() == "Beast Training" then
    return
  end

  local mainFrame = Utils._G[frame .. "Frame"]
  mainFrame:SetWidth(714)
  mainFrame:SetHeight(skinUI and 512 or 487)

  local detailScroll = Utils._G[frame .. "DetailScrollFrame"]
  detailScroll:ClearAllPoints()
  detailScroll:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 362, -92)
  detailScroll:SetSize(296, 332)
  Utils._G[frame .. "DetailScrollFrameTop"]:SetAlpha(0)
  Utils._G[frame .. "DetailScrollFrameBottom"]:SetAlpha(0)

  local listScroll = Utils._G[frame .. "ListScrollFrame"]
  listScroll:ClearAllPoints()
  if frame == "Craft" then
    listScroll:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 23.8, -74.3)
    listScroll:SetSize(296, 357)
  else
    listScroll:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 23.8, -99)
    listScroll:SetSize(296, 332)
  end

  if not Utils.IsAddOnLoaded("Aurora") and not Utils.IsAddOnLoaded("ElvUI") then
    local scrollFix = listScroll:CreateTexture(nil, "BACKGROUND")
    scrollFix:SetPoint("TOPRIGHT", listScroll, "TOPRIGHT", 28.9, -110)
    scrollFix:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-ScrollBar")
    scrollFix:SetTexCoord(0, 0.5, 0.2, 0.9)
    scrollFix:SetSize(32, 0)
  end

  local regions = { mainFrame:GetRegions() }
  if not Utils.IsAddOnLoaded("Aurora") and not Utils.IsAddOnLoaded("ElvUI") then
    regions[2]:SetTexture("Interface\\QuestFrame\\UI-QuestLogDualPane-Left")
    regions[2]:SetSize(512, 512)

    regions[3]:ClearAllPoints()
    regions[3]:SetPoint("TOPLEFT", regions[2], "TOPRIGHT")
    regions[3]:SetTexture("Interface\\QuestFrame\\UI-QuestLogDualPane-Right")
    regions[3]:SetSize(256, 512)

    regions[4]:Hide()
    regions[5]:Hide()
  end
  if regions[9] then regions[9]:Hide() end
  if regions[10] then regions[10]:Hide() end

  if not Utils.IsAddOnLoaded("Aurora") and not Utils.IsAddOnLoaded("ElvUI") then
    local recipeInset = mainFrame:CreateTexture(nil, "ARTWORK")
    recipeInset:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 16.3, -72)
    recipeInset:SetTexture("Interface\\RaidFrame\\UI-RaidFrame-GroupBg")
    recipeInset:SetSize(326.5, 360.8)

    local detailsInset = mainFrame:CreateTexture(nil, "ARTWORK")
    detailsInset:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 349, -73)
    detailsInset:SetAtlas("tradeskill-background-recipe")
    detailsInset:SetSize(324, 339)
  end

  Utils._G[frame .. "ExpandTabLeft"]:Hide()

  local cancelButton = Utils._G[frame .. "CancelButton"]
  cancelButton:ClearAllPoints()
  cancelButton:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", -40, skinUI and 79 or 54)
  local createButton = Utils._G[frame .. "CreateButton"]
  createButton:ClearAllPoints()
  createButton:SetPoint("RIGHT", cancelButton, "LEFT", -1, 0)

  if frame == "Craft" then
    CraftFramePointsLabel:ClearAllPoints()
    CraftFramePointsLabel:SetPoint("RIGHT", CraftCreateButton, "LEFT", -55, 0)
    CraftFramePointsText:ClearAllPoints()
    CraftFramePointsText:SetPoint("LEFT", CraftFramePointsLabel, "RIGHT", 5, 0)
  end

  if frame == "TradeSkill" then
    TradeSkillInvSlotDropdown:ClearAllPoints()
    TradeSkillInvSlotDropdown:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 200, -50)
    TradeSkillInvSlotDropdown:SetWidth(160)
    TradeSkillSubClassDropdown:ClearAllPoints()
    TradeSkillSubClassDropdown:SetPoint("TOPRIGHT", TradeSkillInvSlotDropdown, "TOPLEFT", -6, 0)
    TradeSkillSubClassDropdown:SetWidth(160)

    if TradeSkillFrameAvailableFilterCheckButton then
      TradeSkillFrameAvailableFilterCheckButton:ClearAllPoints()
      TradeSkillFrameAvailableFilterCheckButton:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 320, -72)

      local text = TradeSkillFrameAvailableFilterCheckButtonText
      if text then
        text:ClearAllPoints()
        text:SetPoint("RIGHT", TradeSkillFrameAvailableFilterCheckButton, "LEFT", -2, 0)
      end
    end
  end

  local skillButton
  if frame == "Craft" then
    skillButton = "Craft"
    CRAFTS_DISPLAYED = Utils.DISPLAY_SIZE
  else
    skillButton = "TradeSkillSkill"
    TRADE_SKILLS_DISPLAYED = Utils.DISPLAY_SIZE
  end

  for i = 1, Utils.DISPLAY_SIZE do
    local button = Utils._G[skillButton .. i] or CreateFrame("Button", skillButton .. i, mainFrame, skillButton .. "ButtonTemplate")
    if i > 1 then
      button:ClearAllPoints()
      button:SetPoint("TOPLEFT", Utils._G[skillButton .. (i - 1)], "BOTTOMLEFT", 0, 1)
    end
  end
end

function UI.RefreshRecipes(frame)
end

function UI.SwitchPanel(self)
  local frameName = self:GetName()
  if frameName == "CraftFrame" and CraftFrame:IsShown() then
    Utils.CloseTradeSkill()
  else
    Utils.CloseCraft()
  end
end

WideTradeSkillsPlus_UI = UI
