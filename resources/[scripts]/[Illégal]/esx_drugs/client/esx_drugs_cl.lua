local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local cokeQTE       			= 0
ESX 			    			= nil
local coke_poochQTE 			= 0
local weedQTE					= 0
local weed_poochQTE 			= 0
local methQTE					= 0
local meth_poochQTE 			= 0
local opiumQTE					= 0
local opium_poochQTE 			= 0
local lsdQTE					= 0
local lsd_poochQTE 			    = 0
local myJob 					= nil
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local isInZone                  = false
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local Licenses          = {}


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		TriggerServerEvent('esx_drugs:ChargementLicenses')
		Citizen.Wait(0)
	end
end)

AddEventHandler('esx_drugs:hasEnteredMarker', function(zone)
	if myJob == 'police' then
		CurrentActionMsg  = _U('police_message')
		CurrentActionData = {}
	end

	ESX.UI.Menu.CloseAll()
	
	if zone == 'exitMarker' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('exit_marker')
		CurrentActionData = {}
	end
	
	if zone == 'CokeField' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('press_collect_coke')
		CurrentActionData = {}
	end

	if zone == 'CokeProcessing' then
		if cokeQTE >= 5 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_process_coke')
			CurrentActionData = {}
		end
	end

	if zone == 'CokeDealer' then
		if coke_poochQTE >= 1 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_sell_coke')
			CurrentActionData = {}
		end
	end

	if zone == 'MethField' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('press_collect_meth')
		CurrentActionData = {}
	end

	if zone == 'MethProcessing' then
		if methQTE >= 5 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_process_meth')
			CurrentActionData = {}
		end
	end

	if zone == 'MethDealer' then
		if meth_poochQTE >= 1 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_sell_meth')
			CurrentActionData = {}
		end
	end

	if zone == 'WeedField' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('press_collect_weed')
		CurrentActionData = {}
	end

	if zone == 'WeedField2' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('press_collect_weed')
		CurrentActionData = {}
	end

	if zone == 'WeedProcessing' then
		if weedQTE >= 5 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_process_weed')
			CurrentActionData = {}
		end
	end

	if zone == 'WeedDealer' then
		if weed_poochQTE >= 1 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_sell_weed')
			CurrentActionData = {}
		end
	end

	if zone == 'OpiumField' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('press_collect_opium')
		CurrentActionData = {}
	end

	if zone == 'OpiumProcessing' then
		if opiumQTE >= 5 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_process_opium')
			CurrentActionData = {}
		end
	end

	if zone == 'OpiumDealer' then
		if opium_poochQTE >= 1 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_sell_opium')
			CurrentActionData = {}
		end
	end

	if zone == 'LsdField' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('press_collect_lsd')
		CurrentActionData = {}
	end

	if zone == 'LsdProcessing' then
		if lsdQTE >= 5 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_process_lsd')
			CurrentActionData = {}
		end
	end

	if zone == 'LsdDealer' then
		if lsd_poochQTE >= 1 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_sell_lsd')
			CurrentActionData = {}
		end
	end

	if zone == 'TenuWeed' then
		CurrentAction     = zone
		CurrentActionMsg  = ('Appuyer sur E pour vous changez')
		CurrentActionData = {}
	end

	if zone == 'AmeWeed' then
		CurrentAction     = zone
		CurrentActionMsg  = ('Appuyer sur E pour améliorer votre récolte de weed')
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_drugs:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()

	TriggerServerEvent('esx_drugs:stopHarvestCoke')
	TriggerServerEvent('esx_drugs:stopTransformCoke')
	TriggerServerEvent('esx_drugs:stopSellCoke')
	TriggerServerEvent('esx_drugs:stopHarvestMeth')
	TriggerServerEvent('esx_drugs:stopTransformMeth')
	TriggerServerEvent('esx_drugs:stopSellMeth')
	TriggerServerEvent('esx_drugs:stopHarvestWeed')
	TriggerServerEvent('esx_drugs:stopTransformWeed')
	TriggerServerEvent('esx_drugs:stopSellWeed')
	TriggerServerEvent('esx_drugs:stopHarvestOpium')
	TriggerServerEvent('esx_drugs:stopTransformOpium')
	TriggerServerEvent('esx_drugs:stopSellOpium')
	TriggerServerEvent('esx_drugs:stopHarvestLsd')
	TriggerServerEvent('esx_drugs:stopTransformLsd')
	TriggerServerEvent('esx_drugs:stopSellLsd')
end)

-- Weed Effect
RegisterNetEvent('esx_drugs:onPot')
AddEventHandler('esx_drugs:onPot', function()
	RequestAnimSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")
	while not HasAnimSetLoaded("MOVE_M@DRUNK@SLIGHTLYDRUNK") do
		Citizen.Wait(0)
	end
	TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_SMOKING_POT", 0, true)
	Citizen.Wait(5000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	ClearPedTasksImmediately(GetPlayerPed(-1))
	SetTimecycleModifier("spectator5")
	SetPedMotionBlur(GetPlayerPed(-1), true)
	SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	SetPedIsDrunk(GetPlayerPed(-1), true)
	DoScreenFadeIn(1000)
	Citizen.Wait(600000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	DoScreenFadeIn(1000)
	ClearTimecycleModifier()
	ResetScenarioTypesEnabled()
	ResetPedMovementClipset(GetPlayerPed(-1), 0)
	SetPedIsDrunk(GetPlayerPed(-1), false)
	SetPedMotionBlur(GetPlayerPed(-1), false)
end)

-- Render markers
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		local coords = GetEntityCoords(GetPlayerPed(-1))

		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DrawDistance) then
				DrawMarker(Config.MarkerType, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
		end
		if(GetDistanceBetweenCoords(coords, 1060.09, -3183.28, -39.764, true) < Config.DrawDistance) then -- Changement de tenu Weed
			DrawMarker(32, 1060.09, -3183.28, -38.464, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
		end
		if(GetDistanceBetweenCoords(coords, 1044.54, -3194.72, -37.158, true) < Config.DrawDistance) then -- Amélioration Weed
			DrawMarker(20, 1044.54, -3194.72, -37.158, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
		end
	end
end)

if Config.ShowBlips then
	-- Create blips
	Citizen.CreateThread(function()
		for k,v in pairs(Config.Zones) do
			local blip = AddBlipForCoord(v.x, v.y, v.z)

			SetBlipSprite (blip, v.sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 0.9)
			SetBlipColour (blip, v.color)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.name)
			EndTextCommandSetBlipName(blip)
		end
	end)
end


-- RETURN NUMBER OF ITEMS FROM SERVER
RegisterNetEvent('esx_drugs:ReturnInventory')
AddEventHandler('esx_drugs:ReturnInventory', function(cokeNbr, cokepNbr, methNbr, methpNbr, weedNbr, weedpNbr, opiumNbr, opiumpNbr, lsdNbr, lsdpNbr, jobName, currentZone)
	cokeQTE	   = cokeNbr
	coke_poochQTE = cokepNbr
	methQTE 	  = methNbr
	meth_poochQTE = methpNbr
	weedQTE 	  = weedNbr
	weed_poochQTE = weedpNbr
	opiumQTE	   = opiumNbr
	opium_poochQTE = opiumpNbr
	lsdQTE        = lsdNbr
	lsd_poochQTE  = lsdpNbr
	myJob		 = jobName
	TriggerEvent('esx_drugs:hasEnteredMarker', currentZone)
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.ZoneSize.x) then
				isInMarker  = true
				currentZone = k
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			lastZone				= currentZone
			TriggerServerEvent('esx_drugs:GetUserInventory', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_drugs:hasExitedMarker', lastZone)
		end

		if isInMarker and isInZone then
			TriggerEvent('esx_drugs:hasEnteredMarker', 'exitMarker')

		end
	end
end)

local tenueWeed = false

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if CurrentAction ~= nil then
			local playerPed        = GetPlayerPed(-1)
			local ownedLicenses = {}
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlJustReleased(0, Keys['E']) then
				if myJob == 'police' then
					ESX.ShowNotification( _U('police_message'))
				else
					isInZone = true -- unless we set this boolean to false, we will always freeze the user
					if CurrentAction == 'exitMarker' then
						isInZone = false -- do not freeze user
						TriggerEvent('esx_drugs:freezePlayer', false)
						TriggerEvent('esx_drugs:hasExitedMarker', lastZone)
						ClearPedTasks(playerPed)
						Citizen.Wait(5000)
					elseif CurrentAction == 'CokeField' then
						TriggerServerEvent('esx_drugs:startHarvestCoke')
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
						ESX.ShowNotification("~s~Vous ramassez de la ~g~Coke~n~.")
					elseif CurrentAction == 'CokeProcessing' then
						TriggerServerEvent('esx_drugs:startTransformCoke')
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
						ESX.ShowNotification("~s~Vous traitez de la ~g~Coke~n~.")
					elseif CurrentAction == 'CokeDealer' then
						TriggerServerEvent('esx_drugs:startSellCoke')
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
						ESX.ShowNotification("~s~Vous Vendez de la ~g~Coke~n~.")
					elseif CurrentAction == 'MethField' then
						TriggerServerEvent('esx_drugs:startHarvestMeth')
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
						ESX.ShowNotification("~s~Vous ramassez de la ~g~Meth~n~.")
					elseif CurrentAction == 'MethProcessing' then
						TriggerServerEvent('esx_drugs:startTransformMeth')
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
						ESX.ShowNotification("~s~Vous Traitez de la ~g~Meth~n~.")
					elseif CurrentAction == 'MethDealer' then
						TriggerServerEvent('esx_drugs:startSellMeth')
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
						ESX.ShowNotification("~s~Vous vendez de la ~g~Meth~n~.")

					-- Récolte weed avec amélioration 	
					elseif CurrentAction == 'WeedField' then 
						if tenueWeed == true then

							for i=1, #Licenses, 1 do
								ownedLicenses[Licenses[i].type] = true
							end
							if ownedLicenses['AmeliorationWeed4'] then
								TriggerServerEvent('esx_drugs:startHarvestWeed', 4)
								TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
								ESX.ShowNotification("📨 	~s~Vous ramassez de la ~g~Weed~n~ ~s~Attention seulement ~r~5~w~ de weed pour consommation perso.")
							elseif ownedLicenses['AmeliorationWeed3'] then
								TriggerServerEvent('esx_drugs:startHarvestWeed', 3)
								TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
								ESX.ShowNotification("📨 	~s~Vous ramassez de la ~g~Weed~n~ ~s~Attention seulement ~r~5~w~ de weed pour consommation perso.")
							elseif ownedLicenses['AmeliorationWeed2'] then
								TriggerServerEvent('esx_drugs:startHarvestWeed', 2)
								TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
								ESX.ShowNotification("📨 	~s~Vous ramassez de la ~g~Weed~n~ ~s~Attention seulement ~r~5~w~ de weed pour consommation perso.")
							elseif ownedLicenses['AmeliorationWeed1'] then
								TriggerServerEvent('esx_drugs:startHarvestWeed', 1)
								TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
								ESX.ShowNotification("📨 	~s~Vous ramassez de la ~g~Weed~n~ ~s~Attention seulement ~r~5~w~ de weed pour consommation perso.")
							else
								TriggerServerEvent('esx_drugs:startHarvestWeed', 0)
								TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
								ESX.ShowNotification("📨 	~s~Vous ramassez de la ~g~Weed~n~ ~s~Attention seulement ~r~5~w~ de weed pour consommation perso.")
							end
						elseif tenueWeed == false then
							ESX.ShowNotification("📨 	~s~Attention, Vous devez avoir votre tenu pour faire de la weed.")
						end
					elseif CurrentAction == 'WeedField2' then 

						for i=1, #Licenses, 1 do
							ownedLicenses[Licenses[i].type] = true
						end
						if ownedLicenses['AmeliorationWeed4'] then
							TriggerServerEvent('esx_drugs:startHarvestWeed', 4)
							TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
							ESX.ShowNotification("📨 	~s~Vous ramassez de la ~g~Weed~n~ ~s~Attention seulement ~r~5~w~ de weed pour consommation perso.")
						elseif ownedLicenses['AmeliorationWeed3'] then
							TriggerServerEvent('esx_drugs:startHarvestWeed', 3)
							TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
							ESX.ShowNotification("📨 	~s~Vous ramassez de la ~g~Weed~n~ ~s~Attention seulement ~r~5~w~ de weed pour consommation perso.")
						elseif ownedLicenses['AmeliorationWeed2'] then
							TriggerServerEvent('esx_drugs:startHarvestWeed', 2)
							TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
							ESX.ShowNotification("📨 	~s~Vous ramassez de la ~g~Weed~n~ ~s~Attention seulement ~r~5~w~ de weed pour consommation perso.")
						elseif ownedLicenses['AmeliorationWeed1'] then
							TriggerServerEvent('esx_drugs:startHarvestWeed', 1)
							TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
							ESX.ShowNotification("📨 	~s~Vous ramassez de la ~g~Weed~n~ ~s~Attention seulement ~r~5~w~ de weed pour consommation perso.")
						else
							TriggerServerEvent('esx_drugs:startHarvestWeed', 0)
							TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
							ESX.ShowNotification("📨 	~s~Vous ramassez de la ~g~Weed~n~ ~s~Attention seulement ~r~5~w~ de weed pour consommation perso.")
						end

					-- Fin de la récolte weed avec amélioration	
					elseif CurrentAction == 'WeedProcessing' then
						if tenueWeed == true then
							TriggerServerEvent('esx_drugs:startTransformWeed')
							TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
							ESX.ShowNotification("📨 	~s~Vous traitez de la ~g~Weed~n~ ~s~Attention vous êtes dans ~r~l'illégalité.")
						elseif tenueWeed == false then
							ESX.ShowNotification("📨 	~s~Attention, Vous devez avoir votre tenu pour faire de la weed.")
						end
					elseif CurrentAction == 'WeedDealer' then
						TriggerServerEvent('esx_drugs:startSellWeed')
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
						ESX.ShowNotification("~s~Vous vendez de la ~g~Weed~n~ ~s~Attention vous êtes dans ~r~l'illégalité.")
					elseif CurrentAction == 'OpiumField' then
						TriggerServerEvent('esx_drugs:startHarvestOpium')
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
						ESX.ShowNotification("~s~Vous ramassez de la ~g~L'opium~n~.")
					elseif CurrentAction == 'OpiumProcessing' then
						TriggerServerEvent('esx_drugs:startTransformOpium')
						ESX.ShowNotification("~s~Vous Traitez de la ~g~L'opium~n~.")
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
					elseif CurrentAction == 'OpiumDealer' then
						TriggerServerEvent('esx_drugs:startSellOpium')
						ESX.ShowNotification("~s~Vous vendez de la ~g~L'opium~n~.")
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
					elseif CurrentAction == 'LsdField' then
						TriggerServerEvent('esx_drugs:startHarvestLsd')
					elseif CurrentAction == 'LsdProcessing' then
						TriggerServerEvent('esx_drugs:startTransformLsd')
					elseif CurrentAction == 'LsdDealer' then
						TriggerServerEvent('esx_drugs:startSellLsd')
					elseif CurrentAction == 'TenuWeed' then
						if tenueWeed == false then
							isInZone = false
							ESX.ShowNotification('Vous avez mis votre tenu')
							TriggerEvent('skinchanger:getSkin', function(skin)
								local clothesSkin = {
									['bags_1'] = 41, ['bags_2'] = 0,
									['tshirt_1'] = 62, ['tshirt_2'] = 0,
									['torso_1'] = 67, ['torso_2'] = 0,
									['arms'] = 88,
									['pants_1'] = 40, ['pants_2'] = 0,
									['shoes_1'] = 24, ['shoes_2'] = 0,
									['mask_1'] = 46, ['mask_2'] = 0,
									['bproof_1'] = 0,
									['helmet_1'] = -1, ['helmet_2'] = 0
								}
								TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
								tenueWeed = true
							end)
						elseif tenueWeed == true then
							isInZone = false
							tenueWeed = false
							ESX.ShowNotification('Vous avez mis votre tenu Civil')
							ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
								local isMale = skin.sex == 0
								TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
									ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
										TriggerEvent('skinchanger:loadSkin', skin)
										TriggerEvent('esx:restoreLoadout')
									end)
								end)
							end)
							
						end
					elseif CurrentAction == 'AmeWeed' then
						isInZone = false
						OpenAmeWeed()
					else
						isInZone = false -- not a esx_drugs zone
					end

					if isInZone then
						TriggerEvent('esx_drugs:freezePlayer', true)
					end

					CurrentAction = nil
				end
			end
		end
	end
end)

function OpenAmeWeed()
	local ownedLicenses = {}

	for i=1, #Licenses, 1 do
		ownedLicenses[Licenses[i].type] = true
	end

	local elements = {}

	if not ownedLicenses['AmeliorationWeed1'] then
		table.insert(elements, {
			label = 'Amélioration récolte weed Nv.1',
			value = 'WeedAme1'
		})
	end

	if ownedLicenses['AmeliorationWeed1'] then
		if not ownedLicenses['AmeliorationWeed2'] then
			table.insert(elements, {
				label = 'Amélioration récolte weed Nv.2',
				value = 'WeedAme2',
				type = 'AmeliorationWeed2'
			})
		end

		if ownedLicenses['AmeliorationWeed2'] then
			if not ownedLicenses['AmeliorationWeed3'] then
				table.insert(elements, {
					label = 'Amélioration récolte weed Nv.3',
					value = 'WeedAme3',
					type = 'AmeliorationWeed3'
				})
			end

			if ownedLicenses['AmeliorationWeed3'] then
				if not ownedLicenses['AmeliorationWeed4'] then
					table.insert(elements, {
						label = 'Amélioration récolte weed Nv.4',
						value = 'WeedAme4',
						type = 'AmeliorationWeed4'
				})
				end
			end
		end
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dmvschool_actions', {
		title    = 'Amélioration Weed',
		elements = elements,
		align    = 'top-left'
	}, function(data, menu)
		if data.current.value == 'WeedAme1' then
			menu.close()
			TriggerServerEvent('esx_drugs:AmeWeed1')
		elseif data.current.value == 'WeedAme2' then
			menu.close()
			TriggerServerEvent('esx_drugs:AmeWeed2')
		elseif data.current.value == 'WeedAme3' then
			menu.close()
			TriggerServerEvent('esx_drugs:AmeWeed3')
		elseif data.current.value == 'WeedAme4' then
			menu.close()
			TriggerServerEvent('esx_drugs:AmeWeed4')
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'AmeWeed'
		CurrentActionMsg  = "Appuyer sur E pour ouvrir le menu d'amélioration Weed"
		CurrentActionData = {}
	end)
end


RegisterNetEvent('esx_drugs:loadLicenses')
AddEventHandler('esx_drugs:loadLicenses', function(licenses)
	Licenses = licenses
end)


RegisterNetEvent('esx_drugs:AmeWeed1')
AddEventHandler('esx_drugs:AmeWeed1', function()
	FreezeEntityPosition(GetPlayerPed(-1), freeze)
end)

RegisterNetEvent('esx_drugs:freezePlayer')
AddEventHandler('esx_drugs:freezePlayer', function(freeze)
	FreezeEntityPosition(GetPlayerPed(-1), freeze)
end)
