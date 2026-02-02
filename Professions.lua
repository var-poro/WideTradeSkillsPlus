local Professions = {}
local Utils = WideTradeSkillsPlus_Utils

local profMining   = Utils.GetSpellInfo(2576)
local profSmelting = Utils.GetSpellInfo(2656)
local profSkinning = Utils.GetSpellInfo(8613)
local profEnchant  = Utils.GetSpellInfo(7412)
local profFishing  = Utils.GetSpellInfo(7731)
local profCooking  = Utils.GetSpellInfo(3102)

function Professions.GetProfessions()
  local section, mainProfs, subProfs = 0, {}, {}
  for i = 1, Utils.GetNumSkillLines() do
    local name, isHeader = Utils.GetSkillLineInfo(i)
    if isHeader then
      section = section + 1
    elseif section == 2 or section == 3 then
      if name ~= profSkinning and name ~= profFishing then
        if name == profMining then name = profSmelting end
        if name == "가죽 세공" then name = "가죽세공" end
        local id = select(7, Utils.GetSpellInfo(name))
        if id and not Utils.IsPassiveSpell(id) then
          Utils.tinsert(mainProfs, id)
          if name == profEnchant then
            Utils.tinsert(subProfs, 13262)
          elseif name == profCooking then
            Utils.tinsert(subProfs, 818)
          end
        end
      end
    end
  end
  return mainProfs, subProfs
end

function Professions.GetEnchantSpellName()
  return profEnchant
end

WideTradeSkillsPlus_Professions = Professions
