local maxReq = {}
local minReq = {}
if mod.keepsakePortConfig.enableGifting then
	maxReq = {
		PathTrue = { "GameState", "TextLinesRecord", "HadesWithPersephoneGift06" },
	}
	minReq = {
		PathTrue = { "GameState", "TextLinesRecord", "HadesWithPersephoneGift01" },
	}
end

gods.CreateKeepsake({
	characterName = "Persephone",
	internalKeepsakeName = "ChamberStackTrait",

	RarityLevels = { --TODO Config for this.
		Common = { Multiplier = 1.0 },
		Rare = { Multiplier = 5 / 6 },
		Epic = { Multiplier = 4 / 6 },
		Heroic = { Multiplier = 3 / 6 },
		-- Common = { Multiplier = mod.keepsakePortConfig.Hermes.a_KeepsakeCommon },
	},

	ExtractValues = {
		{
			Key = "ReportedRoomsPerUpgrade",
			ExtractAs = "TooltipRoomInterval",
		},
	},

	EquipSound = nil,

	Keepsake = {
		displayName = "Pom Blossom",
		description = "After every {#AltUpgradeFormat}{$TooltipData.ExtractData.TooltipRoomInterval} {#Prev}{$Keywords.EncounterPlural}, gain {#UseGiftPointFormat}+1 Lv.{!Icons.Pom} {#Prev}{#ItalicFormat}(a random {$Keywords.GodBoon} grows stronger){#Prev}",
		signoffMax = "From {#AwardMaxFormat}Persephone{#Prev}; you share a {#AwardMaxFormat}Growing Bond{#Prev}.{!Icons.ObjectiveSeparatorDark}The dead live on in the underworld, and her nurturing instinct there also thrives.",
	},

	Icons = {
		iconPath = "GUI\\Screens\\AwardMenu\\Pom_Blossom",
		maxIcon = "GUI\\Screens\\AwardMenu\\KeepsakeMaxGift\\Persephone_02",
		maxCornerIcon = "GUI\\Screens\\AwardMenu\\KeepsakeMaxGift\\Persephone",
	},

	customGiftData = {
		customName = "NPC_Persephone_01",
		maxRequirement = maxReq,
		minRequirement = minReq,
	},

	ExtraFields = {
		RoomsPerUpgrade = {
			Amount = {
				BaseValue = 6,
			},
			TraitStacks = 1, -- Adding cause of TraitLogic in h2
			ReportValues = {
				ReportedRoomsPerUpgrade = "Amount",
			},
		},
		CurrentRoom = 0,
	},
})
