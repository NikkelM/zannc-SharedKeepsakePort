local maxReq = {}
local minReq = {}
if mod.keepsakePortConfig.enableGifting then
	maxReq = {
		PathTrue = { "GameState", "TextLinesRecord", "HermesGift08" },
	}
	minReq = {
		PathTrue = { "GameState", "TextLinesRecord", "HermesGift01" },
	}
end

local guid = _PLUGIN.guid
gods.CreateKeepsake({
	characterName = "Hermes",
	internalKeepsakeName = "FastClearDodgeBonusKeepsake",

	RarityLevels = {
		Common = { Multiplier = mod.keepsakePortConfig.Hermes.a_KeepsakeCommon },
		Rare = { Multiplier = mod.keepsakePortConfig.Hermes.b_KeepsakeRare },
		Epic = { Multiplier = mod.keepsakePortConfig.Hermes.c_KeepsakeEpic },
		Heroic = { Multiplier = mod.keepsakePortConfig.Hermes.d_KeepsakeHeroic },
	},

	ExtractValues = {
		{
			Key = "FastClearDodgeBonus",
			ExtractAs = guid .. "-TooltipFastClearDodgeBonus", -- Don't really think i need to prefix this? since you would specifically call it?
			Format = "Percent",
			DecimalPlaces = 2,
		},
		{
			Key = "AccumulatedDodgeBonus",
			ExtractAs = "TooltipAccumulatedBonus",
			Format = "Percent",
			DecimalPlaces = 2,
		},
	},

	EquipSound = "/SFX/Menu Sounds/KeepsakeHermesDroplet",

	Keepsake = {
		displayName = "Lambent Plume",
		description = "Gain {#UpgradeFormat}{$TooltipData.ExtractData." .. guid .. "-TooltipFastClearDodgeBonus:P}{#Prev}{$Keywords.Dodge} chance and {#BoldFormatGraft}move {#Prev}speed each time you quickly clear an {$Keywords.EncounterAlt}.",
		trayDescription = "Gain greater {$Keywords.Dodge} chance and {#BoldFormatGraft}move {#Prev}speed each time you quickly clear an {$Keywords.EncounterAlt}.\n{#StatFormat}Dodge Chance & Move Speed: {#UpgradeFormat}{$TooltipData.ExtractData.TooltipAccumulatedBonus:P}{#Prev}",
		signoffMax = "From {#AwardMaxFormat}Hermes{#Prev}; you share a {#AwardMaxFormat}Quicksilver Bond{#Prev}.{!Icons.ObjectiveSeparatorDark}His carefree nature and his haste never betray his true capacity.",
	},

	Icons = {
		iconPath = "GUI\\Screens\\AwardMenu\\Lambent_Plume",
		maxIcon = "GUI\\Screens\\AwardMenu\\KeepsakeMaxGift\\Hermes_02",
		maxCornerIcon = "GUI\\Screens\\AwardMenu\\KeepsakeMaxGift\\Hermes",
	},

	customGiftData = {
		customName = "NPC_Hermes_01",
		maxRequirement = maxReq,
		minRequirement = minReq,
	},

	ExtraFields = {
		FastClearThreshold = 40,
		FastClearDodgeBonus = {
			BaseValue = 0.01,
			DecimalPlaces = 4,
		},

		FastClearSpeedBonus = {
			BaseValue = 0.01,
			DecimalPlaces = 4,
		},

		AccumulatedDodgeBonus = 0,
		ReportedxBonus = 1,
		CustomLabel = {}, -- lifehack
	},
})

local ActiveTraitSingle_Custom = sjson.to_object({
	Name = "ActiveTraitSingle_Custom",
	FilePath = "GUI\\HUD\\ActiveTraitTimer\\ActiveTraitTimer",
	GroupName = "Combat_Menu_Additive",
	EndFrame = 30,
	NumFrames = 30,
	PlaySpeed = 1,
	StartFrame = 1,
	Scale = 0.75,
	OffsetY = -10,
	OffsetX = 25,
	PlayBackwards = true,
	AddColor = true,
	FlipHorizontal = true,
	Red = 1,
	Green = 0.6,
	Blue = 0.1,
	VisualFxIntervalMin = 1.0,
	VisualFxIntervalMax = 1.00001,
	VisualFx = "ActiveTraitSingleFlash",
	Loop = false,
	ChainTo = "TraitUpdate",
}, mod.HUDOrder)

sjson.hook(mod.GUIHUDVFXFile, function(data)
	table.insert(data.Animations, ActiveTraitSingle_Custom)
end)

--#region ClearTimes
-- =================================================
--              Lua for Clear Times
-- EncounterData_Bos, EncounterData_Generated, EncounterData_MiniBoss, EncounterData
-- =================================================

game.EncounterData.BossEncounter.FastClearThreshold = 80 -- Generic Boss

game.EncounterData.BossPrometheus01.FastClearThreshold = 110 -- Prometheus
game.EncounterData.BossTyphonHead01.FastClearThreshold = 90 -- IDK
game.EncounterData.BossZagreus01.FastClearThreshold = 130 -- Zagreus

game.EncounterData.CapturePoint.FastClearThreshold = 55 -- Asphodel?
game.EncounterData.GeneratedAnomalyBase.FastClearThreshold = 55 -- Asphodel?

-- =================================================
--               Underground Regions
-- =================================================

-- Erebus Region
game.EncounterData.GeneratedF.FastClearThreshold = 25 -- Base Encounters
game.EncounterData.MiniBossTreant.FastClearThreshold = 35 -- Root Stalker/Weird Plant Boss Encounters
game.EncounterData.MiniBossFogEmitter.FastClearThreshold = 35 -- Shadow Spiller/Fog Encounters
game.EncounterData.BossHecate01.FastClearThreshold = 65 -- Hecate Boss Encounters

-- Oceanus Region
game.EncounterData.GeneratedG.FastClearThreshold = 40 -- Base Encounters
game.EncounterData.MiniBossWaterUnit.FastClearThreshold = 50 -- Spinny Boy Encounters
game.EncounterData.MiniBossCrawler.FastClearThreshold = 65 -- Uh Oh Encounters
game.EncounterData.BossScylla01.FastClearThreshold = 85 -- Scylla Encounters

-- Asphodel Region from Chronos
game.EncounterData.GeneratedAnomalyBase.FastClearThreshold = 60 -- Base Encounter

-- Fields Region
-- game.EncounterData.GeneratedH_Passive.FastClearThreshold = 40 -- Field Cage Encounters
-- game.EncounterData.GeneratedH_PassiveSmall.FastClearThreshold = 30 -- Small Field Cage Encounters
game.EncounterData.GeneratedH.FastClearThreshold = 30 -- Field Cage Encounters
game.EncounterData.MiniBossLamia.FastClearThreshold = 55 -- Lamia/Snake Thing Encounters
game.EncounterData.MiniBossVampire.FastClearThreshold = 70 -- Vampire Thing Encounters
game.EncounterData.BossInfestedCerberus01.FastClearThreshold = 100 -- Cerberus Boss Encounters

-- Tartarus/House Of Hades Region
game.EncounterData.GeneratedI.FastClearThreshold = 25 -- Base Encounters
game.EncounterData.MiniBossGoldElemental.FastClearThreshold = 35 -- GoldElemental/Weird Rat Thing idk Encounters
game.EncounterData.BossChronos01.FastClearThreshold = 130 -- Chronos Boss Encounters

--                  Surface Regions
-- =================================================
-- City of Ephyra Region
game.EncounterData.GeneratedN.FastClearThreshold = 35 -- Base & Hub Encounters
game.EncounterData.GeneratedN_Bigger.FastClearThreshold = 45 -- Big? Base Encounters
game.EncounterData.BossPolyphemus01.FastClearThreshold = 75 -- Polyphemus/Cyclops Boss Encounters

-- Rift of Thessaly Region
game.EncounterData.GeneratedO_Intro01.FastClearThreshold = 20 -- Intro Encounters
game.EncounterData.GeneratedO.FastClearThreshold = 40 -- Base Encounters
game.EncounterData.BossEris01.FastClearThreshold = 90 -- Eris Boss Encounters

-- Undone Region Stuff
game.EncounterData.GeneratedP.FastClearThreshold = 50
game.EncounterData.GeneratedQ.FastClearThreshold = 65

-- NPC encounters
game.EncounterData.BaseArtemisCombat.FastClearThreshold = 65 -- Artemis Encounters
game.EncounterData.BaseNemesisCombat.FastClearThreshold = 65 -- Nemesis Encounters cause idk if they will ever remove it
game.EncounterData.BaseHeraclesCombat.FastClearThreshold = 65 -- Heracles Encounters
game.EncounterData.BaseIcarusCombat.FastClearThreshold = 65 -- Icarus Encounters
game.EncounterData.BaseAthenaCombat.FastClearThreshold = 50 -- Athena

-- print(ModUtil.ToString.Deep(game.EncounterData))
--#endregion
