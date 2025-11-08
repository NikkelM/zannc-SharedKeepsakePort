---@meta _
---@diagnostic disable: lowercase-global

local function CheckForKeepsakeTraits(args)
	if HeroHasTrait("ShieldAfterHitKeepsake") then
		local traitData = GetHeroTrait("ShieldAfterHitKeepsake")
		if
			traitData.OnSelfDamagedFunction
			and traitData.OnSelfDamagedFunction.FunctionArgs
			and traitData.OnSelfDamagedFunction.FunctionArgs.Cooldown
			and CheckCooldownNoTrigger("PatroclusInvulnerability" .. CurrentRun.Hero.ObjectId, traitData.OnSelfDamagedFunction.FunctionArgs.Cooldown, true)
		then
			TraitUIActivateTrait(traitData, args)
		end
	end
	if HeroHasTrait("PerfectClearDamageBonusKeepsake") then
		local traitData = GetHeroTrait("PerfectClearDamageBonusKeepsake")
		-- if not game.CurrentRun.CurrentRoom.BlockClearRewards then
		local currentRoom = game.CurrentRun.CurrentRoom
		if currentRoom and not game.CurrentRun.Hero.IsDead and currentRoom.Encounter ~= nil and currentRoom.Encounter.EncounterType ~= "NonCombat" and not currentRoom.Encounter.Completed and not currentRoom.Encounter.PlayerTookDamage then
			TraitUIActivateTrait(traitData, args)
		end
		-- end
	end
end

function EndEncounterEffects_wrap(base, currentRun, currentRoom, currentEncounter)
	local traitData = GetHeroTrait("ShieldAfterHitKeepsake")

	if traitData then
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

			if game.HeroHasTrait("PerfectClearDamageBonusKeepsake") then
				local traitData = game.GetHeroTrait("PerfectClearDamageBonusKeepsake")
				game.TraitUIDeactivateTrait(traitData)
			end
		end
	end
end

function PerfectClearTraitFailedPresentation(traitData)
	wait(0.30)
	TraitUIDeactivateTrait(traitData)
	PlaySound({ Name = "/SFX/ThanatosHermesKeepsakeFail" })
	-- thread(PlayVoiceLines, HeroVoiceLines.KeepsakeChallengeFailedVoiceLines, true)
	local existingTraitData = GetExistingUITrait(traitData)
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
	thread(InCombatText, CurrentRun.Hero.ObjectId, "Hint_PerfectClearDamageBonus", 2.0, { ShadowScaleX = 1.5, LuaKey = "TempTextData", LuaValue = traitData })
	ShakeScreen({ Speed = 200, Distance = 4, FalloffSpeed = 1000, Duration = 0.3 })
end
