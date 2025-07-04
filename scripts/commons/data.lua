local mod = Eatless
local json = require('json')
local game = Game()

----初始化数据----
local function Temp_Init()
	return {PlayerData={},Room={},Level={},RNG={},IsContinued=false}
end

local function Persis_Init() --此处可新增永久数据
	local Persis = {
		storeupmirrorNum = {
		storeupmirror_Coin = 0,
		storeupmirror_Bomb = 0,
		storeupmirror_Key = 0},

		Ender_Chest = {
		Ender_Chest_num = 1,
		Ender_Chestnum = {},
		Ender_ChestnumCharge = {}
		},
	}

	return Persis
end


local function Data_Init()
	return {Temp=Temp_Init(),Persis=Persis_Init()}
end

mod.Eatless_Data = Data_Init()
------------------
--保存
local SaveList={
	Data={},
	Persis = {},
}
for key,_ in pairs(Data_Init()) do
	SaveList.Data[key] = true
end
for key,_ in pairs(Persis_Init()) do
	SaveList.Persis[key] = true
end
local function SaveWhenExit(_,shouldSave) --退出游戏时保存
	if shouldSave then
		
		--清除保存名单外的数据
		for k,_ in pairs(mod.Eatless_Data) do
			if not SaveList.Data[k] then
				mod.Eatless_Data[k] = nil
			end
		end
		for k,_ in pairs(mod.Eatless_Data.Persis) do
			if not SaveList.Persis[k] then
				mod.Eatless_Data.Persis[k] = nil
			end
		end
		
		mod.Eatless_Data.Temp.IsContinued = true --游戏状态调整为继续游戏
		
		mod:SaveData(json.encode(mod.Eatless_Data))
	end
end
local function SaveWhenEnd() --游戏结束时保存

	--清除保存名单外的数据
	for k,_ in pairs(mod.Eatless_Data) do
		if not SaveList.Data[k] then
			mod.Eatless_Data[k] = nil
		end
	end
	for k,_ in pairs(mod.Eatless_Data.Persis) do
		if not SaveList.Persis[k] then
			mod.Eatless_Data.Persis[k] = nil
		end
	end
		
	mod:SaveData(json.encode(mod.Eatless_Data))
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_GAME_EXIT, 10^7, SaveWhenExit)
mod:AddPriorityCallback(ModCallbacks.MC_POST_GAME_END, 10^7, SaveWhenEnd)


--加载
local function LoadWhenSaveslotSelected() --选中存档槽时加载
	--检测并读取数据
	if mod:HasData() then
		mod.Eatless_Data = json.decode(mod:LoadData())
		
		--如果有,加载新增的永久数据和设置
		local _Data = Data_Init()
		local _Persis = Persis_Init()
		for k,_ in pairs(_Data) do
			if mod.Eatless_Data[k] == nil then
				mod.Eatless_Data[k] = _Data[k]
			end
		end		
		for k,_ in pairs(_Persis) do
			if mod.Eatless_Data.Persis[k] == nil then
				mod.Eatless_Data.Persis[k] = _Persis[k]
			end
		end		
	end	
end
local function LoadWhenStart(_,isContinued) --开始游戏时加载
	--检测并读取数据
	if mod:HasData() then
		mod.Eatless_Data = json.decode(mod:LoadData())

		--如果有,加载新增的永久数据和设置
		local _Data = Data_Init()
		local _Persis = Persis_Init()
		for k,_ in pairs(_Data) do
			if mod.Eatless_Data[k] == nil then
				mod.Eatless_Data[k] = _Data[k]
			end
		end		
		for k,_ in pairs(_Persis) do
			if mod.Eatless_Data.Persis[k] == nil then
				mod.Eatless_Data.Persis[k] = _Persis[k]
			end
		end	

		--新开游戏重置临时数据
		if not isContinued then
			mod.Eatless_Data.Temp = Temp_Init()
		end
	end

	--刷新角色属性
	for i = 0, game:GetNumPlayers() -1 do
		local player = Isaac.GetPlayer(i)
		player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, -10^7, LoadWhenSaveslotSelected)
mod:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, -10^7, LoadWhenStart)


--重置房间临时数据
local function ResetRoomData()
	mod.Eatless_Data.Temp.Room = mod.Eatless_Data.Temp.Room or {}
	for k,_ in pairs(mod.Eatless_Data.Temp.Room) do
		mod.Eatless_Data.Temp.Room[k] = nil
	end

	--刷新角色属性
	for i = 0, game:GetNumPlayers() -1 do
		local player = Isaac.GetPlayer(i)
		player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, -10^7, ResetRoomData)

--重置楼层临时数据
local function ResetLevelData()
	mod.Eatless_Data.Temp.Level = mod.Eatless_Data.Temp.Level or {}
	for k,_ in pairs(mod.Eatless_Data.Temp.Level) do
		mod.Eatless_Data.Temp.Level[k] = nil
	end

	--刷新角色属性
	for i = 0, game:GetNumPlayers() -1 do
		local player = Isaac.GetPlayer(i)
		player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_LEVEL, -10^7, ResetLevelData)