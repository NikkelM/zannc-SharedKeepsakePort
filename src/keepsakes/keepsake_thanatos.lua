local mods = rom.mods
local hades_Biomes = mods["NikkelM-Zagreus_Journey"]

function CreateKeepsake_Thanatos()
	table.insert(game.ScreenData.KeepsakeRack.ItemOrder, "PerfectClearDamageBonusKeepsake")

	if hades_Biomes then
		game.GiftData.NPC_Thanatos_01 = {
			InheritFrom = { "DefaultGiftData" },
			MaxedRequirement = {
				{
					PathTrue = { "GameState", "TextLinesRecord", "ThanatosGift10" },
				},
			},
			MaxedIcon = "Keepsake_Thanatos_Corner",
			MaxedSticker = "Keepsake_Thanatos",
			[1] = {
				GameStateRequirements = {
					{
						PathTrue = { "GameState", "TextLinesRecord", "ThanatosGift01" },
					},
				},
				Gift = "PerfectClearDamageBonusKeepsake",
			},
		}
	else
		game.GiftData.NPC_Thanatos_01 = {
			[1] = {
				Gift = "PerfectClearDamageBonusKeepsake",
			},
			InheritFrom = { "DefaultGiftData" },
			Name = "PerfectClearDamageBonusKeepsake",
		}
	end

	game.TraitData.PerfectClearDamageBonusKeepsake = {
		Icon = "Pierced_Butterfly",
		InheritFrom = { "GiftTrait" },
		Name = "PerfectClearDamageBonusKeepsake",
		CustomTrayText = "PerfectClearDamageBonusKeepsake_Tray",

		-- Always add these, so it SHUTS UP
		ShowInHUD = true,
		Ordered = true,
		HUDScale = 0.435,
		PriorityDisplay = true,
		ChamberThresholds = { 25, 50 },
		HideInRunHistory = true,
		Slot = "Keepsake",
		InfoBackingAnimation = "KeepsakeSlotBase",
		RecordCacheOnEquip = true,
		TraitOrderingValueCache = -1,
		ActiveSlotOffsetIndex = 0,

		FrameRarities = {
			Common = "Frame_Keepsake_Rank1",
			Rare = "Frame_Keepsake_Rank2",
			Epic = "Frame_Keepsake_Rank3",
			Heroic = "Frame_Keepsake_Rank4",
		},

		CustomRarityLevels = {
			"TraitLevel_Keepsake1",
			"TraitLevel_Keepsake2",
			"TraitLevel_Keepsake3",
			"TraitLevel_Keepsake4",
		},

		RarityLevels = {
			Common = { Multiplier = config.Thanatos.a_KeepsakeCommon },
			Rare = { Multiplier = config.Thanatos.b_KeepsakeRare },
			Epic = { Multiplier = config.Thanatos.c_KeepsakeEpic },
			Heroic = { Multiplier = config.Thanatos.d_KeepsakeHeroic },
		},

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

		SignOffData = {
			{
				GameStateRequirements = {
					{
						PathTrue = { "GameState", "TextLinesRecord", "ThanatosGift10" },
					},
				},
				Text = "SignoffThanatos_Max",
			},
			{
				Text = "SignoffThanatos",
			},
		},
	}
end

local keepsake_thanatos = sjson.to_object({
	Id = "PerfectClearDamageBonusKeepsake_Tray",
	InheritFrom = "PerfectClearDamageBonusKeepsake",
	Description = "Gain bonus damage each time you clear an {$Keywords.EncounterAlt} without taking damage.\n{#StatFormat}Bonus Damage: {#UpgradeFormat}{$TooltipData.ExtractData.TooltipAccumulatedBonus:P} {#Prev}",
}, Order)

local keepsakerack_thanatos = sjson.to_object({
	Id = "PerfectClearDamageBonusKeepsake",
	InheritFrom = "BaseBoonMultiline",
	DisplayName = "Pierced Butterfly",
	Description = "Gain {#UpgradeFormat}{$TooltipData.ExtractData.TooltipPerfectClearBonus:P} {#Prev}increased damage each time you clear an {$Keywords.EncounterAlt} without taking damage.",
}, Order)

local signoff_thanatos = sjson.to_object({
	Id = "SignoffThanatos",
	DisplayName = "From Thanatos",
}, Order)

local signoff_thanatosmax = sjson.to_object({
	Id = "SignoffThanatos_Max",
	DisplayName = "From {#AwardMaxFormat}Thanatos{#Prev}; you share a {#AwardMaxFormat}Undying Bond{#Prev}.{!Icons.ObjectiveSeparatorDark}With whom should Death belong, if not with Blood, with Life?",
}, Order)

-- Clear Message in room
local helptext_sjson = sjson.to_object({
	Id = "Hint_PerfectClearDamageBonus",
	DisplayName = "Clear! {#UpgradeFormat}{$TempTextData.ExtractData.TooltipPerfectClearBonus:P}",
}, HelpTextOrder)

-- Icon JSON data
local keepsakeicon_thanatos = sjson.to_object({
	Name = "Pierced_Butterfly",
	InheritFrom = "KeepsakeIcon",
	FilePath = rom.path.combine(_PLUGIN.guid, "GUI\\Screens\\AwardMenu\\Pierced_Butterfly"),
}, IconOrder)

local keepsakemaxCorner_thanatos = sjson.to_object({
	Name = "Keepsake_Thanatos_Corner",
	InheritFrom = "KeepsakeMax_Corner",
	FilePath = rom.path.combine(_PLUGIN.guid, "GUI\\Screens\\AwardMenu\\KeepsakeMaxGift\\Thanatos"),
}, IconOrder)

local keepsakemax_thanatos = sjson.to_object({
	Name = "Keepsake_Thanatos",
	InheritFrom = "KeepsakeMax",
	FilePath = rom.path.combine(_PLUGIN.guid, "GUI\\Screens\\AwardMenu\\KeepsakeMaxGift\\Thanatos_02"),
}, IconOrder)

sjson.hook(TraitTextFile, function(data)
	table.insert(data.Texts, keepsake_thanatos)
	table.insert(data.Texts, keepsakerack_thanatos)
	table.insert(data.Texts, signoff_thanatos)
	table.insert(data.Texts, signoff_thanatosmax)
end)

sjson.hook(GUIBoonsVFXFile, function(data)
	table.insert(data.Animations, keepsakeicon_thanatos)
	table.insert(data.Animations, keepsakemaxCorner_thanatos)
	table.insert(data.Animations, keepsakemax_thanatos)
end)

sjson.hook(HelpTextFile, function(data)
	table.insert(data.Texts, helptext_sjson)
end)

CreateKeepsake_Thanatos()
