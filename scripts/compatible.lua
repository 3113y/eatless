local mod = Eatless
mod.Eatless = {}
local IsaacEatless = mod.Eatless
local itemConfig = Isaac.GetItemConfig()

--东方幻想曲
do
	IsaacEatless.THI = {}

	--检查东方mod及其前置mod的开启情况
	function IsaacEatless.THI:IsEnabled()
		if CuerLib and THI then
			return true
		end
		return false
	end

	--玩家是否使用正邪的增强道具方案
	function IsaacEatless.THI:SeijaBuff(player)
		if self:IsEnabled() then
			return THI.Players.Seija:WillPlayerBuff(player)
		end
		return false
	end

	--玩家是否使用正邪的削弱道具方案
	function IsaacEatless.THI:SeijaNerf(player)
		if self:IsEnabled() then
			return THI.Players.Seija:WillPlayerNerf(player)
		end
		return false
	end

	--获取里正邪等级
	function IsaacEatless.THI:GetSeijaBLevel(player)
		if self:IsEnabled() then
			return THI.Players.SeijaB:GetUpgradeLevel(player)
		end
		return 0
	end

	--加载项
	local THILoaded = false
	mod:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.IMPORTANT, function()
		if (not THILoaded) and IsaacEatless.THI:IsEnabled() then
			THILoaded = true

			do --镜像骰固定转换
				local d = THI.Collectibles.DFlip
				--长子权<=>卷轴
				--d:AddFixedPair(5,100,619, 5,100,)
			end
			
			do --饥饿
				local Hunger = THI.Collectibles.Hunger
				--Hunger:SetCollectibleHunger(, 4)
			end
			
			do --复印机
				local PortableCopier = THI.Collectibles.PortableCopier
				--PortableCopier:AddPaperCollectible(IBS_ItemID.Blackjack)
			end
		end
	end)

end

