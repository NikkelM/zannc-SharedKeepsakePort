local maxReq = {}
local minReq = {}

if mod.hades_Biomes then
    maxReq = {
        PathTrue = { "GameState", "TextLinesRecord", "OrpheusGift08" },
    }
    minReq = {
        PathTrue = { "GameState", "TextLinesRecord", "OrpheusGift01" },
    }
end

gods.CreateKeepsake({
    characterName = "Orpheus",
    internalKeepsakeName = "DistanceDamageKeepsake",

    RarityLevels = {
        Common = { Multiplier = config.Orpheus.a_KeepsakeCommon },
        Rare = { Multiplier = config.Orpheus.b_KeepsakeRare },
        Epic = { Multiplier = config.Orpheus.c_KeepsakeEpic },
        Heroic = { Multiplier = config.Orpheus.d_KeepsakeHeroic },
    },

    ExtractValues = {
        {
            Key = "DistanceMultiplierReport",
            ExtractAs = "TooltipDamageBonus",
            Format = "PercentDelta",
        },
    },

    EquipSound = nil,

    Keepsake = {
        displayName = "Distant Memory",
        description = "Deal {#AltUpgradeFormat}{$TooltipData.ExtractData.TooltipDamageBonus:P} {#Prev}damage to distant foes.",
        signoffMax = "From {#AwardMaxFormat}Orpheus{#Prev}; you share a {#AwardMaxFormat}Sonorous Bond{#Prev}.{!Icons.ObjectiveSeparatorDark}Inspiration comes from unlikely places. Friendship comes in unlikely forms.",
    },

    Icons = {
        iconPath = "GUI\\Screens\\AwardMenu\\Distant_Memory",
        maxIcon = "GUI\\Screens\\AwardMenu\\KeepsakeMaxGift\\Orpheus_02",
        maxCornerIcon = "GUI\\Screens\\AwardMenu\\KeepsakeMaxGift\\Orpheus",
    },

    customGiftData = {
        customName = "NPC_Orpheus_01",
        maxRequirement = maxReq,
        minRequirement = minReq,
    },

    ExtraFields = {
        AddOutgoingDamageModifiers = {
            DistanceThreshold = 500,
            DistanceMultiplier = {
                BaseValue = 1.1,
                SourceIsMultiplier = true,
            },
            ReportValues = { DistanceMultiplierReport = "DistanceMultiplier" },
        },
    },
})
