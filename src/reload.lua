---@diagnostic disable: undefined-global
---@meta _
---@diagnostic disable: lowercase-global

local patroKeepsake = gods.GetInternalKeepsakeName(patroKeepsake)
local thanaKeepsake = gods.GetInternalKeepsakeName("PerfectClearDamageBonusKeepsake")
local hermesKeepsake = gods.GetInternalKeepsakeName("FastClearDodgeBonusKeepsake")

modutil.mod.Path.Wrap("TraitUICreateText", function(base, trait, args)
	base(trait, args)
	if trait.CustomLabel then
		if trait.AccumulatedDamageBonus then --* Thanatos
			local total = (trait.AccumulatedDamageBonus - 1) * 100
			local text = "UI_TimedKillBuff"
			CreateTextBox({
				Id = trait.TraitInfoCardId,
				Text = text,
				Font = "P22UndergroundSCMedium",
				FontSize = 22,
				Color = Color.White,
				ShadowBlur = 0,
				ShadowColor = { 0, 0, 0, 1 },
				ShadowOffset = { 1, 2 },
				OffsetX = xOffset,
				OffsetY = yOffset,
				Justification = "Center",
				DataProperties = {
					TextSymbolScale = 0.7,
					TextSymbolOffsetY = 3,
				},
				LuaKey = "TempTextData",
				LuaValue = { Value = total },
			})
		end
		if trait.AccumulatedDodgeBonus then --* Hermes
			local total = (trait.AccumulatedDodgeBonus - 1) * 100
			local text = "UI_TimedKillBuff"
			CreateTextBox({
				Id = trait.TraitInfoCardId,
				Text = text,
				Font = "P22UndergroundSCMedium",
				FontSize = 22,
				Color = Color.White,
				ShadowBlur = 0,
				ShadowColor = { 0, 0, 0, 1 },
				ShadowOffset = { 1, 2 },
				OffsetX = xOffset,
				OffsetY = yOffset,
				Justification = "Center",
				DataProperties = {
					TextSymbolScale = 0.7,
					TextSymbolOffsetY = 3,
				},
				LuaKey = "TempTextData",
				LuaValue = { Value = total },
			})
		end
	end
end)

local function CheckForKeepsakeTraits(args)
	if HeroHasTrait(patroKeepsake) then
		local traitData = GetHeroTrait(patroKeepsake)
		if
			traitData.OnSelfDamagedFunction
			and traitData.OnSelfDamagedFunction.FunctionArgs
			and traitData.OnSelfDamagedFunction.FunctionArgs.Cooldown
			and CheckCooldownNoTrigger("PatroclusInvulnerability" .. CurrentRun.Hero.ObjectId, traitData.OnSelfDamagedFunction.FunctionArgs.Cooldown, true)
		then
			TraitUIActivateTrait(traitData, args)
		end
	end

	if HeroHasTrait(thanaKeepsake) then
		local traitData = GetHeroTrait(thanaKeepsake)
		local currentRoom = game.CurrentRun.CurrentRoom
		if currentRoom and not game.CurrentRun.Hero.IsDead and currentRoom.Encounter ~= nil and currentRoom.Encounter.EncounterType ~= "NonCombat" and not currentRoom.Encounter.Completed and not currentRoom.Encounter.PlayerTookDamage then
			TraitUIActivateTrait(traitData, args)
		end
	end
end

function EndEncounterEffects_wrap(base, currentRun, currentRoom, currentEncounter)
	if GetHeroTrait(patroKeepsake) then
		TraitUIDeactivateTrait(traitData)
	end

	if currentEncounter == currentRoom.Encounter or currentEncounter == game.MapState.EncounterOverride then
		-- For Thanatos
		if game.CurrentRun.CurrentRoom.Encounter.PlayerTookDamage ~= nil then
			currentEncounter.PlayerTookDamage = game.CurrentRun.CurrentRoom.Encounter.PlayerTookDamage
		end

		-- if not currentRoom.BlockClearRewards then
		for k, traitData in pairs(CurrentRun.Hero.Traits) do
			if not currentEncounter.PlayerTookDamage and traitData.PerfectClearDamageBonus and currentRoom.Encounter.EncounterType ~= "NonCombat" then
				traitData.AccumulatedDamageBonus = traitData.AccumulatedDamageBonus + (traitData.PerfectClearDamageBonus - 1)
				PerfectClearTraitSuccessPresentation(traitData)
				local thanatosTrait = GetHeroTrait(thanaKeepsake)
				rom.log.warning(thanatosTrait) --TODO cant i just use k?
				UpdateTraitNumber(thanatosTrait)

				-- CurrentRun.CurrentRoom.PerfectEncounterCleared = true
			elseif currentEncounter.PlayerTookDamage and traitData.PerfectClearDamageBonus then
				PerfectClearTraitFailedPresentation(traitData)
			end
		end
	end
end

function StartEncounterEffects_wrap(base, encounter)
	CheckForKeepsakeTraits()
end

function TraitUIActivateTraits_Wrap(base, args)
	CheckForKeepsakeTraits()
end

function DamageHero_wrap(base, victim, triggerArgs)
	if triggerArgs.DamageAmount ~= nil and triggerArgs.DamageAmount > 0 and not triggerArgs.Silent then
		if game.CurrentRun.CurrentRoom.Encounter ~= nil and game.CurrentRun.CurrentRoom.Encounter.InProgress and not triggerArgs.PureDamage then
			game.CurrentRun.CurrentRoom.Encounter.PlayerTookDamage = true

			if HeroHasTrait(thanaKeepsake) then
				local traitData = GetHeroTrait(thanaKeepsake)
				TraitUIDeactivateTrait(traitData)
			end
		end
	end
end

function PerfectClearTraitFailedPresentation(traitData)
	wait(0.30)
	TraitUIDeactivateTrait(traitData)
	PlaySound({ Name = "/SFX/ThanatosHermesKeepsakeFail" })
	-- thread(PlayVoiceLines, HeroVoiceLines.KeepsakeChallengeFailedVoiceLines, true)
	-- local existingTraitData = GetExistingUITrait(traitData)
	-- if existingTraitData and existingTraitData.AnchorId ~= nil then
	-- 	Shake({ Id = existingTraitData.AnchorId, Distance = 3, Speed = 200, Duration = 0.25 })
	-- end
	Flash({ Speed = 2, MinFraction = 0, MaxFraction = 0.8, Color = Color.Black, ExpireAfterCycle = true })
	ShakeScreen({ Speed = 400, Distance = 4, FalloffSpeed = 1000, Duration = 0.3 })
end

function PerfectClearTraitSuccessPresentation(traitData)
	wait(0.50)
	TraitUIDeactivateTrait(traitData)
	local existingTraitData = GetExistingUITrait(traitData)
	if existingTraitData ~= nil and existingTraitData.AnchorId ~= nil then
		CreateAnimation({ Name = "KeepsakeSparkleEmitter", DestinationId = existingTraitData.AnchorId, GroupName = "Overlay" })
		PlaySound({ Name = existingTraitData.EquipSound or "/Leftovers/Menu Sounds/TalismanPowderDownLEGENDARY", Id = CurrentRun.Hero.ObjectId })
	end
	CreateAnimation({ Name = "KeepsakeLevelUpFlare", DestinationId = CurrentRun.Hero.ObjectId, Scale = 1.0 })
	local soundId = PlaySound({ Name = "/SFX/ThanatosAttackBell", Id = CurrentRun.Hero.ObjectId })
	SetVolume({ Id = soundId, Value = 0.3 })
	thread(InCombatText, CurrentRun.Hero.ObjectId, "zannc-SharedKeepsakePort-Hint_PerfectClearDamageBonus", 2.0, { ShadowScaleX = 1.5, LuaKey = "TempTextData", LuaValue = traitData })
	ShakeScreen({ Speed = 200, Distance = 4, FalloffSpeed = 1000, Duration = 0.3 })
end

--

--#region why
-- print(game.CurrentRun.CurrentRoom.Encounter.PlayerTookDamage)

-- print(game.CurrentRun.CurrentRoom.BlockClearRewards) -- where tf did this come from
-- print(game.CurrentRun.CurrentRoom.PerfectEncounterCleared) -- why am i doing this?

-- if ScreenState.ActiveObjectives.PerfectClear ~= nil then
-- 	thread(MarkObjectiveFailed, "PerfectClear")
-- 	PerfectClearObjectiveFailedPresentation(CurrentRun)
-- end

-- and IsCombatEncounterActive(CurrentRun)
-- if game.CurrentRun.CurrentRoom.Encounter.PlayerTookDamage and not game.CurrentRun.CurrentRoom.PerfectEncounterCleared then
-- 	for i, traitData in ipairs(game.CurrentRun.Hero.Traits) do
-- 		local perfectClearDamageData = traitData.PerfectClearDamageBonus
-- 		if perfectClearDamageData then
-- 			PerfectClearTraitFailedPresentation(traitData)
-- 		end
-- 	end
-- end
--#endregion

--#region new
-- function StartEncounterEffects_wrap(base, encounter)
-- 	-- encounter.StartTime = CurrentRun.GameplayTime could I use this?

-- 	-- Assign a start counter to all active encounters, specifically for Hermes boon
-- 	if game.CurrentRun.CurrentRoom.ActiveEncounters ~= nil then
-- 		for k, encounter in pairs(game.CurrentRun.CurrentRoom.ActiveEncounters) do
-- 			encounter.StartTime = game._worldTime
-- 			-- print(encounter.StartTime)
-- 			-- print(game._worldTime)
-- 			-- print(game.CurrentRun.GameplayTime)
-- 		end
-- 	end
-- end

-- function FastClearThread(clearTimeThreshold, dodgeTraitData)
-- 	wait(clearTimeThreshold, RoomThreadName)
-- 	if CurrentRun and CurrentRun.CurrentRoom and CurrentRun.CurrentRoom.Encounter and not CurrentRun.CurrentRoom.Encounter.Completed and not CurrentRun.CurrentRoom.Encounter.BossKillPresentation then
-- 		FastClearTraitFailedPresentation(dodgeTraitData)
-- 	end
-- end

-- function EndEncounterEffects_wrap(base, currentRun, currentRoom, currentEncounter)
-- 	if currentEncounter == currentRoom.Encounter or currentEncounter == game.MapState.EncounterOverride then
-- 		-- For Hermes in fields, very crude but hopefully works, makes it so if encounter has threshold
-- 		-- calculate the clear time, else set clear time to arbritrary high number to fail encounter automatically (done to combat NPC rooms)
-- 		-- if currentEncounter.FastClearThreshold then
-- 		if currentEncounter.FastClearThreshold then
-- 			for k, encounter in pairs(CurrentRun.CurrentRoom.ActiveEncounters) do
-- 				-- Check clear time, used later in original function
-- 				currentEncounter.ClearTime = game._worldTime - encounter.StartTime
-- 			end
-- 		else
-- 			-- If no threshold, either its undefined, broken, or NPC/NonCombat room, set clear time to 200 to auto fail hermes
-- 			currentEncounter.ClearTime = 200
-- 		end

-- 		for k, traitData in pairs(CurrentRun.Hero.Traits) do
-- 			if traitData.FastClearThreshold then
-- 				-- local clearTimeThreshold = currentEncounter.FastClearThreshold or traitData.FastClearThreshold
-- 				if currentEncounter.ClearTime < (currentEncounter.FastClearThreshold or traitData.FastClearThreshold) and traitData.FastClearDodgeBonus then
-- 					local lastDodgeBonus = traitData.AccumulatedDodgeBonus
-- 					SetLifeProperty({ Property = "DodgeChance", Value = -1 * lastDodgeBonus, ValueChangeType = "Add", DestinationId = CurrentRun.Hero.ObjectId, DataValue = false })
-- 					SetUnitProperty({ Property = "Speed", Value = 1 / (1 + lastDodgeBonus), ValueChangeType = "Multiply", DestinationId = CurrentRun.Hero.ObjectId })

-- 					traitData.AccumulatedDodgeBonus = traitData.AccumulatedDodgeBonus + traitData.FastClearDodgeBonus

-- 					SetLifeProperty({ Property = "DodgeChance", Value = traitData.AccumulatedDodgeBonus, ValueChangeType = "Add", DestinationId = CurrentRun.Hero.ObjectId, DataValue = false })
-- 					SetUnitProperty({ Property = "Speed", Value = 1 + traitData.AccumulatedDodgeBonus, ValueChangeType = "Multiply", DestinationId = CurrentRun.Hero.ObjectId })
-- 					thread(FastClearTraitSuccessPresentation, traitData)
-- 					-- CheckAchievement({ Name = "AchBuffedPlume", CurrentValue = traitData.AccumulatedDodgeBonus })
-- 				else
-- 					FastClearTraitFailedPresentation()
-- 				end
-- 			end
-- 		end
-- 	end
-- end

-- function FastClearTraitStartPresentation(clearTimeThreshold, traitData)
-- 	PlaySound({ Name = "/EmptyCue" })
-- 	TraitUIActivateTrait(traitData, { CustomAnimation = "ActiveTraitSingle_Custom", PlaySpeed = 30 / clearTimeThreshold })
-- end

-- function FastClearTraitFailedPresentation(traitData)
-- 	TraitUIDeactivateTrait(traitData)
-- 	PlaySound({ Name = "/SFX/ThanatosHermesKeepsakeFail" })
-- 	thread(PlayVoiceLines, HeroVoiceLines.KeepsakeChallengeFailedVoiceLines, true)
-- 	local existingTraitData = GetExistingUITrait(traitData)
-- 	if existingTraitData then
-- 		Shake({ Id = existingTraitData.AnchorId, Distance = 3, Speed = 500, Duration = 0.25 })
-- 		Flash({ Id = existingTraitData.AnchorId, Speed = 2, MinFraction = 0, MaxFraction = 0.8, Color = Color.Black, ExpireAfterCycle = true })
-- 	end
-- end

-- function FastClearTraitSuccessPresentation(traitData)
-- 	TraitUIDeactivateTrait(traitData)
-- 	thread(PlayVoiceLines, HeroVoiceLines.FastClearDodgeBonusUpgradedVoiceLines, true)
-- 	local existingTraitData = GetExistingUITrait(traitData)
-- 	if existingTraitData then
-- 		Flash({ Id = existingTraitData.AnchorId, Speed = 2, MinFraction = 0, MaxFraction = 0.8, Color = Color.LimeGreen, ExpireAfterCycle = true })
-- 		CreateAnimation({ Name = "SkillProcFeedbackFx", DestinationId = existingTraitData.AnchorId, GroupName = "Overlay" })
-- 	end
-- 	thread(InCombatText, CurrentRun.Hero.ObjectId, "zannc-SharedKeepsakePort-Hint_FastClearDamageBonus", 2.0, { ShadowScaleX = 1.5, LuaKey = "TempTextData", LuaValue = traitData })
-- 	wait(0.45, RoomThreadName)

-- 	local soundId = PlaySound({ Name = "/SFX/Player Sounds/HermesWhooshDashReverse" })
-- 	PlaySound({ Name = "/Leftovers/SFX/PositiveTalismanProc_3" })
-- 	SetVolume({ Id = soundId, Value = 0.3 })
-- 	CreateAnimation({ Name = "HermesWings", DestinationId = CurrentRun.Hero.ObjectId, Group = "FX_Standing_Top" })
-- 	ShakeScreen({ Speed = 500, Distance = 4, FalloffSpeed = 1000, Duration = 0.3 })
-- end
--#endregion
