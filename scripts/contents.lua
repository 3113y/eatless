local Mod = Broken

Mod.Helpers = {

}

Mod.Callback = {

}

Mod.lib = {

}

local function IsValidID(num)
    if num == -1 then
        return false
    end
    return num
end

local function GetItemInfo(en, zh)
    return IsValidID(Isaac.GetItemIdByName(en)) or Isaac.GetItemIdByName(zh)
end

local function GetTrinketInfo(en, zh)
    return IsValidID(Isaac.GetTrinketIdByName(en)) or Isaac.GetTrinketIdByName(zh)
end

Mod.entitypickups = {

}

Mod.Collectibles = {

}

Mod.trinkets = {

}


local function Entit(fileName)--实体
	include("scripts.entity.pickup."..fileName)
end
for i = 1, #Mod.entitypickups do
	Entit(Mod.entitypickups[i][1])
end

local function Collectibles(fileName)--道具
	include("scripts.Items.item."..fileName)
end
for i = 1, #Mod.Collectibles do
	Collectibles(Mod.Collectibles[i][1])
end

local function Trinkets(fileName)--饰品
	include("scripts.Items.trinket."..fileName)
end
for i = 1, #Mod.trinkets do
	Trinkets(Mod.trinkets[i][1])
end





