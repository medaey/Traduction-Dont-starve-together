local STRINGS = GLOBAL.STRINGS

local function GetPlayer(str, separator)
	local f, l = str:find(separator)
	if f and l then	
		return str:sub(1, f - 2)
	end
	
	return "[NO_PLAYER]"
end

local function GetCause(str, separator, ending)
	local f, l = str:find(separator)
	if f and l then	
		return str:sub(l + 2, ending and str:len() - ending:len() or str:len() - 1)
	end
	
	return "[NO_CAUSE]"
end

local function GetParticipants(str, separator, ending)
	return GetPlayer(str, separator), GetCause(str, separator, ending)
end

---------------------------------------------------
--// Death
---------------------------------------------------
local DEATH_ANNOUNCEMENT_1 =
{
	STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_1, -- DEFAULT // "morreu por"
	"foi morto por",					 -- MALE
	"foi morta por",				     -- FEMALE
	"foi morto por"					 	 -- ROBOT
}

local DEATH_ANNOUNCEMENT_2 =
{
	STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_DEFAULT,
	STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_MALE,
	STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_FEMALE,
	STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_ROBOT
}

local oldDeathAnnouncement = GLOBAL.Networking_DeathAnnouncement
local function Networking_DeathAnnouncement(message, ...)
	if GLOBAL.TheWorld ~= nil and GLOBAL.TheWorld.ismastersim then
		oldDeathAnnouncement(message, ...)
		return
	end
	
	for i, v in ipairs(DEATH_ANNOUNCEMENT_2) do
		if message:find(v) then
			local victim, killer = GetParticipants(message, DEATH_ANNOUNCEMENT_1[1], v)
			killer = DICTIONARY[killer] or killer
			
			oldDeathAnnouncement(victim.." "..
								 (DICTIONARY[DEATH_ANNOUNCEMENT_1[i]] or DEATH_ANNOUNCEMENT_1[i]).." "..
								 (DICTIONARY[killer] or killer)..
								 (DICTIONARY[v] or v), ...)
			break
		end
	end
end

---------------------------------------------------
--// Resurrection
---------------------------------------------------
local REZ_ANNOUNCEMENT =
{
	DEFAULT = STRINGS.UI.HUD.REZ_ANNOUNCEMENT,
	MALE    = "foi revivido por",
	FEMALE  = "foi revivida por",
	ROBOT   = "foi revivido por",
}

local oldResurrectAnnouncement = GLOBAL.Networking_ResurrectAnnouncement
local function Networking_ResurrectAnnouncement(message,...)
	if GLOBAL.TheWorld == nil or GLOBAL.TheWorld.ismastersim then
		oldResurrectAnnouncement(message, ...)
		return
	end

	local separator = REZ_ANNOUNCEMENT.DEFAULT
	local rezzed, cause = GetParticipants(message, separator)
	for i, v in ipairs(GLOBAL.GetPlayerClientTable()) do
		if v.name == rezzed then
			separator = REZ_ANNOUNCEMENT[GLOBAL.GetGenderStrings(v.prefab or "")]
			break
		end
	end

	oldResurrectAnnouncement(rezzed.." "..
							 (DICTIONARY[separator] or separator).." "..
							 (DICTIONARY[cause] or cause)..
							 message:sub(message:len()), ...)
end

---------------------------------------------------
--// Everything Else
---------------------------------------------------
local oldNetworkingAnnouncement = GLOBAL.Networking_Announcement
local function Networking_Announcement(message, colour, announce_type)
	--print("Executing modded Networking_Announcement from translation.", "Original message: '"..message.."'")
	if GLOBAL.TheWorld ~= nil and not GLOBAL.TheWorld.ismastersim and announce_type == nil then
		--print("World exists and is not master simulation.")
		for i, player in ipairs(GLOBAL.GetPlayerClientTable()) do
			local k, l = message:find(player.name)
			--print("Tried making announcement with "..player.name.."...")
			if k and l then
				-- "The Eye of Terror turns its gaze toward HowlingBreeze"
				local target = message:sub(k, l) -- "HowlingBreeze"
				local str_prev = message:sub(1, k-1) -- "The Eye of Terror turns its gaze toward "
				local str_post = message:sub(l+1, -1)
				
				message = (k > 1 and (DICTIONARY.ANNOUNCE[str_prev] or str_prev) or "")..target..(DICTIONARY.ANNOUNCE[str_post] or str_post)
				
				--print("Results:", str_prev, target, str_post)
				--print("Message:"..message)
				break
			end

			--print("Failed.")
		end
	end
	
	oldNetworkingAnnouncement(message, colour, announce_type)
end

---------------------------------------------------
--// Save Variables
---------------------------------------------------
GLOBAL.scheduler:ExecuteInTime(0, function()
	GLOBAL.Networking_DeathAnnouncement = Networking_DeathAnnouncement
	GLOBAL.Networking_ResurrectAnnouncement = Networking_ResurrectAnnouncement
	GLOBAL.Networking_Announcement = Networking_Announcement
end)