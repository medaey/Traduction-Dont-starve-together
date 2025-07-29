Assets =
{
	Asset( "IMAGE", "images/names_gold_br_wonkey.tex" ),
	Asset( "ATLAS", "images/names_gold_br_wonkey.xml" ),

	Asset( "IMAGE", "images/names_gold_br_random.tex" ),
	Asset( "ATLAS", "images/names_gold_br_random.xml" ),
}

-------------------------------------------------------------------------------
--// Util
-------------------------------------------------------------------------------
--CONFIG = {}
local function Execute(fn, config)
	local enabled = GetModConfigData(config)
	--CONFIG[config] = enabled
	
	if enabled then
		fn()
	end
end

-------------------------------------------------------------------------------
--// Basic Translation Setup
-------------------------------------------------------------------------------
local language = "br"
local STRINGS = GLOBAL.STRINGS
local OLD_STRINGS = {}
local function DefineOldStrings(tab, directory)
	if OLD_STRINGS[directory] == nil then
		OLD_STRINGS[directory] = {}
	end

	for k, v in pairs(tab) do
		OLD_STRINGS[directory][k] = v
	end
end
DefineOldStrings(STRINGS.NAMES, "NAMES")
LoadPOFile("scripts/pt_br.po", language)

-------------------------------------------------------------------------------
--// Setup Dictionary
-------------------------------------------------------------------------------
local STRINGS_NEW = GLOBAL.LanguageTranslator.languages[language]
DICTIONARY =
{
	--// Examination Quote Fixes
	["Cast:"] = "Elenco:",

	-- I actually don't know if this works or not.
	["You can't make a coffee table out of gold."] = "Não dá pra fazer uma mesa de centro de ouro.",
	["Well, maybe you can. But you shouldn't."] = "Bem, talvez dê. Mas 'cê não deveria.",

	--// Main Menu News
	-- These are not actual in-game strings. I need to copy them manually for every update.
	-- I might keep some past entries here just in case they reappear in future updates.
	["Official Discord"] = "Discord Oficial",
	["Check out the official Klei Discord!"] = "Dê uma olhada no Discord oficial da Klei!",
	
	["Now Available!"] = "Já Disponível!",
	--["Winter's Feast Returns!"] = "O Festival de Inverno Está de Volta!",
	--["Hallowed Nights Returns!"] = "As Noites Assombradas Estão de de Volta!",
	
	--["Klei Publishing"] = "Publicação da Klei",

	--["The Roadmap!"] = "O Cronograma!",
	--["See what we have planned for xxxx!"] = "Veja o que planejamos para xxxx!",
	
	--["Introducing:"] = "Introduzindo:",
	
	["The Moonbound and Stampeder Collections!"] = "As Coleções Aluadas e Desertadas!",
	["The Hostile Takeover Update is live!"] = "A Atualização Dominação Hostil já saiu!",		
	
	["New Twitch Drop!"] = "Novo Drop da Twitch!",
	["The Gathering Amulet"] = "O Amuleto Coletor",		

	--// Screen Fixes
	-- ServerListingScreen
	["Servidores de Survival"]   = "Servidores de Sobrevivência",
	["Servidores de Endless"]	= "Servidores Infinitos",
	["Servidores de Relaxed"]	= "Servidores Descontraídos",
	["Servidores de Wilderness"] = "Servidores Selvagens",
	["Servidores de Qualquer"]   = "Qualquer Servidor",
	["Servidores de Lights Out"] = "Servidores de Blecaute",
	
	-- Not exactly fixes. More so a way to make the strings feel a bit more natural.
	["Fim de Outono"]	   = "Fim do Outono",
	["Início de Outono"]	= "Início do Outono",
	["Fim de Inverno"]	  = "Fim do Inverno",
	["Início de Inverno"]   = "Início do Inverno",
	["Fim de Primavera"]	= "Fim da Primavera",
	["Início de Primavera"] = "Início da Primavera",
	["Fim de Verão"]		= "Fim do Verão",
	["Início de Verão"] 	= "Início do Verão",
	
	-- ServerCreationScreen
	["Long Day"] = "Dia Longo",
	["Long Dusk"] = "Tarde Longa",
	["Long Night"] = "Noite Longa",
	
	["No Day"] = "Dia Longo",
	["No Dusk"] = "Tarde Longa",
	["No Night"] = "Noite Longa",
	
	["Only Day"] = "Somente Dia",
	["Only Dusk"] = "Somente Tarde",
	["Only Night"] = "Somente Noite",
	
	--// Others
	-- Keep some separation between actual entries and internal fixes.
	-- This helps when some strings are context-sensitive.
	ANNOUNCE =
	{
		["The Eye of Terror turns its gaze toward "] = "O Olho do Terror olha para ",
		["The Twins turn their gaze toward "] = "Os Gêmeos olham para ",
	},

	CAVESELECT =
	{
		["No "] = "Sem ",
	
		["Play with "] = "Jogar com ",	
		[", requires more PC Power as it runs multiple servers"] = ", requer mais Processamento do PC já que roda múltiplos servidores",
		
		["Play with no "] = "Jogar sem ",
		[", sad, but not as demanding on a computer"] = ", triste, mas não exige tanto do computador",
	},
	
	BLUEPRINTS =
	{
		["blueprint"] = "Projeto de",
		["sketch"] = "Esboço de",
		["tacklesketch"] = "Anúncio de",
		["cookingrecipecard"] = "Cartão de Receita de",
	},
}

local function BuildDictionary(node, root)
	for k, v in pairs(node) do
		if type(v) == "table" then
			BuildDictionary(node[k], root.."."..k)
		else
			local val = STRINGS_NEW[root.."."..k]
			if val ~= nil then
				DICTIONARY[v] = val
			end
		end
	end
end
BuildDictionary(STRINGS, "STRINGS")

--// Everything from this point forward has been written entirely by me (HowlingBreeze).
-------------------------------------------------------------------------------
--// Extension Calls
-------------------------------------------------------------------------------
local function TranslateSpeech()
	modimport("scripts/translators/speech.lua")
end

local function TranslateAnnouncements()
	modimport("scripts/translators/announce.lua")
end

local function TranslateScreens()
	modimport("scripts/translators/screens.lua")
end

-------------------------------------------------------------------------------
--// Cookbook Handler
-------------------------------------------------------------------------------
local function DoFoodSideEffectTranslation(food_table)
	for i, food in ipairs(food_table) do
		if food.oneat_desc ~= nil then
			food.oneat_desc = DICTIONARY[food.oneat_desc] or food.oneat_desc
		end
	end
end

local function TranslateFoodSideEffects()
	GLOBAL.scheduler:ExecuteInTime(0, function()
		DoFoodSideEffectTranslation(require("preparedfoods"))
		DoFoodSideEffectTranslation(require("preparednonfoods"))
		DoFoodSideEffectTranslation(require("preparedfoods_warly"))
	end)
end

-------------------------------------------------------------------------------
--// Skilltree Handler
-------------------------------------------------------------------------------
local function DoTreeTranslation(tree)
	for k, def in pairs(tree) do
		if def ~= nil then
			if def.title ~= nil then
				def.title = DICTIONARY[def.title] or def.title
			end
			
			if def.desc ~= nil then
				def.desc = DICTIONARY[def.desc] or def.desc
			end
		end
	end
end

local function TranslateSkillTrees()
	local skills = require("prefabs/skilltree_defs")
	local characters = GLOBAL.DST_CHARACTERLIST
	for i, chr in ipairs(characters) do
		local tree = skills.SKILLTREE_DEFS[chr]
		if tree ~= nil then
			DoTreeTranslation(tree)
		end
	end
end

-------------------------------------------------------------------------------
--// Execute Enabled Handlers
-------------------------------------------------------------------------------
Execute(TranslateScreens, "TOGGLE_SCREENS")

Execute(TranslateSpeech, "TOGGLE_SPEECH")
Execute(TranslateAnnouncements, "TOGGLE_ANNOUNCEMENTS")
Execute(TranslateSkillTrees, "TOGGLE_SKILLTREES")
Execute(TranslateFoodSideEffects, "TOGGLE_COOKBOOK")

-------------------------------------------------------------------------------
--// Final Tweaks
-------------------------------------------------------------------------------
--// I'm using keys here to make it easier to find them from the prefabs.
--// While this isn't exactly the best way to do this, it does open some oportunities for custom name handling in the future, if needed.
local BOSSES =
{
	["alterguardian_phase1"] = true,
	["alterguardian_phase2"] = true,
	["alterguardian_phase3"] = true,
	["bearger"] = true,
	["beequeen"] = true,
	["crabking"] = true,
	["deerclops"] = true,
	["dragonfly"] = true,
	["leif"] = true,
	["leif_sparse"] = true,
	["malbatross"] = true,
	["mutateddeerclops"] = true,
	["mutatedbearger"] = true,
	["moose"] = true,
	["spiderqueen"] = true,
	["stalker_atrium"] = true,
	["toadstool"] = true,
	["toadstool_dark"] = true,
}

local UNTRANSLATE_NOTBOSSES = GetModConfigData("TOGGLE_NOTBOSSES")
local UNTRANSLATE_BOSSES = GetModConfigData("TOGGLE_BOSSES")
local DEVMODE = GetModConfigData("TOGGLE_DEVMODE")
local SHOW_OLD_NAMES = GetModConfigData("TOGGLE_ORIGINAL")
local SMART_NAMES = SHOW_OLD_NAMES and (SHOW_OLD_NAMES == 1 or SHOW_OLD_NAMES == 3)
local LINE_BREAK = SHOW_OLD_NAMES and (SHOW_OLD_NAMES == 2 or SHOW_OLD_NAMES == 3)

local USE_PREFIX = GLOBAL.USE_PREFIX
--// Change variables slightly after the game to make sure I'm overriding stuff.
GLOBAL.scheduler:ExecuteInTime(0.01, function()
	--// From "dlcsupport_strings.lua"
	USE_PREFIX[STRINGS.SMOLDERINGITEM] = false
	USE_PREFIX[STRINGS.WITHEREDITEM] = false
	USE_PREFIX[STRINGS.WET_PREFIX.FOOD] = false
	USE_PREFIX[STRINGS.WET_PREFIX.CLOTHING] = false
	USE_PREFIX[STRINGS.WET_PREFIX.TOOL] = false
	USE_PREFIX[STRINGS.WET_PREFIX.FUEL] = false
	USE_PREFIX[STRINGS.WET_PREFIX.GENERIC] = false
	USE_PREFIX[STRINGS.WET_PREFIX.WETGOOP] = false
	USE_PREFIX[STRINGS.WET_PREFIX.RABBITHOLE] = false
	USE_PREFIX[STRINGS.NAMES.RABBITHOLE] = false

	USE_PREFIX[STRINGS.WAXEDPLANT] = false
	USE_PREFIX[STRINGS.BROKENITEM] = false
	USE_PREFIX[STRINGS.DEADCREATURE] = false
	
	--// From "scripts/languages/loc.lua"
	function GLOBAL.LOC.GetNamesImageSuffix()
		return UNTRANSLATE_NOTBOSSES and "" or "_br"
	end
	
	--// From "characterutil.lua"
	function GLOBAL.SetHeroNameTexture_Gold(image_widget, character)
		local loc_suffix = (character == "wonkey" or character == "random") and GLOBAL.LOC.GetNamesImageSuffix() or ""
		local hero_atlas = "images/names_gold" .. loc_suffix .. "_" .. character..".xml"
		if GLOBAL.softresolvefilepath(hero_atlas) then
			image_widget:SetTexture(hero_atlas, character..".tex")
			return true
		else
			return GLOBAL.SetHeroNameTexture_Grey(image_widget, character)
		end
	end
	
	--// Custom Name Handler
	for k, old_name in pairs(OLD_STRINGS.NAMES) do
		local boss = BOSSES[k:lower()]
		if STRINGS.NAMES[k] ~= nil and (not boss and UNTRANSLATE_NOTBOSSES or UNTRANSLATE_BOSSES) then
			STRINGS.NAMES[k] = old_name
		end
	end
	
	if SHOW_OLD_NAMES and not SMART_NAMES then
		for k, name in pairs(STRINGS.NAMES) do
			local untranslated = OLD_STRINGS.NAMES[k]
			if untranslated ~= nil and name ~= untranslated then			
				STRINGS.NAMES[k] = name .. (LINE_BREAK and "\n" or " ").."("..untranslated..")"
			end
		end
	end
end)

local function DoNameExtension(inst, name, extension)
	if SMART_NAMES and not GLOBAL.TheWorld.ismastersim then
		extension = extension or OLD_STRINGS.NAMES[string.upper(inst.food_basename or inst.nameoverride or inst.prefab)]
		if extension ~= nil and name ~= extension then
			return name..(LINE_BREAK and "\n" or " ").."("..extension..")"
		end
	end
	
	return name
end

--------------------------------
local BLUEPRINTS =
{
	["blueprint"] = "Blueprint",
	["sketch"] = "Sketch",
	["tacklesketch"] = "Advert",
	["cookingrecipecard"] = "Recipe Card",
}

--// PostInit for Names
AddPrefabPostInitAny(function(inst)
	if inst:HasTag("player") or inst.prefab == nil --[[or (not DEVMODE and GLOBAL.TheWorld.ismastersim)]] then
		--// Disable for mastersim to prevent it from translating things for other clients.**
		--// **Do I really need this? The game will already act weird on caveless servers regardless. Maybe I should just allow it?
		return
	end
	
	inst:DoTaskInTime(0.1, function(inst)
		local display_name = inst:GetBasicDisplayName()
		if inst.replica.named ~= nil and inst.prefab ~= "beefalo" and inst.prefab ~= "kitcoon" and inst.prefab ~= "moose" then
			local blueprint = BLUEPRINTS[inst.prefab]
			if GetModConfigData("TOGGLE_BLUEPRINTS") and blueprint then
				local s, e = display_name:find(blueprint)
				
				if s and e then
					local item_name = display_name:sub(1, s-2)
					inst.name = DoNameExtension(inst, DICTIONARY.BLUEPRINTS[inst.prefab].." "..(DICTIONARY[item_name] or item_name), item_name.." "..blueprint)
				end
			elseif GetModConfigData("TOGGLE_NAMED") and not blueprint then
				inst.name = DICTIONARY[inst.name] or display_name --// I don't think anyone cares for names in extensions...
			end
		elseif not UNTRANSLATE_NOTBOSSES and (inst.prefab:find("wetgoop") and inst.displaynamefn ~= nil or inst.prefab == "wetgoop") then
			inst.no_wet_prefix = true
				
			local old_displaynamefn = inst.displaynamefn
			local function DisplayNameFn(...)
				local name = inst.prefab == "wetgoop" and display_name or old_displaynamefn ~= nil and old_displaynamefn(...)
				
				if inst.replica.inventoryitem:IsWet() then
					name = name:gsub("Molhada", "Muito Molhada")
				end
				
				return DoNameExtension(inst, name)
			end
			inst.displaynamefn = DisplayNameFn
		else
			local boss = BOSSES[inst.prefab] ~= nil
			if boss and UNTRANSLATE_BOSSES or not boss and UNTRANSLATE_NOTBOSSES then
				inst.name = OLD_STRINGS.NAMES[string.upper(inst.food_basename or inst.nameoverride or inst.prefab)]
			elseif display_name ~= DICTIONARY[display_name] then
				inst.name = STRINGS.NAMES[inst.nameoverride or inst.prefab] or display_name
			end
			
			inst.name = DoNameExtension(inst, inst.name)
		end
	end)
end)

-------------------------------------------------------------------------------
--// Other Mods (WIP)
-------------------------------------------------------------------------------
--[[if not GetModConfigData("MAIN_MODS") then
--	return
--end

local function BuildModDictionary(node)
	for k, v in pairs(node) do
		if type(v) == "table" then
			BuildModDictionary(node[k])
		elseif DICTIONARY[v] == nil then
			DICTIONARY[v] = "Teste."
			
			print(k, v, DICTIONARY[v])
		end
	end
end
BuildModDictionary(STRINGS)--, "STRINGS")]]