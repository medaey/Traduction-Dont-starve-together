local function GetLineage(widget)
	local parent = widget.parent
	if not parent then
		return {}
	end
	
	local parents = { parent }
	while parent.parent do
		parent = parent.parent
		table.insert(parents, parent)
	end
	
	return parents
end

local function HasParent(widget, parent)
	local lineage = GetLineage(widget)
	for i, v in ipairs(lineage) do
		if v.name == parent then
			return true
		end
	end
	
	return false
end

local function HasParentAny(widget, tab)
	for i, name in ipairs(tab) do
		if HasParent(widget, name) then
			return true
		end
	end
	
	return false
end

local function GetActiveScreenName()
	local TheFrontEnd = GLOBAL.TheFrontEnd
	return TheFrontEnd ~= nil and TheFrontEnd:GetActiveScreen() ~= nil and TheFrontEnd:GetActiveScreen().name or nil
end

local VALID_SCREENS =
{	
	"MainScreen",
	"ServerListingScreen",
	"ServerCreationScreen",
	"PlaystyleSelectScreen",
	"CaveSelectScreen",
	"PresetPopupScreen",
	"MultiplayerMainScreen",
	"ViewCustomizationModalScreen",
	"OptionsScreen",
	"CompendiumScreen",
	"BalatroScreen",
}
local function IsValidScreen()
	local screen = GetActiveScreenName()
	if screen ~= nil then
		for i, name in ipairs(VALID_SCREENS) do
			if name == screen then
				return true
			end
		end
	end
	
	return false
end

local INVALID_LINEAGE =
{
	--"ServerSettingsTab",
	"ModFilterBar",
	"searchbox",
	--"server_settings_page",
	--"detail_panel",
	"mods_page",
	"topmods",
	"server_list_row",
	"details_tab",
	"death_root",
	"friend_root",
	"encounter-data_root",
	"control-morgue",
	"singleline textentry",
}
local function IsValidWidget(widget)
	local screen = GetActiveScreenName()
	local lineage = GetLineage(widget)	
	
	--print(screen, widget)
	
	if screen == "ModConfigurationScreen" or
	   (not HasParent(widget, "seasondesc") and HasParentAny(widget, INVALID_LINEAGE)) or
	   screen == "CompendiumScreen" and not HasParent(widget, "details_root") then
		return false
	end
	
	return true
end

local function IsValid(widget)
	return IsValidScreen() and IsValidWidget(widget)
end

local function HasTranslation(str)
	return DICTIONARY[str] ~= nil
end

local function DoTranslate(str, widget)
	str = (type(str) ~= "string" or str == "") and "" or DICTIONARY[str] or str

	if GetActiveScreenName() == "CaveSelectScreen" then
		local find = str:find("Caves") and "Caves" or str:find("Forest") and "Forest" --// Currently, the vanilla game only has these two.
		if find ~= nil then
			local k, l = str:find(find)
			if k and l then
				local world = str:sub(k, l)
				local str_prev = str:sub(1, k-1)
				local str_post = str:sub(l+1, -1)
				
				local new_str = (k > 1 and (DICTIONARY.CAVESELECT[str_prev] or str_prev) or "")..world..(DICTIONARY.CAVESELECT[str_post] or str_post)
				str = new_str:gsub(world, DICTIONARY[world] or world)
			end
		end
	end

	return str
end

local function new_text(self, font, size, text)
	if (text ~= "CHIPS" or text ~= "SCORE") and (GLOBAL.ThePlayer ~= nil and GLOBAL.ThePlayer.HUD:IsCraftingOpen() or GetActiveScreenName() ~= nil and string.find(GetActiveScreenName(), "HUD")) then
		--print(self, self.string or text, "Registered screen is: '"..tostring(GetActiveScreenName()).."'. Why is it invalid?")
		return
	end
	
	local oldSetString = self.SetString
	self.SetString = function(self, str)
		if self.og_string == nil or str ~= self.og_string and str ~= DoTranslate(self.og_string, self) then
			self.og_string = str
		end
		
		str = IsValid(self) and DoTranslate(self.og_string, self) or str
	
		oldSetString(self, str)
	end
	
	local oldSetTruncatedString = self.SetTruncatedString
	self.SetTruncatedString = function(self, str, ...)
		if self.og_string == nil or str ~= self.og_string and str ~= DoTranslate(self.og_string, self) then
			self.og_string = str
		end
		
		str = IsValid(self) and DoTranslate(self.og_string, self) or str
		
		oldSetTruncatedString(self, str, ...)
	end
	
	local oldSetMultilineTruncatedString_Impl = self.SetMultilineTruncatedString_Impl
	self.SetMultilineTruncatedString_Impl = function(self, str, ...)
		if self.og_string == nil or str ~= self.og_string and str ~= DoTranslate(self.og_string, self) then
			self.og_string = str
		end
		
		str = IsValid(self) and DoTranslate(self.og_string, self) or str

		return oldSetMultilineTruncatedString_Impl(self, str, ...)
	end
	
	local oldSetMultilineTruncatedString = self.SetMultilineTruncatedString
	self.SetMultilineTruncatedString = function(self, str, ...)
		if self.og_string == nil or str ~= self.og_string and str ~= DoTranslate(self.og_string, self) then
			self.og_string = str
		end
		
		str = IsValid(self) and DoTranslate(self.og_string, self) or str
	
		return oldSetMultilineTruncatedString(self, str, ...)
	end
	
	local oldSetAutoSizingString = self.SetAutoSizingString
	self.SetAutoSizingString = function(self, str, ...)	
		if self.og_string == nil or str ~= self.og_string and str ~= DoTranslate(self.og_string, self) then
			self.og_string = str
		end
		
		str = IsValid(self) and DoTranslate(self.og_string, self) or str
	
		oldSetAutoSizingString(self, str, ...)
	end
	
	GLOBAL.scheduler:ExecuteInTime(GLOBAL.FRAMES, function()
		if self.og_string == nil or self:GetString() ~= self.og_string and self:GetString() ~= DoTranslate(self.og_string, self) then
			self.og_string = self:GetString()
		end
	
		local str = IsValid(self) and DoTranslate(self.og_string, self) or self.og_string
		if str ~= nil and str ~= "" then
			self:SetString(str)
		end
	end)
end

AddClassPostConstruct("widgets/text", new_text)