local maxReq = {}
local minReq = {}

if mod.hades_Biomes then
	maxReq = {
		PathTrue = { "GameState", "TextLinesRecord", "EurydiceGift08" },
	}
	minReq = {
		PathTrue = { "GameState", "TextLinesRecord", "EurydiceGift01" },
	}
end

gods.CreateKeepsake({
	characterName = "Eurydice",
	internalKeepsakeName = "ShieldBossKeepsake",

	RarityLevels = {
		Common = { Multiplier = config.Eurydice.a_KeepsakeCommon },
		Rare = { Multiplier = config.Eurydice.b_KeepsakeRare },
		Epic = { Multiplier = config.Eurydice.c_KeepsakeEpic },
		Heroic = { Multiplier = config.Eurydice.d_KeepsakeHeroic },
	},

	ExtractValues = {
		{
			Key = "BossEncounterShieldHits",
			ExtractAs = "TooltipHits",
		},
	},

	EquipSound = "/SFX/Menu Sounds/KeepsakeEurydiceAcorn",

	Keepsake = {
		displayName = "Evergreen Acorn",
		description = "In the final encounter in each region, take {#BoldFormatGraft}0 {#Prev}damage the first {#AltUpgradeFormat}{$TooltipData.ExtractData.TooltipHits} {#Prev}times foes hit you.",
		trayDescription = "In the final encounter in each region, take {#BoldFormatGraft}0 {#Prev}damage the first {#AltUpgradeFormat}{$TooltipData.ExtractData.TooltipHits} {#Prev}times foes hit you.",
		signoffMax = "From {#AwardMaxFormat}Eurydice{#Prev}; you share an {#AwardMaxFormat}Inspiring Bond{#Prev}.{!Icons.ObjectiveSeparatorDark}Singing for the joy of it, she lives for the moment, even in death.",
	},

	Icons = {
		iconPath = "GUI\\Screens\\AwardMenu\\Evergreen_Acorn",
		maxIcon = "GUI\\Screens\\AwardMenu\\KeepsakeMaxGift\\Eurydice_02",
		maxCornerIcon = "GUI\\Screens\\AwardMenu\\KeepsakeMaxGift\\Eurydice",
	},

	customGiftData = {
		customName = "NPC_Eurydice_01",
		maxRequirement = maxReq,
		minRequirement = minReq,
	},

	ExtraFields = {
		BossEncounterShieldHits = { BaseValue = 1 },
		BossShieldFx = "MelShieldFront",
	},
})
