-----------------------------------------
-- Created and modify by L'ile Légale RP
-- SenSi and Kaminosekai
-----------------------------------------


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

local PlayerData                = {}
local GUI                       = {}
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local JobBlips                = {}
local publicBlip = false
local SpawnVehicule = {coords = vector3(1200.3492, -1288.03, 35.217)}
ESX                             = nil
GUI.Time                        = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function TeleportFadeEffect(entity, coords)

	Citizen.CreateThread(function()

		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(0)
		end

		ESX.Game.Teleport(entity, coords, function()
			DoScreenFadeIn(800)
		end)

	end)
end

function OpenCloakroomMenu()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'cloakroom',
		{
			title    = _U('cloakroom'),
			align    = 'top-left',
			elements = {
				{label = _U('civil_clothes'), value = 'citizen_wear'},
				{label = _U('lumberjack_clothes'), value = 'lumberjack_wear'},
			},
		},
		function(data, menu)

			menu.close()

			if data.current.value == 'citizen_wear' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end

			if data.current.value == 'lumberjack_wear' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
					else
						TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
					end
				end)
			end

			CurrentAction     = 'lumberjack_actions_menu'
			CurrentActionMsg  = _U('open_menu')
			CurrentActionData = {}
		end,
		function(data, menu)
			menu.close()
		end
	)

end

function OpenLumberjackActionsMenu()

	local elements = {
        {label = _U('cloakroom'), value = 'cloakroom'},
		{label = _U('deposit_stock'), value = 'put_stock'}
	}

	if Config.EnablePlayerManagement and PlayerData.job ~= nil and (PlayerData.job.grade_name ~= 'recrue' and PlayerData.job.grade_name ~= 'novice')then -- Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss'
		table.insert(elements, {label = _U('take_stock'), value = 'get_stock'})
	end
  
	if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' then -- Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss'
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'lumberjack_actions',
		{
			title    = 'Bucherons',
			align    = 'top-left',
			elements = elements
		},
		
		function(data, menu)
			if data.current.value == 'cloakroom' then
				OpenCloakroomMenu()
			end

			if data.current.value == 'put_stock' then
				OpenPutStocksMenu()
			end

			if data.current.value == 'get_stock' then
				OpenGetStocksMenu()
			end

			if data.current.value == 'boss_actions' then
				TriggerEvent('esx_society:openBossMenu', 'lumberjack', function(data, menu)
					menu.close()
				end)
			end

		end,
		function(data, menu)

			menu.close()

			CurrentAction     = 'lumberjack_actions_menu'
			CurrentActionMsg  = _U('press_to_open')
			CurrentActionData = {}

		end
	)
end

function OpenVehicleSpawnerMenu()

	ESX.UI.Menu.CloseAll()

	if Config.EnableSocietyOwnedVehicles then

		local elements = {}

		ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(vehicles)

			for i=1, #vehicles, 1 do
				table.insert(elements, {label = GetDisplayNameFromVehicleModel(vehicles[i].model) .. ' [' .. vehicles[i].plate .. ']', value = vehicles[i]})
			end

			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'vehicle_spawner',
				{
					title    = _U('veh_menu'),
					align    = 'top-left',
					elements = elements,
				},
				function(data, menu)

					menu.close()

					local vehicleProps = data.current.value

					ESX.Game.SpawnVehicle(vehicleProps.model, Config.Zones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
						ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
						local playerPed = GetPlayerPed(-1)
						TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
						local playerPed = GetPlayerPed(-1)
						local playerVeh = GetVehiclePedIsIn(playerPed, true)
						SetVehicleNumberPlateText(playerVeh, 'LUMB WORK')
					end)

					TriggerServerEvent('esx_society:removeVehicleFromGarage', 'lumberjack', vehicleProps)

				end,
				function(data, menu)

					menu.close()

					CurrentAction     = 'vehicle_spawner_menu'
					CurrentActionMsg  = _U('spawn_veh')
					CurrentActionData = {}

				end
			)

		end, 'lumberjack')

	else
	
		local elements = {
			{label = 'Camion de bucheron',  value = 'phantom'},
		}
		
		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'vehicle_spawner',
			{
				title    = _U('veh_menu'),
				align    = 'top-left',
				elements = elements,
			},
			function(data, menu)

				menu.close()
				
				RequestModel(2112052861)
				while not HasModelLoaded(2112052861) do
					Citizen.Wait(0)
				end
				local spawn = ESX.Game.IsSpawnPointClear(SpawnVehicule.coords, 20)
				print(spawn)
				if spawn == false then
					--local despawn = ESX.Game.GetVehiclesInArea(SpawnVehicule.coords, 20)
					local despawn = ESX.Game.GetClosestVehicle(SpawnVehicule.coords)
					print(despawn)
					ESX.Game.DeleteVehicle(despawn)
				end

				local veh = CreateVehicle(2112052861, SpawnVehicule.coords, 261.71, true, true)
				local ped = PlayerPedId()
				TaskWarpPedIntoVehicle(ped, veh, -1)
				SetModelAsNoLongerNeeded(2112052861)
			end,
			function(data, menu)

				menu.close()

				CurrentAction     = 'vehicle_spawner_menu'
				CurrentActionMsg  = _U('spawn_veh')
				CurrentActionData = {}

			end
		)
	end
end

function OpenMobileLumberjackActionsMenu()

	ESX.UI.Menu.CloseAll()
	if PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' then
		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'mobile_lumberjack_actions',
			{
				title    = 'Bucherons',
				align    = 'top-left',
				elements = {
					{label = _U('billing'), value = 'billing'}
				}
			},
			function(data, menu)

				if data.current.value == 'billing' then

					ESX.UI.Menu.Open(
						'dialog', GetCurrentResourceName(), 'billing',
						{
							title = _U('invoice_amount')
						},
						function(data, menu)

							local amount = tonumber(data.value)

							if amount == nil or amount <= 0 then
								ESX.ShowNotification(_U('amount_invalid'))
							else
								menu.close()

								local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

								if closestPlayer == -1 or closestDistance > 3.0 then
									ESX.ShowNotification(_U('no_players_near'))
								else
									local playerPed        = GetPlayerPed(-1)

									Citizen.CreateThread(function()
										TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
										Citizen.Wait(5000)
										ClearPedTasks(playerPed)
										TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_lumberjack', 'Bucherons', amount)
									end)
								end
							end
						end,
						function(data, menu)
							menu.close()
						end
					)
				end
			end,
			function(data, menu)
				menu.close()
			end
		)
	end
end

function OpenGetStocksMenu()

	ESX.TriggerServerCallback('lumberjack:getStockItems', function(items)

		print(json.encode(items))

		local elements = {}

		for i=1, #items, 1 do
			if (items[i].count ~= 0) then
				table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
			end
		end

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'stocks_menu',
			{
				title    = 'Bucherons Stock',
				align    = 'top-left',
				elements = elements
			},
			function(data, menu)

				local itemName = data.current.value

				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
					{
						title = _U('quantity')
					},
					function(data2, menu2)
		
						local count = tonumber(data2.value)

						if count == nil or count <= 0 then
							ESX.ShowNotification(_U('quantity_invalid'))
						else
							menu2.close()
							menu.close()
							OpenGetStocksMenu()

							TriggerServerEvent('lumberjack:getStockItem', itemName, count)
						end

					end,
					function(data2, menu2)
						menu2.close()
					end
				)

			end,
			function(data, menu)
				menu.close()
			end
		)
	end)
end

function OpenPutStocksMenu()

	ESX.TriggerServerCallback('lumberjack:getPlayerInventory', function(inventory)

		local elements = {}

		for i=1, #inventory.items, 1 do

			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
			end

		end

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'stocks_menu',
			{
				title    = _U('inventory'),
				elements = elements
			},
			function(data, menu)

				local itemName = data.current.value

				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
					{
						title = _U('quantity')
					},
					function(data2, menu2)

						local count = tonumber(data2.value)

						if count == nil or count <= 0 then
							ESX.ShowNotification(_U('quantity_invalid'))
						else
							menu2.close()
							menu.close()
							OpenPutStocksMenu()

							TriggerServerEvent('lumberjack:putStockItems', itemName, count)
						end

					end,
					function(data2, menu2)
						menu2.close()
					end
				)

			end,
			function(data, menu)
				menu.close()
			end
		)

	end)

end


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	blips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	deleteBlips()
	blips()
end)

AddEventHandler('lumberjack:hasEnteredMarker', function(zone)
	if zone == 'WoodFarm' and PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack'  then
		CurrentAction     = 'raisin_harvest'
		CurrentActionMsg  = _U('press_collect')
		CurrentActionData = {zone= zone}
	end

	if zone == 'WoodFarm2' and PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack'  then
		CurrentAction     = 'raisin_harvest'
		CurrentActionMsg  = _U('press_collect')
		CurrentActionData = {zone= zone}
	end

	if zone == 'WoodFarm3' and PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack'  then
		CurrentAction     = 'raisin_harvest'
		CurrentActionMsg  = _U('press_collect')
		CurrentActionData = {zone= zone}
	end

	if zone == 'WoodFar4' and PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack'  then
		CurrentAction     = 'raisin_harvest'
		CurrentActionMsg  = _U('press_collect')
		CurrentActionData = {zone= zone}
	end
		
	if zone == 'TraitementPlank' and PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack'  then
		CurrentAction     = 'vine_traitement'
		CurrentActionMsg  = _U('press_traitement_woodd')
		CurrentActionData = {zone= zone}
	end		
		
	if zone == 'TraitementWood' and PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack'  then
		CurrentAction     = 'jus_traitement'
		CurrentActionMsg  = _U('press_traitement')
		CurrentActionData = {zone = zone}
	end
		
	if zone == 'SellFarm' and PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack'  then
		CurrentAction     = 'farm_resell'
		CurrentActionMsg  = _U('press_sell')
		CurrentActionData = {zone = zone}
	end

	if zone == 'LumberjackActions' and PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack' then
		CurrentAction     = 'lumberjack_actions_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionData = {}
	end
  
	if zone == 'VehicleSpawner' and PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack' then
		CurrentAction     = 'vehicle_spawner_menu'
		CurrentActionMsg  = _U('spawn_veh')
		CurrentActionData = {}
	end
		
	if zone == 'VehicleDeleter' and PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack' then

		local playerPed = GetPlayerPed(-1)
		local coords    = GetEntityCoords(playerPed)
		
		if IsPedInAnyVehicle(playerPed,  false) then

			local vehicle, distance = ESX.Game.GetClosestVehicle({
				x = coords.x,
				y = coords.y,
				z = coords.z
			})

			if distance ~= -1 and distance <= 1.0 then

				CurrentAction     = 'delete_vehicle'
				CurrentActionMsg  = _U('store_veh')
				CurrentActionData = {vehicle = vehicle}

			end
		end
	end
end)

AddEventHandler('lumberjack:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	if (zone == 'WoodFarm') and PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack' then
		TriggerServerEvent('lumberjack:stopHarvest')
	end  
	if (zone == 'WoodFarm2') and PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack' then
		TriggerServerEvent('lumberjack:stopHarvest')
	end
	if (zone == 'WoodFarm3') and PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack' then
		TriggerServerEvent('lumberjack:stopHarvest')
	end
	if (zone == 'WoodFarm4') and PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack' then
		TriggerServerEvent('lumberjack:stopHarvest')
	end
	if (zone == 'TraitementPlank' or zone == 'TraitementWood') and PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack' then
		TriggerServerEvent('lumberjack:stopTransform')
	end
	if (zone == 'SellFarm') and PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack' then
		TriggerServerEvent('lumberjack:stopSell')
	end
	CurrentAction = nil
end)


function deleteBlips()
	if JobBlips[1] ~= nil then
		for i=1, #JobBlips, 1 do
		RemoveBlip(JobBlips[i])
		JobBlips[i] = nil
		end
	end
end

-- Create Blips
function blips()
	if publicBlip == false then
		local blip = AddBlipForCoord(Config.Zones.LumberjackActions.Pos.x, Config.Zones.LumberjackActions.Pos.y, Config.Zones.LumberjackActions.Pos.z)
		SetBlipSprite (blip, 237)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 1.2)
		SetBlipColour (blip, 15)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Bucherons")
		EndTextCommandSetBlipName(blip)
		publicBlip = true
	end
	
    if PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack' then

		for k,v in pairs(Config.Zones)do
			if v.Type == 1 then
				local blip2 = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)

				SetBlipSprite (blip2, 237)
				SetBlipDisplay(blip2, 4)
				SetBlipScale  (blip2, 1.2)
				SetBlipColour (blip2, 15)
				SetBlipAsShortRange(blip2, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(v.Name)
				EndTextCommandSetBlipName(blip2)
				table.insert(JobBlips, blip2)
			end
		end
		--for k,v in pairs(Config.Zones2)do
		--	if v.Type == 20 then
		--		local blip2 = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)
--
		--		SetBlipSprite (blip2, 162)
		--		SetBlipDisplay(blip2, 4)
		--		SetBlipScale  (blip2, 0.85)
		--		SetBlipColour (blip2, 2)
		--		SetBlipAsShortRange(blip2, true)
--
		--		BeginTextCommandSetBlipName("STRING")
		--		AddTextComponentString(v.Name)
		--		EndTextCommandSetBlipName(blip2)
		--		table.insert(JobBlips, blip2)
		--	end
		--end
	end
end


-- Display markers
Citizen.CreateThread(function()
	while true do
		Wait(0)
		local coords = GetEntityCoords(GetPlayerPed(-1))

		for k,v in pairs(Config.Zones) do
			if PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack' then
				if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					DrawMarker(27, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 4.0, 4.0, 1.0, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				end
			end
		end
		for k,v in pairs(Config.Zones2) do
			if PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack' then
				if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					DrawMarker(20, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 1.0, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				end
			end
		end
	end
end)


-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do

		Wait(0)

		if PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack' then

			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 3.0) then
					isInMarker  = true
					currentZone = k
				end
			end

			for k,v in pairs(Config.Zones2) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 1.0) then
					isInMarker  = true
					currentZone = k
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker = true
				LastZone                = currentZone
				TriggerEvent('lumberjack:hasEnteredMarker', currentZone)
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('lumberjack:hasExitedMarker', LastZone)
			end
		end
	end
end)

local RecolteEnCours = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if RecolteEnCours then
			SetTextComponentFormat('STRING')
			AddTextComponentString("Appuyer sur [E] pour stoppé l'animation")
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack' and RecolteEnCours then
				local playerPed = GetPlayerPed(-1)
				ClearPedTasksImmediately(playerPed)
				RecolteEnCours = false
			end
		end
	end
end)
-- Key Controls
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		if CurrentAction ~= nil then

			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack' and (GetGameTimer() - GUI.Time) > 300 then
				if CurrentAction == 'raisin_harvest' then
					TriggerServerEvent('lumberjack:startHarvest', CurrentActionData.zone)
					local playerPed = GetPlayerPed(-1)
					RequestAnimDict("amb")
					RequestAnimDict("amb@world_human_hammering")
					RequestAnimDict("amb@world_human_hammering@male")
					RequestAnimDict("amb@world_human_hammering@male@base")
					while (not HasAnimDictLoaded("amb@world_human_hammering@male@base")) do Citizen.Wait(0) end
					TaskPlayAnim(playerPed, 'amb@world_human_hammering@male@base', 'base', 8.0, -8.0, -1, 0, 0, false, false, false)
					Citizen.Wait(200)
					RecolteEnCours = true
					while RecolteEnCours do
						TaskPlayAnim(playerPed, 'amb@world_human_hammering@male@base', 'base', 8.0, -8.0, -1, 0, 0, false, false, false)
						Wait(3133)
						RemoveAnimDict("amb")
						RemoveAnimDict("amb@world_human_hammering")
						RemoveAnimDict("amb@world_human_hammering@male")
						RemoveAnimDict("amb@world_human_hammering@male@base")
					end
				end
				if CurrentAction == 'jus_traitement' then
					TriggerServerEvent('lumberjack:startTransform', CurrentActionData.zone)
				end
				if CurrentAction == 'vine_traitement' then
					TriggerServerEvent('lumberjack:startTransform', CurrentActionData.zone)
				end
				if CurrentAction == 'farm_resell' then
					TriggerServerEvent('lumberjack:startSell', CurrentActionData.zone)
				end
				
				if CurrentAction == 'lumberjack_actions_menu' then
					OpenLumberjackActionsMenu()
				end
				if CurrentAction == 'vehicle_spawner_menu' then
					OpenVehicleSpawnerMenu()
				end
				if CurrentAction == 'delete_vehicle' then

					if Config.EnableSocietyOwnedVehicles then
						local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
						TriggerServerEvent('esx_society:putVehicleInGarage', 'lumberjack', vehicleProps)
					end

					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				end

				CurrentAction = nil
				GUI.Time      = GetGameTimer()

			end
		end

		if IsControlPressed(0,  Keys['F6']) and Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack' and (GetGameTimer() - GUI.Time) > 150 then
			OpenMobileLumberjackActionsMenu()
			GUI.Time = GetGameTimer()
		end
	end
end)