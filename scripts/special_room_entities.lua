local mod = Broken
local RoomEntities = {}

RoomEntities.ModPickup = {
    Type = 7030,
}

local itemConfig = Isaac.GetItemConfig()

local function FindCollectibleBySubType(subtype)
    return mod.IDTable.Collectibles[subtype]
end
local function FindTrinketBySubType(subtype)
    return mod.IDTable.Trinkets[subtype]
end
local function FindCardBySubType(subtype)
    return mod.IDTable.Cards[subtype]
end

local function PreRoomEntitySpawn(_, id, variant, subtype, index, seed)
    if (id ~= RoomEntities.ModPickup.Type) then
        return;
    end
    local id = 0;
    if (subtype > 0) then
        if (variant == PickupVariant.PICKUP_COLLECTIBLE) then
            id = FindCollectibleBySubType(subtype)
        -- elseif (variant == PickupVariant.PICKUP_TRINKET) then
        --     id = FindTrinketBySubType(subtype)
        elseif (variant == PickupVariant.PICKUP_TAROTCARD) then
            id = FindCardBySubType(subtype)
        end
    end
--    print(subtype, variant, id)
    return {EntityType.ENTITY_PICKUP, variant, id}
end
mod:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, PreRoomEntitySpawn)

return RoomEntities