name = "Patch Francais [DST]"
author = "Médéric Cossu (Medaey)"
version = "25.07.28.0342"
description = [[
=======================================
  Traduction française de Don't Starve Together
           ainsi que certains mods
=======================================
Contributeurs : Medaey, ArchMage, Khiwi, Maze, Lenmir, Rafi, Yokta, CurlySheep
----------------------------
Si ce mod vous plaît, un don PayPal pour offrir du café au développeur serait une belle motivation pour continuer à faire vivre le projet :
https://paypal.me/medericcossu
----------------------------
PS : Mod basé sur la traduction initiale de EALILY, Orka & Gaetanse. Un grand merci à eux.
============================
Version : ]] .. version

api_version = 10
priority = 0
mod_type = "localization"

dst_compatible = true
all_clients_require_mod = false
client_only_mod = true
server_filter_tags = {"translation", "french", "fr", "FR", "Francais", "mod", "language", "localization", "community", "DST", "Don't Starve Together", "translation_mod", "Francais"}

icon_atlas = "modicon.xml"
icon = "modicon.tex"

forumthread = ""

local headers = 0
local function MakeHeader(title)
	headers = headers + 1
	return { name = "header"..headers, label = title, options = { {description = "", data = 0}, }, default = 0, }
end

local options =
{
	toggle =
	{
		{description = "Oui", data = true},
		{description = "Non", data = false},
	},
	
	toggle_inverse =
	{
		{description = "Oui", data = false},
		{description = "Non", data = true},
	},

	switch =
	{
		{description = "Activé", data = true},
		{description = "Désactivé", data = false},
	},
}

configuration_options =	
{	
	MakeHeader("Général"),
	--[[
	{
		name = "MAIN_TRANSLATE",
		label = "Traduction",
		hover = "Active ou désactive la traduction du jeu. Utile si vous souhaitez uniquement que ce mod traduise d'autres mods.",
        options = options.switch,
        default = true,
	},]]
	{
		name = "TOGGLE_ORIGINAL",
		label = "Noms Originaux",
		hover = "Activez pour inclure le nom original des objets en plus du nom traduit.\nN'a aucun effet sur les serveurs sans cavernes hébergés par vous.",
        options =
		{
			{description = "Désactivé", data = false},
			{description = "Même Ligne", data = 0, hover = "Affiche le nom original juste après le nom traduit, entre parenthèses."},
			{description = "Même Ligne Alt.", data = 1, hover = "EXPERIMENTAL ! L’option Même Ligne ne s’activera que dans le Monde."},
			{description = "Saut de Ligne", data = 2, hover = "Affiche le nom original sous le nom traduit. Peut causer des bugs visuels."},
			{description = "Saut de Ligne Alt.", data = 3, hover = "EXPERIMENTAL ! L’option Saut de Ligne ne s’activera que dans le Monde."},
		},
        default = false,
	},
	
	MakeHeader("Modules (BETA)"),
	{
		name = "TOGGLE_SKILLTREES",
		label = "Arbres de Compétences",
		hover = "Active la traduction des Arbres de Compétences sur votre client.\nN'a aucun effet sur les serveurs sans cavernes hébergés par vous.",
        options = options.toggle,
        default = true,
	},
	--[[{
		name = "TOGGLE_WETGOOP",
		label = "Changer la Bouillie Mouillée",
		hover = "Active pour que la « Bouillie Mouillée » devienne « Bouillie Très Mouillée » au lieu de « Bouillie Vraiment Mouillée » lorsqu’elle est mouillée.",
        options =
        {
            {description = "Oui", data = true},
			{description = "Non", data = false},
		},
        default = true,
	},]]
	{
		name = "TOGGLE_SPEECH",
		label = "Dialogues de Personnages",
		hover = "Active la traduction des dialogues des personnages sur votre client.\nNe change rien sur les serveurs sans cavernes hébergés par vous.",
        options = options.toggle,
        default = true,
	},
	{
		name = "TOGGLE_COOKBOOK",
		label = "Livre de Recettes",
		hover = "Active la traduction des Effets Secondaires dans le Livre de Recettes sur votre client. Ne change rien sur les serveurs sans cavernes hébergés par vous.",
        options = options.toggle,
        default = true,
	},
	{
		name = "TOGGLE_ANNOUNCEMENTS",
		label = "Messages du Jeu",
		hover = "Active la traduction des annonces faites par le jeu dans le chat sur votre client.\nNe change rien sur les serveurs sans cavernes hébergés par vous.",
        options = options.toggle,
        default = true,
	},
	{
		name = "TOGGLE_SCREENS",
		label = "Menus",
		hover = "Permet à ce mod de traduire certains textes de menus qui ne sont normalement pas traduits. Quelques bugs mineurs, mais stable à l’usage.",
        options = options.toggle,
        default = true,
	},
	
	{
		name = "TOGGLE_BOSSES",
		label = "Noms des Bosses",
		hover = "Désactivez pour ne pas traduire les noms des boss, si vous préférez les noms originaux.",
        options = options.toggle_inverse,
        default = false,
	},
	{
		name = "TOGGLE_BLUEPRINTS",
		label = "Noms Divers",
		hover = "Active la traduction des noms des Plans, Ébauches et autres sur votre client. Ne change rien sur les serveurs sans cavernes hébergés par vous.",
        options = options.toggle,
        default = true,
	},
	{
		name = "TOGGLE_NOTBOSSES",
		label = "Noms Généraux",
		hover = "Désactivez pour ne traduire aucun nom (hors bosses), si vous préférez les noms originaux.",
        options = options.toggle_inverse,
        default = false,
	},
	{
		name = "TOGGLE_NAMED",
		label = "Noms Propres",
		hover = "Active la traduction des noms attribués à des créatures comme les Cochons-Nobles sur votre client. Ne change rien sur les serveurs sans cavernes hébergés par vous.",
        options = options.toggle,
        default = true,
	},
	
	MakeHeader("Autres"),
	{
		name = "TOGGLE_DEVMODE",
		label = "Mode Développeur",
		hover = "Supprime les limitations des serveurs sans cavernes hébergés par vous, entre autres choses. Peut causer des erreurs inattendues.",
        options = options.switch,
        default = false,
	},
	
	--[[
	MakeHeader("Extras"),
	{
		name = "TOGGLE_ADVANCEDTIPS",
		label = "Astuces Avancées",
		hover = "Affiche plus d’astuces à l’écran de chargement, axées sur des mécaniques obscures.\nPeut contenir des spoilers.",
        options = options.switch,
        default = false,
	},
	
	MakeHeader("Autres Mods"),
	{
		name = "MAIN_MODS",
		label = "Traduire les Mods",
		hover = "Active ou désactive la traduction de tous les mods en une fois. Lorsqu'activé, fonctionne selon les options ci-dessous.",
        options = options.switch,
        default = false,
	},
	{
		name = "MOD_STATUSANNOUNCEMENTS",
		label = "Status Announcements",
		hover = "Traduit le contenu du mod Status Announcements, si activé, avec des adaptations différentes de la version officielle.",
        options = options.toggle,
        default = false,
	},
	{
		name = "MOD_UNCOMP",
		label = "Uncompromising Mode",
		hover = "Traduit le contenu du mod Uncompromising Mode, si activé.",
        options = options.toggle,
        default = false,
	},
	{
		name = "MOD_LEGION",
		label = "Legion",
		hover = "Traduit le contenu du mod Legion, si activé.",
        options = options.toggle,
        default = false,
	},]]
	
	MakeHeader("Version "..version..""),
}
