local maxReq = {}
local minReq = {}

if mod.hades_Biomes then
	maxReq = {
		PathTrue = { "GameState", "TextLinesRecord", "ThanatosGift10" },
	}
	minReq = {
		PathTrue = { "GameState", "TextLinesRecord", "ThanatosGift01" },
	}
end

gods.CreateKeepsake({
	characterName = "Thanatos",
	internalKeepsakeName = "ShieldBossKeepsake",

	RarityLevels = {
		Common = { Multiplier = config.Thanatos.a_KeepsakeCommon },
		Rare = { Multiplier = config.Thanatos.b_KeepsakeRare },
		Epic = { Multiplier = config.Thanatos.c_KeepsakeEpic },
		Heroic = { Multiplier = config.Thanatos.d_KeepsakeHeroic },
	},

	ExtractValues = {
		{
			Key = "PerfectClearDamageBonus",
			ExtractAs = "TooltipPerfectClearBonus",
			Format = "PercentDelta",
			DecimalPlaces = 1,
		},
		{
			Key = "AccumulatedDamageBonus",
			ExtractAs = "TooltipAccumulatedBonus",
			Format = "PercentDelta",
			DecimalPlaces = 1,
		},
	},

	EquipSound = "/SFX/Menu Sounds/KeepsakeEurydiceAcorn",

	Keepsake = {
		displayName = "Evergreen Acorn",
		description = "Gain {#UpgradeFormat}{$TooltipData.ExtractData.TooltipPerfectClearBonus:P} {#Prev}increased damage each time you clear an {$Keywords.EncounterAlt} without taking damage.",
		trayDescription = "Gain bonus damage each time you clear an {$Keywords.EncounterAlt} without taking damage.\n{#StatFormat}Bonus Damage: {#UpgradeFormat}{$TooltipData.ExtractData.TooltipAccumulatedBonus:P}{#Prev}",
		signoffMax = "From {#AwardMaxFormat}Thanatos{#Prev}; you share a {#AwardMaxFormat}Undying Bond{#Prev}.{!Icons.ObjectiveSeparatorDark}With whom should Death belong, if not with Blood, with Life?",
	},

	Icons = {
		iconPath = "GUI\\Screens\\AwardMenu\\Pierced_Butterfly",
		maxIcon = "GUI\\Screens\\AwardMenu\\KeepsakeMaxGift\\Thanatos_02",
		maxCornerIcon = "GUI\\Screens\\AwardMenu\\KeepsakeMaxGift\\Thanatos",
	},

	customGiftData = {
		maxRequirement = maxReq,
		minRequirement = minReq,
	},

	ExtraFields = {
		PerfectClearDamageBonus = {
			BaseValue = 1.01,
			SourceIsMultiplier = true,
			DecimalPlaces = 3,
		},
		AddOutgoingDamageModifiers = {
			UseTraitValue = "AccumulatedDamageBonus",
		},
		AccumulatedDamageBonus = 1,
		CustomLabel = {}, -- lifehack
	},
})
