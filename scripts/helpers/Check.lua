local Mod = Eatless

if  not REPENTOGON then
	local Texts = {
		["zh"] = {
			"不要再吃了! 需要前置\"REPENTOGON\"来运行！",
			"请下载该前置！"
		},
		["en"] = {
			"Eatless Good Omissions REQUIRES  \"REPENTOGON\"  TO RUN",
			"INSTALL IT!"
		}
	}

    local font = Mod.Fonts.TeammeatExtended10
	local texts = Texts[Options.Language] or Texts["en"]
	local color = KColor(0,1,1,1)

	Mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
		local posX = Isaac.GetScreenWidth() / 2
		local posY = Isaac.GetScreenHeight() / 2
		for i, text in ipairs(texts) do
			font:DrawStringUTF8(text, posX - 200, posY + (i-1)*20, color, 400, true)
		end	
	end)
end