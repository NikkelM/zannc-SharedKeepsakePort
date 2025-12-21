---@meta _
---@diagnostic disable

local mods = rom.mods

---@module 'LuaENVY-ENVY-auto'
mods["LuaENVY-ENVY"].auto()

rom = rom
_PLUGIN = PLUGIN

---@module 'SGG_Modding-Hades2GameDef-Globals'
game = rom.game

---@module 'SGG_Modding-SJSON'
sjson = mods["SGG_Modding-SJSON"]

---@module 'SGG_Modding-ModUtil'
modutil = mods["SGG_Modding-ModUtil"]

---@module 'SGG_Modding-Chalk'
chalk = mods["SGG_Modding-Chalk"]

---@module 'SGG_Modding-ReLoad'
reload = mods["SGG_Modding-ReLoad"]

---@module 'zannc-GodsAPI-auto'
gods = mods["zannc-GodsAPI"].auto()

---@module 'zannc-SharedKeepsakePort-config'
config = chalk.auto("config.lua")
public.config = config

local function on_ready()
	local keepsakePort = mods["zannc-KeepsakePort"]
	mod.keepsakePortConfig = nil
	if keepsakePort then
		mod.keepsakePortConfig = keepsakePort.config
	end

	import("ready.lua")

	local names = {
		--*KeepsakePort
		"Hermes",
		"Persephone",
		-- "Chaos",
		-- "Megaera",
		-- "Nyx",
		--*SharedKeepsakePort
		"Sisyphus",
		"Eurydice",
		"Patroclus",
		"Thanatos",
	}

	for _, name in ipairs(names) do
		if config[name] and config[name].Enabled then
			import("keepsakes/keepsake_" .. string.lower(name) .. ".lua")
		end
		if mod.keepsakePortConfig[name] and mod.keepsakePortConfig[name].Enabled then
			import("keepsakes/keepsake_" .. string.lower(name) .. ".lua")
		end
	end
end

local function on_reload()
	import("reload.lua")
end

local loader = reload.auto_single()
modutil.once_loaded.game(function()
	if config.enabled == false then
		return
	end
	import_as_fallback(rom.game)
	mod = modutil.mod.Mod.Register(_PLUGIN.guid)

	mod.TraitTextFile = rom.path.combine(rom.paths.Content, "Game/Text/en/TraitText.en.sjson")
	mod.HelpTextFile = rom.path.combine(rom.paths.Content, "Game/Text/en/HelpText.en.sjson")
	mod.GUIBoonsVFXFile = rom.path.combine(rom.paths.Content, "Game/Animations/GUI_Boons_VFX.sjson")
	mod.GUIHUDVFXFile = rom.path.combine(rom.paths.Content, "Game/Animations/GUI_HUD_VFX.sjson")

	mod.Order = {
		"Id",
		"InheritFrom",
		"DisplayName",
		"Description",
		"Name",
		"FilePath",
		"EndFrame",
		"NumFrames",
		"PlaySpeed",
		"StartFrame",
		"Scale",
		"OffsetY",
		"OffsetX",
		"PlayBackwards",
		"AddColor",
		"FlipHorizontal",
		"Red",
		"Green",
		"Blue",
		"VisualFxIntervalMin",
		"VisualFxIntervalMax",
		"VisualFx",
		"Loop",
		"ChainTo",
	}

	mod.hades_Biomes = mods["NikkelM-Zagreus_Journey"]

	loader.load(on_ready, on_reload)

	local hermes_helptext_sjson = sjson.to_object({
		Id = _PLUGIN.guid .. "-Hint_ReportedxBonus",
		DisplayName = "Clear! {#UpgradeFormat}{$TempTextData.Amount:P}",
	}, mod.Order)

	sjson.hook(mod.HelpTextFile, function(data)
		table.insert(data.Texts, hermes_helptext_sjson)
	end)
end)
