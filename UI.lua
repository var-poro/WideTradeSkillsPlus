local UI = {}
local Utils = WideTradeSkillsPlus_Utils
local Favorites

local skinUI
local customListFrame = {}
local customListLayout = {
  buttonHeight = 16,
  buttonWidth = 310,
  topLeftX = 5,
  topLeftY = 3,
  highlightLeftOffset = -7,
  highlightRightOffset = 0,
  highlightRightOffsetWithScroll = -24,
  textX = 18,
  textY = 1,
  textDownX = 19,
  textDownY = -1,
  levelX = 17,
  levelY = 2,
  levelDownX = 18,
  levelDownY = 0,
  favoriteSize = 20,
  favoriteX = -4,
  favoriteY = -1,
}
local filterState = {
  TradeSkill = {
    profession = nil,
    expandedHeaders = nil,
  },
  Craft = {
    profession = nil,
    expandedHeaders = nil,
  },
}
local isFilterActive = {
  TradeSkill = false,
  Craft = false,
}

function UI.Initialize(skinUIValue)
  skinUI = skinUIValue
  Favorites = WideTradeSkillsPlus_Favorites
end

function UI.ApplyCustomListHighlight(button, rightOffset)
  local offset = rightOffset
  if offset == nil then
    offset = customListLayout.highlightRightOffset
  end

  button.selection:ClearAllPoints()
  button.selection:SetPoint("TOPLEFT", button, "TOPLEFT", customListLayout.highlightLeftOffset, 0)
  button.selection:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", offset, 0)
end

function UI.ApplyCustomListTextOffsets(button, isPressed)
  local textX = customListLayout.textX
  local textY = customListLayout.textY
  local levelX = customListLayout.levelX
  local levelY = customListLayout.levelY

  if isPressed then
    textX = customListLayout.textDownX
    textY = customListLayout.textDownY
    levelX = customListLayout.levelDownX
    levelY = customListLayout.levelDownY
  end

  if button.text then
    button.text:ClearAllPoints()
    button.text:SetPoint("LEFT", button, "LEFT", textX, textY)
  end

  if button.levelText then
    button.levelText:ClearAllPoints()
    button.levelText:SetPoint("RIGHT", button, "LEFT", levelX, levelY)
  end
end

function UI.SkinCustomScrollBar(scrollFrame, frameType)
  local scrollBar = scrollFrame.ScrollBar or Utils._G[scrollFrame:GetName() .. "ScrollBar"]
  if not scrollBar then
    return
  end

  if scrollBar.WTSPlusSkinned then
    return
  end

local decoration = CreateFrame("Frame", nil, scrollBar)
decoration:SetSize(25, 356)
decoration:SetPoint("TOPRIGHT", scrollBar, "TOPRIGHT", 0, 38)

local topTexture = decoration:CreateTexture(nil, "ARTWORK")
topTexture:SetAtlas("macropopup-scrollbar-top", true)
topTexture:SetPoint("TOPLEFT", scrollBar, "TOPLEFT", -9, 21)

local middleTexture = decoration:CreateTexture(nil, "ARTWORK")
middleTexture:SetPoint("TOPLEFT", scrollBar, "TOPLEFT", -6, 20)
middleTexture:SetAtlas("!macropopup-scrollbar-middle", true)
middleTexture:SetSize(26, 320)

local bottomTexture = decoration:CreateTexture(nil, "ARTWORK")

bottomTexture:SetAtlas("macropopup-scrollbar-bottom", true)
bottomTexture:SetPoint("BOTTOMLEFT", scrollBar, "BOTTOMLEFT", -8, -18)

  scrollBar.WTSPlusSkinned = true
end

function UI.GetFrameTypeInfo(frameType)
  if frameType == "TradeSkill" then
    return {
      getNumSkills = GetNumTradeSkills,
      getSkillInfo = GetTradeSkillInfo,
      getSelectionIndex = GetTradeSkillSelectionIndex,
      setSelection = TradeSkillFrame_SetSelection,
      isTradeSkill = true,
    }
  end

  return {
    getNumSkills = GetNumCrafts,
    getSkillInfo = GetCraftInfo,
    getSelectionIndex = GetCraftSelectionIndex,
    setSelection = CraftFrame_SetSelection,
    isTradeSkill = false,
  }
end

function UI.BuildFavoritesList(frameType, profession)
  local info = UI.GetFrameTypeInfo(frameType)
  local favoritesList = {}
  local numSkills = info.getNumSkills()

  for i = 1, numSkills do
    local name, skillType, numAvailable, level
    if info.isTradeSkill then
      name, skillType, numAvailable, _, _, _, level = info.getSkillInfo(i)
    else
      name, _, skillType, numAvailable = info.getSkillInfo(i)
      level = 0
    end

    if name and skillType ~= "header" and Favorites.IsFavorite(profession, name) then
      Utils.tinsert(favoritesList, {
        name = name,
        index = i,
        numAvailable = numAvailable or 0,
        level = level or 0,
        profession = profession,
        skillType = skillType,
      })
    end
  end

  return favoritesList
end

function UI.ExpandAllHeaders(frameType)
  if frameType == "TradeSkill" then
    if ExpandTradeSkillSubClass then
      ExpandTradeSkillSubClass(0)
    end
  elseif ExpandCraftSubClass then
    ExpandCraftSubClass(0)
  end
end

function UI.PrepareFilterHeaders(frameType)
  UI.ExpandAllHeaders(frameType)
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
    listScroll.WTSPlusScrollFix = scrollFix
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

  local barNames = {
    frame .. "HorizontalBar",
    frame .. "HorizontalBarLeft",
    frame .. "HorizontalBarRight",
    frame .. "HorizontalBarMiddle",
    frame .. "HorizontalBarCenter",
    frame .. "HorizontalBarMid",
    frame .. "FrameHorizontalBar",
    frame .. "FrameHorizontalBarLeft",
    frame .. "FrameHorizontalBarRight",
    frame .. "FrameHorizontalBarMiddle",
    frame .. "FrameHorizontalBarCenter",
    frame .. "FrameHorizontalBarMid",
  }
  for _, name in ipairs(barNames) do
    local bar = Utils._G[name]
    if bar then
      bar:Hide()
    end
  end

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
        local width = text:GetStringWidth() or 0
        TradeSkillFrameAvailableFilterCheckButton:SetHitRectInsets(-(width + 6), 0, 0, 0)
      end
    end

    UI.CreateFavoritesFilterCheckbox(mainFrame, "TradeSkill")
  end

  if frame == "Craft" then
    UI.CreateFavoritesFilterCheckbox(mainFrame, "Craft")
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

  UI.CreateCustomList(frame)
end

function UI.RefreshRecipes(frame)
  if frame:GetName() == "TradeSkillFrame"
     and GetTradeSkillDisplaySkillLine
     and GetTradeSkillDisplaySkillLine() == "Beast Training" then
    return
  end

  local frameType = frame == TradeSkillFrame and "TradeSkill" or "Craft"

  frame:HookScript("OnShow", function()
    UI.SyncFilterState(frameType)
  end)

  local function hookFrame()
    if not frame or not frame:IsShown() then
      return
    end

    if isFilterActive[frameType] then
      UI.HideOriginalList(frameType)
      UI.UpdateCustomList(frameType)
      return
    end

    local skillButton, scrollFrame, getSkillInfo, getNumSkills
    if frame == TradeSkillFrame then
      skillButton = "TradeSkillSkill"
      scrollFrame = TradeSkillListScrollFrame
      getSkillInfo = GetTradeSkillInfo
      getNumSkills = GetNumTradeSkills
    elseif frame == CraftFrame then
      skillButton = "Craft"
      scrollFrame = CraftListScrollFrame
      getSkillInfo = GetCraftInfo
      getNumSkills = GetNumCrafts
    end

    local profession = Favorites.GetCurrentProfession(frameType)
    local totalSkills = getNumSkills and getNumSkills() or 0
    local selectionIndex
    local selectionName
    if frameType == "TradeSkill" then
      selectionIndex = GetTradeSkillSelectionIndex and GetTradeSkillSelectionIndex() or 0
    else
      selectionIndex = GetCraftSelectionIndex and GetCraftSelectionIndex() or 0
    end
    if selectionIndex > 0 and getSkillInfo then
      selectionName = getSkillInfo(selectionIndex)
    end

    for i = 1, Utils.DISPLAY_SIZE do
      local button = Utils._G[skillButton .. i]
      if button then
        if not button.WTSPlusLevel then
          button.WTSPlusLevel = button:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
          button.WTSPlusLevel:SetPoint("RIGHT", button, "LEFT", 20, 2)
        end

        if not button.WTSPlusFavorite then
          button.WTSPlusFavorite = CreateFrame("Button", nil, button)
          button.WTSPlusFavorite:SetSize(20, 20)
          button.WTSPlusFavorite:SetPoint("LEFT", button, "LEFT", 3, -1)

          button.WTSPlusFavorite.icon = button.WTSPlusFavorite:CreateTexture(nil, "ARTWORK")
          button.WTSPlusFavorite.icon:SetAllPoints()
          button.WTSPlusFavorite.icon:SetTexture("Interface\\COMMON\\FavoritesIcon")

          button.WTSPlusFavorite:SetScript("OnClick", function(self)
            if self.recipeName and self.profession then
              Favorites.Toggle(self.profession, self.recipeName)
              UI.UpdateFavoriteIcon(self)
            end
          end)

          button.WTSPlusFavorite:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            if Favorites.IsFavorite(self.profession, self.recipeName) then
              GameTooltip:SetText("Remove from favorites")
            else
              GameTooltip:SetText("Add to favorites")
            end
            GameTooltip:Show()
          end)

          button.WTSPlusFavorite:SetScript("OnLeave", function()
            GameTooltip:Hide()
          end)
        end

        local offset = Utils.FauxScrollFrame_GetOffset(scrollFrame)
        local index = i + offset
        if totalSkills > 0 and index > totalSkills then
          button:Hide()
          button.WTSPlusLevel:SetText("")
          if button.WTSPlusFavorite then
            button.WTSPlusFavorite.recipeName = nil
            button.WTSPlusFavorite.profession = nil
            button.WTSPlusFavorite:Hide()
          end
        else
          local recipe, skillType, _, _, _, _, level = getSkillInfo(index)

          if recipe and level then
            if level > 1 then
              button.WTSPlusLevel:SetText(level)
              button.WTSPlusLevel:SetTextColor(GetItemQualityColor(1))
            else
              button.WTSPlusLevel:SetText("")
            end
          else
            button.WTSPlusLevel:SetText("")
          end

          if recipe and skillType ~= "header" then
            button.WTSPlusFavorite.recipeName = recipe
            button.WTSPlusFavorite.profession = profession
            button.WTSPlusFavorite:Show()
            UI.UpdateFavoriteIcon(button.WTSPlusFavorite)
            button:Show()
          else
            button.WTSPlusFavorite.recipeName = nil
            button.WTSPlusFavorite.profession = nil
            button.WTSPlusFavorite:Hide()
            if not recipe then
              button:Hide()
            else
              button:Show()
            end
          end
        end

    if not selectionName or selectionIndex > totalSkills then
      if frameType == "TradeSkill" then
        if TradeSkillHighlightFrame then
          TradeSkillHighlightFrame:Hide()
        end
        if TradeSkillHighlight then
          TradeSkillHighlight:Hide()
        end
      else
        if CraftHighlightFrame then
          CraftHighlightFrame:Hide()
        end
        if CraftHighlight then
          CraftHighlight:Hide()
        end
      end
    end
      end
    end

  end

  Utils.hooksecurefunc(frame:GetName() .. "_Update", hookFrame)
end

function UI.CreateFavoritesFilterCheckbox(mainFrame, frameType)
  local checkboxName = "WTSPlusFavoritesFilter" .. frameType
  if Utils._G[checkboxName] then
    return
  end

  local checkbox = CreateFrame("CheckButton", checkboxName, mainFrame, "UICheckButtonTemplate")
  checkbox:SetSize(20, 20)

  if frameType == "TradeSkill" then
    checkbox:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 365, -52)
  else
    checkbox:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", -34, -26)
  end

  local label = checkbox:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
  label:SetPoint("LEFT", checkbox, "RIGHT", 3, 0)
  label:SetText("Favorites")
  local iconSize = 20
  local star = checkbox:CreateTexture(nil, "ARTWORK")
  star:SetSize(iconSize, iconSize)
  star:SetTexture("Interface\\COMMON\\FavoritesIcon")
  star:SetPoint("LEFT", label, "RIGHT", 2, -2)
  local labelWidth = label:GetStringWidth() or 0
  checkbox:SetHitRectInsets(0, -(labelWidth + iconSize + 10), -4, 0)

  checkbox:SetChecked(Favorites.IsFilterEnabled())

  checkbox:SetScript("OnClick", function(self)
    local isChecked = self:GetChecked()
    Favorites.SetFilterEnabled(isChecked)
    UI.ToggleCustomList(frameType, isChecked)
  end)

  checkbox:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Show favorites only")
    GameTooltip:Show()
  end)

  checkbox:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)
end

function UI.CreateCustomList(frameType)
  local listName = "WTSPlusCustomList" .. frameType
  if customListFrame[frameType] then
    return
  end

  local mainFrame = Utils._G[frameType .. "Frame"]
  local originalScroll = Utils._G[frameType .. "ListScrollFrame"]

  local container = CreateFrame("Frame", listName .. "Container", mainFrame)
  container:SetAllPoints(originalScroll)
  container:SetFrameLevel(originalScroll:GetFrameLevel() + 10)
  container:Hide()

  local BUTTON_HEIGHT = customListLayout.buttonHeight
  local scrollFrame = CreateFrame("ScrollFrame", listName .. "ScrollFrame", container, "FauxScrollFrameTemplate")
  scrollFrame:SetAllPoints(container)
  scrollFrame:SetFrameLevel(container:GetFrameLevel() + 2)
  scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
    FauxScrollFrame_OnVerticalScroll(self, offset, BUTTON_HEIGHT, function()
      UI.UpdateCustomList(frameType)
    end)
  end)

  container:EnableMouseWheel(true)
  container:SetScript("OnMouseWheel", function(self, delta)
    local scrollBar = scrollFrame.ScrollBar or Utils._G[scrollFrame:GetName() .. "ScrollBar"]
    if not scrollBar then
      return
    end

    if not scrollBar:IsShown() then
      return
    end

    local current = scrollFrame:GetVerticalScroll()
    local nextOffset = current - (delta * BUTTON_HEIGHT)
    local minValue, maxValue = scrollBar:GetMinMaxValues()
    if nextOffset < 0 then
      nextOffset = 0
    end
    if maxValue and nextOffset > maxValue then
      nextOffset = maxValue
    end

    scrollFrame:SetVerticalScroll(nextOffset)
    FauxScrollFrame_OnVerticalScroll(scrollFrame, nextOffset, BUTTON_HEIGHT, function()
      UI.UpdateCustomList(frameType)
    end)
  end)

  UI.SkinCustomScrollBar(scrollFrame, frameType)

  for i = 1, Utils.DISPLAY_SIZE do
    local button = CreateFrame("Button", listName .. "Button" .. i, container)
    button:SetSize(customListLayout.buttonWidth, BUTTON_HEIGHT)
    if i == 1 then
      button:SetPoint("TOPLEFT", container, "TOPLEFT", customListLayout.topLeftX, customListLayout.topLeftY)
    else
      button:SetPoint("TOPLEFT", Utils._G[listName .. "Button" .. (i - 1)], "BOTTOMLEFT", 0, 1)
    end

    button.selection = button:CreateTexture(nil, "BACKGROUND")
    button.selection:SetTexture("Interface\\Buttons\\UI-Listbox-Highlight2")
    button.selection:SetBlendMode("BLEND")
    button.selection:ClearAllPoints()
    UI.ApplyCustomListHighlight(button)
    button.selection:SetAlpha(0.7)
    button.selection:SetVertexColor(1, 1, 1, 1)
    button.selection:Hide()

    button.hover = nil

    button:SetScript("OnEnter", function(self)
      if not self.isSelected and self.text then
        self.text:SetTextColor(1, 1, 1)
      end
    end)

    button:SetScript("OnLeave", function(self)
      if self.text then
        if self.isSelected then
          self.text:SetTextColor(1, 1, 1)
        elseif self.baseTextColor then
          self.text:SetTextColor(self.baseTextColor.r, self.baseTextColor.g, self.baseTextColor.b)
        end
      end
    end)

    button.text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    button.text:SetJustifyH("LEFT")

    button.levelText = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    UI.ApplyCustomListTextOffsets(button, false)

    button.favoriteBtn = CreateFrame("Button", nil, button)
    button.favoriteBtn:SetSize(customListLayout.favoriteSize, customListLayout.favoriteSize)
    button.favoriteBtn:SetPoint("LEFT", button, "LEFT", customListLayout.favoriteX, customListLayout.favoriteY)
    button.favoriteBtn.icon = button.favoriteBtn:CreateTexture(nil, "ARTWORK")
    button.favoriteBtn.icon:SetAllPoints()
    button.favoriteBtn.icon:SetTexture("Interface\\COMMON\\FavoritesIcon")
    button.favoriteBtn.icon:SetVertexColor(1, 0.82, 0, 1)

    button.favoriteBtn:SetScript("OnClick", function(self)
      if self.recipeName and self.profession then
        Favorites.Toggle(self.profession, self.recipeName)
        UI.UpdateCustomList(frameType)
      end
    end)

    button.favoriteBtn:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
      GameTooltip:SetText("Remove from favorites")
      GameTooltip:Show()
    end)

    button.favoriteBtn:SetScript("OnLeave", function()
      GameTooltip:Hide()
    end)

    button:SetScript("OnClick", function(self)
      if self.recipeIndex then
        if frameType == "TradeSkill" then
          TradeSkillFrame_SetSelection(self.recipeIndex)
        else
          CraftFrame_SetSelection(self.recipeIndex)
        end
        UI.UpdateCustomList(frameType)
      end
    end)

    button:SetScript("OnMouseDown", function(self)
      UI.ApplyCustomListTextOffsets(self, true)
    end)

    button:SetScript("OnMouseUp", function(self)
      UI.ApplyCustomListTextOffsets(self, false)
    end)

    button:Hide()
  end

  customListFrame[frameType] = {
    container = container,
    buttonHeight = BUTTON_HEIGHT,
    scrollFrame = scrollFrame,
  }
end

function UI.HideOriginalList(frameType)
  local originalScroll = Utils._G[frameType .. "ListScrollFrame"]
  local skillButtonPrefix = frameType == "Craft" and "Craft" or "TradeSkillSkill"

  originalScroll:Hide()
  if originalScroll.ScrollBar then
    originalScroll.ScrollBar:Hide()
  end
  if originalScroll.WTSPlusScrollFix then
    originalScroll.WTSPlusScrollFix:Hide()
  end

  for i = 1, Utils.DISPLAY_SIZE do
    local btn = Utils._G[skillButtonPrefix .. i]
    if btn then
      btn:Hide()
    end
  end


  if frameType == "TradeSkill" then
    if TradeSkillHighlightFrame then
      TradeSkillHighlightFrame:Hide()
    end
    if TradeSkillHighlight then
      TradeSkillHighlight:Hide()
    end
  else
    if CraftHighlightFrame then
      CraftHighlightFrame:Hide()
    end
    if CraftHighlight then
      CraftHighlight:Hide()
    end
  end
end

function UI.ShowOriginalList(frameType)
  local originalScroll = Utils._G[frameType .. "ListScrollFrame"]
  local skillButtonPrefix = frameType == "Craft" and "Craft" or "TradeSkillSkill"

  originalScroll:Show()
  if originalScroll.ScrollBar then
    originalScroll.ScrollBar:Show()
  end
  if originalScroll.WTSPlusScrollFix then
    originalScroll.WTSPlusScrollFix:Show()
  end
  local scrollBarName = frameType .. "ListScrollFrameScrollBar"
  local scrollBarParts = {
    scrollBarName,
    scrollBarName .. "BG",
    scrollBarName .. "Top",
    scrollBarName .. "Middle",
    scrollBarName .. "Bottom",
    scrollBarName .. "ThumbTexture",
    scrollBarName .. "ScrollUpButton",
    scrollBarName .. "ScrollDownButton",
  }
  for _, name in ipairs(scrollBarParts) do
    local part = Utils._G[name]
    if part and part.Show then
      part:Show()
    end
  end

  for i = 1, Utils.DISPLAY_SIZE do
    local btn = Utils._G[skillButtonPrefix .. i]
    if btn then
      btn:Show()
    end
  end


  if frameType == "TradeSkill" then
    if TradeSkillHighlightFrame then
      TradeSkillHighlightFrame:Show()
    end
    if TradeSkillHighlight then
      TradeSkillHighlight:Show()
    end
  else
    if CraftHighlightFrame then
      CraftHighlightFrame:Show()
    end
    if CraftHighlight then
      CraftHighlight:Show()
    end
  end
end

function UI.SyncFilterState(frameType)
  local filterEnabled = Favorites.IsFilterEnabled()
  isFilterActive[frameType] = filterEnabled

  local checkboxName = "WTSPlusFavoritesFilter" .. frameType
  local checkbox = Utils._G[checkboxName]
  if checkbox then
    checkbox:SetChecked(filterEnabled)
  end

  local custom = customListFrame[frameType]
  if not custom then
    return
  end

  if filterEnabled then
    UI.PrepareFilterHeaders(frameType)
    UI.HideOriginalList(frameType)
    custom.container:Show()
    UI.UpdateCustomList(frameType)
  else
    custom.container:Hide()
    UI.ShowOriginalList(frameType)
  end
end

function UI.RefreshForFrame(frameType)
  local custom = customListFrame[frameType]
  if not custom then
    return
  end

  if Favorites.IsFilterEnabled() then
    UI.HideOriginalList(frameType)
    custom.container:Show()
    UI.UpdateCustomList(frameType)
  else
    custom.container:Hide()
    UI.ShowOriginalList(frameType)
    if frameType == "TradeSkill" then
      TradeSkillFrame_Update()
    else
      CraftFrame_Update()
    end
  end
end

function UI.ToggleCustomList(frameType, show)
  local custom = customListFrame[frameType]
  if not custom then
    return
  end

  isFilterActive[frameType] = show

  if show then
    UI.PrepareFilterHeaders(frameType)
    UI.HideOriginalList(frameType)
    custom.container:Show()
    UI.UpdateCustomList(frameType)
  else
    custom.container:Hide()
    UI.ShowOriginalList(frameType)
    if frameType == "TradeSkill" then
      TradeSkillFrame_Update()
    else
      CraftFrame_Update()
    end
  end
end

function UI.GetSkillTypeColor(frameType, skillType)
  local colorTable
  if frameType == "TradeSkill" then
    colorTable = TradeSkillTypeColor
  else
    colorTable = CraftTypeColor
  end

  if colorTable and colorTable[skillType] then
    local color = colorTable[skillType]
    return color.r, color.g, color.b
  end

  if skillType == "optimal" then
    return 1.0, 0.5, 0.25
  elseif skillType == "medium" then
    return 1.0, 1.0, 0.0
  elseif skillType == "easy" then
    return 0.25, 0.75, 0.25
  elseif skillType == "trivial" then
    return 0.5, 0.5, 0.5
  else
    return 1.0, 1.0, 1.0
  end
end


function UI.UpdateCustomList(frameType)
  local custom = customListFrame[frameType]
  if not custom or not custom.container:IsShown() then
    return
  end

  local profession = Favorites.GetCurrentProfession(frameType)
  if not profession then
    return
  end

  local info = UI.GetFrameTypeInfo(frameType)
  local favoritesList = UI.BuildFavoritesList(frameType, profession)

  local selectedIndex = info.getSelectionIndex()
  local selectionIsInFavorites = false
  for _, fav in ipairs(favoritesList) do
    if fav.index == selectedIndex then
      selectionIsInFavorites = true
      break
    end
  end

  if not selectionIsInFavorites and #favoritesList > 0 then
    info.setSelection(favoritesList[1].index)
    selectedIndex = favoritesList[1].index
  end

  local listName = "WTSPlusCustomList" .. frameType
  local scrollFrame = custom.scrollFrame
  if not scrollFrame then
    return
  end
  UI.SkinCustomScrollBar(scrollFrame, frameType)

  FauxScrollFrame_Update(scrollFrame, #favoritesList, Utils.DISPLAY_SIZE, custom.buttonHeight)
  local offset = Utils.FauxScrollFrame_GetOffset(scrollFrame)
  local needsScroll = #favoritesList > Utils.DISPLAY_SIZE
  local scrollBar = scrollFrame.ScrollBar or Utils._G[scrollFrame:GetName() .. "ScrollBar"]
  if scrollBar then
    if needsScroll then
      scrollBar:Show()
    else
      scrollBar:Hide()
      scrollFrame:SetVerticalScroll(0)
      offset = 0
    end
  end

  local highlightRightOffset = customListLayout.highlightRightOffset
  if needsScroll then
    highlightRightOffset = customListLayout.highlightRightOffsetWithScroll
  end

  for i = 1, Utils.DISPLAY_SIZE do
    local button = Utils._G[listName .. "Button" .. i]
    local dataIndex = i + offset

    if dataIndex <= #favoritesList then
      local data = favoritesList[dataIndex]

      local r, g, b = UI.GetSkillTypeColor(frameType, data.skillType)

      UI.ApplyCustomListHighlight(button, highlightRightOffset)

      if data.numAvailable > 0 then
        button.text:SetText(data.name .. " [" .. data.numAvailable .. "]")
      else
        button.text:SetText(data.name)
      end

      button.baseTextColor = { r = r, g = g, b = b }
      if selectedIndex == data.index then
        button.text:SetTextColor(1, 1, 1)
      else
        button.text:SetTextColor(r, g, b)
      end

      if data.level > 1 then
        button.levelText:SetText(data.level)
        button.levelText:SetTextColor(GetItemQualityColor(1))
      else
        button.levelText:SetText("")
      end

      button.recipeIndex = data.index
      button.favoriteBtn.recipeName = data.name
      button.favoriteBtn.profession = data.profession

      button.selection:SetVertexColor(r, g, b, 1)

      if selectedIndex == data.index then
        button.isSelected = true
        button.selection:Show()
      else
        button.isSelected = false
        button.selection:Hide()
      end

      button:Show()
    else
      button.isSelected = false
      button.selection:Hide()
      button:Hide()
    end
  end
end

function UI.UpdateFavoriteIcon(favoriteButton)
  if not favoriteButton then
    return
  end

  local isFavorite = Favorites.IsFavorite(favoriteButton.profession, favoriteButton.recipeName)
  if isFavorite then
    favoriteButton.icon:SetVertexColor(1, 0.82, 0, 1)
    favoriteButton.icon:SetAlpha(1)
  else
    favoriteButton.icon:SetVertexColor(0.5, 0.5, 0.5, 1)
    favoriteButton.icon:SetAlpha(0.3)
  end
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
