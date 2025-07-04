Eatless = RegisterMod("eatless",1)
local mod = Eatless

--检查前置mod
local Check = include("scripts/helpers/check")
if not Check then
    return
end

include("scripts.contents")--查看回调/函数/道具/饰品等等
include("scripts.commons")
include("scripts.compatible")

include("scripts.special_room_entities")
mod.IDTable = include("scripts.item_id_table")

include("scripts.EID.main")

if Options.Language == 'zh' then--中文EID
	include("scripts.EID.EID_zh_PT")
	include("scripts.EID.zh")
else
	include("scripts.EID.EID_en_PT")--En EID
end


if EID then
	if EID:getLanguage() == "zh_cn" then
		EID:setModIndicatorName("不要再吃了!")
	else
		EID:setModIndicatorName("Eatless")
	end
end

include("scripts.print")


