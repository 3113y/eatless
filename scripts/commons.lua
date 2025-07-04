local mod = Eatless
local json = require('json')
local game = Game()

include("scripts.commons.data")
--即时保存数据
function mod:SaveEatlessData()
	self:SaveData(json.encode(self.Eatless_Data))
end

--读取数据
function mod:GetEatlessData(type)
	if type == 'temp' then
		return self.Eatless_Data.Temp
	elseif type == 'level' then
		return self.Eatless_Data.Temp.Level
	elseif type == 'room' then
		return self.Eatless_Data.Temp.Room
	elseif type == 'rng' then
		return self.Eatless_Data.Temp.RNG
	elseif type == 'pdata' then
		return self.Eatless_Data.Temp.PlayerData
	elseif type == 'persis' then
		return self.Eatless_Data.Persis
	end	
	
	return {}
end

--是否继续过游戏
function mod:IsGameContinued()
	return self.Eatless_Data.Temp.IsContinued
end