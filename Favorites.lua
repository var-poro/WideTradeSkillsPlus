local Favorites = {}

function Favorites.Initialize()
  WTSPlusDB.Favorites = WTSPlusDB.Favorites or {}
  WTSPlusDB.ShowFavoritesOnly = WTSPlusDB.ShowFavoritesOnly or false
end

function Favorites.GetCurrentProfession(frameType)
  if frameType == "TradeSkill" then
    if GetTradeSkillLine then
      return GetTradeSkillLine()
    end
  elseif frameType == "Craft" then
    if GetCraftDisplaySkillLine then
      return GetCraftDisplaySkillLine()
    elseif GetCraftName then
      return GetCraftName()
    end
  end
  return nil
end

function Favorites.Toggle(profession, recipeName)
  if not profession or not recipeName then
    return
  end

  WTSPlusDB.Favorites[profession] = WTSPlusDB.Favorites[profession] or {}

  if WTSPlusDB.Favorites[profession][recipeName] then
    WTSPlusDB.Favorites[profession][recipeName] = nil
  else
    WTSPlusDB.Favorites[profession][recipeName] = true
  end
end

function Favorites.IsFavorite(profession, recipeName)
  if not profession or not recipeName then
    return false
  end

  if not WTSPlusDB.Favorites[profession] then
    return false
  end

  return WTSPlusDB.Favorites[profession][recipeName] == true
end

function Favorites.SetFilterEnabled(enabled)
  WTSPlusDB.ShowFavoritesOnly = enabled
end

function Favorites.IsFilterEnabled()
  return WTSPlusDB.ShowFavoritesOnly
end

WideTradeSkillsPlus_Favorites = Favorites
