local maxReq = {}
local minReq = {}

if mod.hades_Biomes then
	maxReq = {
		PathTrue = { "GameState", "TextLinesRecord", "SisyphusGift09_A" },
	}
	minReq = {
		PathTrue = { "GameState", "TextLinesRecord", "SisyphusGift01" },
	}
end

gods.CreateKeepsake({
	characterName = "Sisyphus",
	internalKeepsakeName = "SisyphusVanillaKeepsake",

	RarityLevels = {
		Common = { Multiplier = config.Sisyphus.a_KeepsakeCommon },
		Rare = { Multiplier = config.Sisyphus.b_KeepsakeRare },
		Epic = { Multiplier = config.Sisyphus.c_KeepsakeEpic },
		Heroic = { Multiplier = config.Sisyphus.d_KeepsakeHeroic },
	},

	ExtractValues = {
		{
			Key = "ReportedWeaponMultiplier",
			ExtractAs = "TooltipBonus",
			Format = "PercentDelta",
			SkipAutoExtract = true,
		},
	},

	EquipSound = nil,

	Keepsake = {
		displayName = "Shattered Shackle",
		description = "Your {$Keywords.Attack}, {$Keywords.Special} and {$Keywords.Cast} each deal {#UpgradeFormat}{$TooltipData.ExtractData.TooltipBonus:P} {#Prev}damage while not empowered by a {$Keywords.GodBoon}.",
		trayDescription = "Your {$Keywords.Attack}, {$Keywords.Special} and {$Keywords.Cast} each deal {#UpgradeFormat}{$TooltipData.ExtractData.TooltipBonus:P} {#Prev}damage while not empowered by a {$Keywords.GodBoon}.",
		signoffMax = "From {#AwardMaxFormat}Sisyphus{#Prev}; you share a {#AwardMaxFormat}Rock-Solid Bond{#Prev}.{!Icons.ObjectiveSeparatorDark}If he can hoist a boulder on his own, he knows he can be of some support.",
	},

	Icons = {
		iconPath = "GUI\\Screens\\AwardMenu\\Shattered_Shackle",
		maxIcon = "GUI\\Screens\\AwardMenu\\KeepsakeMaxGift\\Sisyphus_02",
		maxCornerIcon = "GUI\\Screens\\AwardMenu\\KeepsakeMaxGift\\Sisyphus",
	},

	customGiftData = {
		-- customName = "NPC_Eurydice_01",
		maxRequirement = maxReq,
		minRequirement = minReq,
	},

	ExtraFields = {
		AddOutgoingDamageModifiers = {
			EmptySlotMultiplier = { BaseValue = 1.5, SourceIsMultiplier = true },
			EmptySlotValidData = {
				Melee = WeaponSets.HeroNonExWeapons,
				Secondary = WeaponSets.HeroSecondaryWeapons,
				Ranged = WeaponSets.HeroNonPhysicalWeapons,
			},
			ReportValues = { ReportedWeaponMultiplier = "EmptySlotMultiplier" },
		},
	},
})

-- =================================================
--                 Sisyphus SJSON
-- =================================================
-- Used for when you have it equipped
local keepsake_sisyphus = sjson.to_object({
	Id = "SisyphusVanillaKeepsake_Tray",
	InheritFrom = "SisyphusVanillaKeepsake",
	Description = "Your {$Keywords.Attack}, {$Keywords.Special} and {$Keywords.Cast} each deal {#UpgradeFormat}{$TooltipData.ExtractData.TooltipBonus:P} {#Prev}damage while not empowered by a {$Keywords.GodBoon}.",
}, Order)

-- In rack description
local keepsakerack_sisyphus = sjson.to_object({
	Id = "SisyphusVanillaKeepsake",
	InheritFrom = "BaseBoonMultiline",
	DisplayName = "Shattered Shackle",
	Description = "Your {$Keywords.Attack}, {$Keywords.Special} and {$Keywords.Cast} each deal {#UpgradeFormat}{$TooltipData.ExtractData.TooltipBonus:P} {#Prev}damage while not empowered by a {$Keywords.GodBoon}.",
}, Order)

local signoff_sisyphus = sjson.to_object({
	Id = "SignoffSisyphus",
	DisplayName = "From Sisyphus",
}, Order)

local signoff_sisyphusmax = sjson.to_object({
	Id = "SignoffSisyphus_Max",
	DisplayName = "From {#AwardMaxFormat}Sisyphus{#Prev}; you share a {#AwardMaxFormat}Rock-Solid Bond{#Prev}.{!Icons.ObjectiveSeparatorDark}If he can hoist a boulder on his own, he knows he can be of some support.",
}, Order)

-- Icon JSON data
local keepsakeicon_sisyphus = sjson.to_object({
	Name = "Shattered_Shackle",
	InheritFrom = "KeepsakeIcon",
	FilePath = rom.path.combine(_PLUGIN.guid, "GUI\\Screens\\AwardMenu\\Shattered_Shackle"),
}, IconOrder)

local keepsakemaxCorner_sisyphus = sjson.to_object({
	Name = "Keepsake_Sisyphus_Corner",
	InheritFrom = "KeepsakeMax_Corner",
	FilePath = rom.path.combine(_PLUGIN.guid, "GUI\\Screens\\AwardMenu\\KeepsakeMaxGift\\Sisyphus"),
}, IconOrder)

local keepsakemax_sisyphus = sjson.to_object({
	Name = "Keepsake_Sisyphus",
	InheritFrom = "KeepsakeMax",
	FilePath = rom.path.combine(_PLUGIN.guid, "GUI\\Screens\\AwardMenu\\KeepsakeMaxGift\\Sisyphus_02"),
}, IconOrder)

-- Inserting into SJSON
sjson.hook(TraitTextFile, function(data)
	table.insert(data.Texts, keepsake_sisyphus)
	table.insert(data.Texts, keepsakerack_sisyphus)
	table.insert(data.Texts, signoff_sisyphus)
	table.insert(data.Texts, signoff_sisyphusmax)
end)

-- Insert for Icons
sjson.hook(GUIBoonsVFXFile, function(data)
	table.insert(data.Animations, keepsakeicon_sisyphus)
	table.insert(data.Animations, keepsakemaxCorner_sisyphus)
	table.insert(data.Animations, keepsakemax_sisyphus)
end)

CreateKeepsake_Sisyphus()
