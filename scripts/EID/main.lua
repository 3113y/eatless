local mod = Eatless
local Mod = mod
local GetItem = mod.Collectibles
local game = Game()
local other = Mod.Helpers.Other

local Eatless_EID = {
    ["zh_cn"] = include("scripts.EID.EID_zh_PT"),
    ["en_us"] = include("scripts.EID.EID_en_PT"),
}

--任意玩家拥有指定道具
function mod:AnyHasCollectible(item, ignoreEffect)
    ignoreEffect = ignoreEffect or false
    for i = 0, Game():GetNumPlayers(0) - 1 do
        local player= Isaac.GetPlayer(i)
        if player:HasCollectible(item, ignoreEffect) then
            return true
        end
    end

    return false
end

--翻译
local function Translate(text_zh, text_en, language)
	return (language == 'zh_cn' and text_zh) or text_en
end

if EID then
    for language, Eatless_EID in pairs(Eatless_EID) do
        --道具描述
        local descriptions = EID.descriptions[language];
            descriptions.reverieBelialReplace = {}
            descriptions.BFFSSynergies = descriptions.BFFSSynergies or {};
        for id, des in pairs( Eatless_EID.Collectibles) do
            EID:addCollectible(id,des.info,des.name,language)
            --美德书兼容效果描述
            if (des.BookOfVirtues and descriptions.bookOfVirtuesWisps) then
                descriptions.bookOfVirtuesWisps[id] = des.BookOfVirtues;
            end
            --犹大长子权兼容效果描述
            if (des.BookOfBelial and descriptions.bookOfBelialBuffs) then
                descriptions.bookOfBelialBuffs[id] = des.BookOfBelial;
            end
            --犹大长子权效果替换描述
            if (des.BookOfBelialReplace and descriptions.reverieBelialReplace) then
                descriptions.reverieBelialReplace["5.100."..id] = des.BookOfBelialReplace;
            end
            --大胃王兼容效果描述
            if (des.BingeEater and descriptions.bingeEaterBuffs) then
                descriptions.bingeEaterBuffs[id] = des.BingeEater;
            end
            --好朋友一辈子兼容效果描述
            if (des.BFFs and descriptions.BFFSSynergies) then
                EID:addBFFSCondition(id, des.BFFs, nil, nil, language)
            end
            
        end
        --饰品描述
        for id, des in pairs( Eatless_EID.Trinkets) do
            for i = 1, 2 do
                EID:addTrinket(id,des.info,des.name,language)
                if des.GoldenInfo then
                    EID.GoldenTrinketData[id] = des.GoldenInfo
                end
                if des.GoldenEffect then
                    descriptions.goldenTrinketEffects[id] = des.GoldenEffect
                end
            end
        end
        --其他实体描述
        if  Eatless_EID.EIDEntities then
            for _, des in pairs( Eatless_EID.EIDEntities) do
                if type(des.info) == "function" then
                    des.info = des.info()
                end
                EID:addEntity(des.Type, des.Variant, des.SubType, des.name, des.info, language)
            end
        end
--[[         
        --长子权描述
        for id, des in pairs( Eatless_EID.EIDBirthright) do
            EID:addBirthright(id,des.info,des.name,language);
        end
       
        --角色信息描述
        for id, des in pairs( Eatless_EID.EIDPlayers) do
            EID:addCharacterInfo(id,des.info,des.name,language);
        end
        --卡牌描述
        for id, des in pairs( Eatless_EID.EIDCards) do
            EID:addCard(id,des.info,des.name,language);
        end
        --符文佩剑魂石/符文效果描述
        for id, des in pairs( Eatless_EID.RuneSword) do
            EID.descriptions[language].reverieRuneSword[id] = des
        end
]]
    end
end


--正邪效果描述
Mod:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.EARLY, function(_,isContinue)
    if mod.Eatless.THI:IsEnabled() then
        local function LoadSeija(info, lang)
            local descriptions = EID.descriptions[lang]
            -- Registered Buffs.
            for id, desc in pairs(info.SeijaBuffs) do
                if (type(desc) == "table") then
                    descriptions.reverieSeijaBuffs["100."..id] = desc.Description;
                    descriptions.reverieSeijaBuffData["100."..id] = desc.Data;
                elseif (type(desc) == "string") then
                    descriptions.reverieSeijaBuffs["100."..id] = desc;
                end
            end
            for id, desc in pairs(info.SeijaNerfs) do
                if type(desc) == "function" then
                    desc = desc()
                end
                descriptions.reverieSeijaNerfs["100."..id] = desc
            end
        end
        local seijaInfo = {
            SeijaBuffs = {},
            SeijaNerfs = {}
        }

        for language,  Eatless_EID in pairs( Eatless_EID) do
            for id, des in pairs( Eatless_EID.Collectibles) do
                if(des.SeijaNerf ~= nil or des.SeijaBuff ~= nil) then
                    if EID then
                        if(des.SeijaBuff == nil) then
                            seijaInfo.SeijaNerfs[id] = des.SeijaNerf
                        else
                            seijaInfo.SeijaBuffs[id] = des.SeijaBuff
                        end
                    end
                end
            end
            LoadSeija(seijaInfo,language)
        end
    end
end)