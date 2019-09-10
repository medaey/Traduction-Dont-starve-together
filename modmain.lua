-- Thanks to Some1 and Klei forums
LoadPOFile("fr_FR.po", "fr")

STRINGS=GLOBAL.STRINGS

-- nouveaux caracteres pour la console
AddClassPostConstruct("screens/consolescreen", function(self)
	local NewConsoleValidChars=[[ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,:;[]<>\@!#$%&()'*+-/=?^_{|}~"ÀÂÆÇÉÈÊËÎÏÔŒÙÛÜŸàâæçéèêëîïôœùûüÿ]]
	self.console_edit:SetCharacterFilter( NewConsoleValidChars )
end)

-- traduction de Host en francais
if GLOBAL.TheNet.GetClientTable then
	GLOBAL.getmetatable(GLOBAL.TheNet).__index.GetClientTable = (function()
		local oldGetClientTable = GLOBAL.getmetatable(GLOBAL.TheNet).__index.GetClientTable
		return function(self, ... )
			local res=oldGetClientTable(self, ...)
			if res and type(res)=="table" then for i,v in pairs(res) do
				if v.name and v.prefab then
					if v.name=="[Host]" then v.name="[Hébergeur]" end
				end
			end end
			return res
		end
	end)()
end

-- nouveaux caracteres pour le chat
AddClassPostConstruct("screens/chatinputscreen", function(self)
	if self.chat_edit then
		local ValidChars=[[ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,:;[]\@!#$%&()'*+-/=?^_{|}~"<>ÀÂÆÇÉÈÊËÎÏÔŒÙÛÜŸàâæçéèêëîïôœùûüÿ]]
		self.chat_edit:SetCharacterFilter( ValidChars )
		if GLOBAL.PLATFORM:sub(1,5):upper()=="LINUX" or GLOBAL.PLATFORM:sub(1,3):upper()=="OSX" then
			local w1 = self.chat_type and self.chat_type:GetRegionSize() or 0
			local w2 = self.chat_edit:GetRegionSize()
			self.chat_edit:MoveLanguageMarker(-(w2/2+w1-30+(self.whisper and 30 or 0)), 1)
		end
	end
end)

-- noms des modes de jeu (liste serveurs et IG)
if GLOBAL.rawget(GLOBAL,"GAME_MODES") and STRINGS.UI.SERVERCREATIONSCREEN then for i,v in pairs(GLOBAL.GAME_MODES) do
	for ii,vv in pairs(STRINGS.UI.GAMEMODES) do
		if v.text==vv then GLOBAL.GAME_MODES[i].text=GLOBAL.LanguageTranslator.languages["fr"]["STRINGS.UI.GAMEMODES."..ii] or GLOBAL.GAME_MODES[i].text end
		if v.hover_text==vv then GLOBAL.GAME_MODES[i].hover_text=GLOBAL.LanguageTranslator.languages["fr"]["STRINGS.UI.GAMEMODES."..ii] or GLOBAL.GAME_MODES[i].hover_text end
	end
end end

-- reduit la taille de la police des descriptions de recettes
AddClassPostConstruct("widgets/recipepopup", function(self)
	if self.name and self.Refresh then --
		if not self.OldRefresh then
			self.OldRefresh=self.Refresh
			function self.Refresh(self,...)
				self:OldRefresh(...)
				if not self.name then return end
				local Text = GLOBAL.require "widgets/text"
		        local tmp = self.contents:AddChild(Text(GLOBAL.UIFONT, 42))
		        
			    tmp:SetPosition(320, 182, 0)
			    tmp:SetHAlign(GLOBAL.ANCHOR_MIDDLE)
			    tmp:Hide()
		        tmp:SetString(self.name:GetString())
			    local desiredw = self.name:GetRegionSize()
				local w = tmp:GetRegionSize()
				tmp:Kill()
				if w>desiredw then
					self.name:SetSize(42*desiredw/w)
				else
					self.name:SetSize(42)
				end
			end
		end
	end
	if self.desc then
		self.desc:SetSize(25)
	end
end)



-- Bug boutons enabled et disabled
AddClassPostConstruct("screens/optionsscreen", function(self) 
	for _,v in pairs(self) do
		if type(v)=="table" and v.name=="SPINNER" then
			for _,opt in ipairs(v.options) do
				if opt.text=="Enabled" then
					opt.text=STRINGS.UI.OPTIONS.ENABLED
				elseif opt.text=="Disabled" then
					opt.text=STRINGS.UI.OPTIONS.DISABLED
				end
			end
			if v.selectedIndex and v.selectedIndex>0 and v.selectedIndex<=#v.options then v:UpdateText(v.options[v.selectedIndex].text) end
		end
	end
end
)