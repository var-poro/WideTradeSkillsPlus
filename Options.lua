local Options = {}
local Utils = WideTradeSkillsPlus_Utils
local Minimap = WideTradeSkillsPlus_Minimap

function Options.Create()
  local panel = CreateFrame("Frame", "WTSPlusOptionsPanel")

  local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  title:SetPoint("TOPLEFT", 16, -16)
  title:SetText("WideTradeSkillsPlus")

  local notes = Utils.GetAddOnMetadata and Utils.GetAddOnMetadata("WideTradeSkillsPlus", "Notes") or ""
  local descText = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
  descText:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
  descText:SetText(notes)

  local optionsTitle = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  optionsTitle:SetPoint("TOPLEFT", descText, "BOTTOMLEFT", 0, -16)
  optionsTitle:SetText("Options")

  local minimapCheckbox = CreateFrame("CheckButton", "WTSPlusMinimapCheckbox", panel, "InterfaceOptionsCheckButtonTemplate")
  minimapCheckbox:SetPoint("TOPLEFT", optionsTitle, "BOTTOMLEFT", 0, -8)

  local version = Utils.GetAddOnMetadata and Utils.GetAddOnMetadata("WideTradeSkillsPlus", "Version") or "?"
  local versionText = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
  versionText:SetPoint("TOPLEFT", minimapCheckbox, "BOTTOMLEFT", 0, -24)
  versionText:SetText("Version: " .. version)

  local authorText = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
  authorText:SetPoint("TOPLEFT", versionText, "BOTTOMLEFT", 0, -4)
  authorText:SetText("Author: Poro")

  local originalAuthorText = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
  originalAuthorText:SetPoint("TOPLEFT", authorText, "BOTTOMLEFT", 0, -4)
  originalAuthorText:SetText("Original author: StormtrooperTK421")

  local githubLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
  githubLabel:SetPoint("TOPLEFT", originalAuthorText, "BOTTOMLEFT", 0, -16)
  githubLabel:SetText("GitHub :")

  local githubBox = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
  githubBox:SetPoint("LEFT", githubLabel, "RIGHT", 8, 0)
  githubBox:SetSize(280, 20)
  githubBox:SetAutoFocus(false)
  githubBox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
  githubBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
  minimapCheckbox.Text:SetText("Show minimap button")
  minimapCheckbox:SetScript("OnClick", function(self)
    WTSPlusDB.Minimap.show = self:GetChecked()
    local button = Minimap.GetButton()
    if button then
      if WTSPlusDB.Minimap.show then
        button:Show()
      else
        button:Hide()
      end
    end
  end)

  panel:SetScript("OnShow", function()
    githubBox:SetText("https://github.com/var-poro/WideTradeSkillsPlus")
    minimapCheckbox:SetChecked(WTSPlusDB.Minimap.show)
  end)

  local category = Settings.RegisterCanvasLayoutCategory(panel, "WideTradeSkillsPlus")
  Settings.RegisterAddOnCategory(category)
end

WideTradeSkillsPlus_Options = Options
