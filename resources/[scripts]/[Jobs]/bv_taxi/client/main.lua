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

local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local OnJob                     = false
local CurrentCustomer           = nil
local CurrentCustomerBlip       = nil
local DestinationBlip           = nil
local IsNearCustomer            = false
local CustomerIsEnteringVehicle = false
local CustomerEnteredVehicle    = false
local TargetCoords              = nil
local IsDead                    = false

ESX                             = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

function DrawSub(msg, time)
	ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(msg)
	DrawSubtitleTimed(time, 1)
end

function ShowLoadingPromt(msg, time, type)
	Citizen.CreateThread(function()
		Citizen.Wait(0)
		BeginTextCommandBusyString("STRING")
		AddTextComponentString(msg)
		EndTextCommandBusyString(type)
		Citizen.Wait(time)

		RemoveLoadingPrompt()
	end)
end

function GetRandomWalkingNPC()
	local search = {}
	local peds   = ESX.Game.GetPeds()

	for i=1, #peds, 1 do
		if IsPedHuman(peds[i]) and IsPedWalking(peds[i]) and not IsPedAPlayer(peds[i]) then
			table.insert(search, peds[i])
		end
	end

	if #search > 0 then
		return search[GetRandomIntInRange(1, #search)]
	end

	for i=1, 250, 1 do
		local ped = GetRandomPedAtCoord(0.0, 0.0, 0.0, math.huge + 0.0, math.huge + 0.0, math.huge + 0.0, 26)

		if DoesEntityExist(ped) and IsPedHuman(ped) and IsPedWalking(ped) and not IsPedAPlayer(ped) then
			table.insert(search, ped)
		end
	end

	if #search > 0 then
		return search[GetRandomIntInRange(1, #search)]
	end
end

function ClearCurrentMission()
	if DoesBlipExist(CurrentCustomerBlip) then
		RemoveBlip(CurrentCustomerBlip)
	end

	if DoesBlipExist(DestinationBlip) then
		RemoveBlip(DestinationBlip)
	end

	CurrentCustomer           = nil
	CurrentCustomerBlip       = nil
	DestinationBlip           = nil
	IsNearCustomer            = false
	CustomerIsEnteringVehicle = false
	CustomerEnteredVehicle    = false
	TargetCoords              = nil
end

function StartTaxiJob()
	ShowLoadingPromt(_U('taking_service'), 5000, 3)
	ClearCurrentMission()

	OnJob = true
end

function StopTaxiJob()
	local playerPed = PlayerPedId()

	if IsPedInAnyVehicle(playerPed, false) and CurrentCustomer ~= nil then
		local vehicle = GetVehiclePedIsIn(playerPed,  false)
		TaskLeaveVehicle(CurrentCustomer,  vehicle,  0)

		if CustomerEnteredVehicle then
			TaskGoStraightToCoord(CurrentCustomer,  TargetCoords.x,  TargetCoords.y,  TargetCoords.z,  1.0,  -1,  0.0,  0.0)
		end
	end

	ClearCurrentMission()
	OnJob = false
	DrawSub(_U('mission_complete'), 5000)
end

function OpenCloakroom()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'taxi_cloakroom',
	{
		css      = 'taxivestiaire',
		title    = "Vétisaire",
		align    = 'top-left',
		elements = {
			{ label = "Tenue civil", value = 'wear_citizen' },
			{ label = "Tenue de travail",    value = 'wear_work'}
		}
	}, function(data, menu)
		if data.current.value == 'wear_citizen' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'wear_work' then
			--ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			--	if skin.sex == 0 then
			--		TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
			--	else
			--		TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
			--	end
			--end)
			ESX.ShowNotification('Vous avez mis votre tenu')
			TriggerEvent('skinchanger:getSkin', function(skin)
				local clothesSkin = {
					['bags_1'] = 0, ['bags_2'] = 0,
					['tshirt_1'] = 12, ['tshirt_2'] = 0,
					['torso_1'] = 13, ['torso_2'] = 0,
					['arms'] = 26,
					['pants_1'] = 28, ['pants_2'] = 0,
					['shoes_1'] = 20, ['shoes_2'] = 0,
					['mask_1'] = 0, ['mask_2'] = 0,
					['bproof_1'] = 0,
					['helmet_1'] = -1, ['helmet_2'] = 0,
					['chain_1'] = 21, ['chain_2'] = 1
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
				TriggerServerEvent("Taxi:NotifAll", "Prise de service")
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'cloakroom'
		CurrentActionMsg  = _U('cloakroom_prompt')
		CurrentActionData = {}
	end)
end

function OpenVehicleSpawnerMenu()
	ESX.UI.Menu.CloseAll()

	local elements = {}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
	{
		css         = 'taxigarage',
		title		= "Sortir un véhicule",
		align		= 'top-left',
		elements	= Config.AuthorizedVehicles
	}, function(data, menu)
		if not ESX.Game.IsSpawnPointClear(Config.Zones.VehicleSpawnPoint.Pos, 5.0) then
			ESX.ShowNotification("Point de spawn bloqué")
			return
		end

		menu.close()
		ESX.Game.SpawnVehicle(data.current.model, Config.Zones.VehicleSpawnPoint.Pos, Config.Zones.VehicleSpawnPoint.Heading, function(vehicle)
			local playerPed = PlayerPedId()
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			SetVehicleEnginePowerMultiplier(vehicle, 2.0*8)
			SetVehicleNumberPlateText(vehicle, "TAXI")
		end)
		TriggerServerEvent("Taxi:NotifAll", "Prise de véhicule")
		
	end, function(data, menu)
		CurrentAction     = 'vehicle_spawner'
		CurrentActionMsg  = "Appuye sur ~b~[E]~w~ Pour sortir un véhicule"
		CurrentActionData = {}

		menu.close()
	end)
end

function DeleteJobVehicle()
	local playerPed = PlayerPedId()

	if IsInAuthorizedVehicle() then
		ESX.Game.DeleteVehicle(CurrentActionData.vehicle)

		if Config.MaxInService ~= -1 then
			TriggerServerEvent('esx_service:disableService', 'taxi')
		end
	else
		ESX.ShowNotification("Tu n'est pas en taxi.")
	end
end

function OpenTaxiActionsMenu()
	local elements = {
		{label = "Déposer dans le stock", value = 'put_stock'},
		{label = "Prendre du stock", value = 'get_stock'}
	}

	if Config.EnablePlayerManagement and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = "Action Patron", value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'taxi_actions',
	{
		css      = 'taxiactions',
		title    = 'Taxi',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu()
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'taxi', function(data, menu)
				menu.close()
			end)
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'taxi_actions_menu'
		CurrentActionMsg  = "Appuyer sur ~b~[E]~w~ Pour ouvrir"
		CurrentActionData = {}
	end)
end

function OpenMobileTaxiActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_taxi_actions',
	{
		css      = 'taxiactions',
		title    = 'Taxi',
		align    = 'top-left',
		elements = {
			{ label = "Donner une facture",   value = 'billing' }
			--{ label = "Commencer les missions PNJ", value = 'start_job' }
		}
	}, function(data, menu)
		if data.current.value == 'billing' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
				css      = 'taxifacture',
				title = "Montant"
			}, function(data, menu)

				local amount = tonumber(data.value)
				if amount == nil then
					ESX.ShowNotification("Montant invalide")
				else
					menu.close()
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification("Pas de joueur proche")
					else
						TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_taxi', 'Taxi', amount)
						ESX.ShowNotification("Facture envoyer")
					end

				end

			end, function(data, menu)
				menu.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function IsInAuthorizedVehicle()
	local playerPed = PlayerPedId()
	local vehModel  = GetEntityModel(GetVehiclePedIsIn(playerPed, false))

	for i=1, #Config.AuthorizedVehicles, 1 do
		if vehModel == GetHashKey(Config.AuthorizedVehicles[i].model) then
			return true
		end
	end
	
	return false
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('esx_taxijob:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {
				label = 'x' .. items[i].count .. ' ' .. items[i].label,
				value = items[i].name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
		{
			css      = 'taxicoffre',
			title    = 'Coffre',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				css      = 'taxicoffre',
				title = _U('quantity')
			}, function(data2, menu2)

				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()

					-- todo: refresh on callback
					TriggerServerEvent('esx_taxijob:getStockItem', itemName, count)
					Citizen.Wait(1000)
					OpenGetStocksMenu()
				end

			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutStocksMenu()
	ESX.TriggerServerCallback('esx_taxijob:getPlayerInventory', function(inventory)

		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard', -- not used
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
		{
			css      = 'taxicoffre',
			title    = _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				css      = 'taxicoffre',
				title = _U('quantity')
			}, function(data2, menu2)

				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()

					-- todo: refresh on callback
					TriggerServerEvent('esx_taxijob:putStockItems', itemName, count)
					Citizen.Wait(1000)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

AddEventHandler('esx_taxijob:hasEnteredMarker', function(zone)
	if zone == 'VehicleSpawner' then
		CurrentAction     = 'vehicle_spawner'
		CurrentActionMsg  = _U('spawner_prompt')
		CurrentActionData = {}
	elseif zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()
		local vehicle   = GetVehiclePedIsIn(playerPed, false)

		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('store_veh')
			CurrentActionData = { vehicle = vehicle }
		end
	elseif zone == 'TaxiActions' then
		CurrentAction     = 'taxi_actions_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionData = {}

	elseif zone == 'Cloakroom' then
		CurrentAction     = 'cloakroom'
		CurrentActionMsg  = _U('cloakroom_prompt')
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_taxijob:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = _U('phone_taxi'),
		number     = 'taxi',
		base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAQkAAAEJCAYAAACHaNJkAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA4RpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDIxIDc5LjE1NTc3MiwgMjAxNC8wMS8xMy0xOTo0NDowMCAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo1Mjg1OTJiOC0wN2E3LThhNGUtOWI0NS0xMjBhNTNjNTVlMDUiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6RjEwNzgzMEU2NUI1MTFFNzlDODc5OUIxOUZENjFGRjMiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6RjEwNzgzMEQ2NUI1MTFFNzlDODc5OUIxOUZENjFGRjMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIDIwMTQgKFdpbmRvd3MpIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6NGE0MjU0MTUtYTg1NC1kMDQ4LWE2MmItYWRhMDI0NmFhM2Y1IiBzdFJlZjpkb2N1bWVudElEPSJhZG9iZTpkb2NpZDpwaG90b3Nob3A6ZTQzMjI0NWMtNjViNS0xMWU3LTgyYTEt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',
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.TaxiActions.Pos.x, Config.Zones.TaxiActions.Pos.y, Config.Zones.TaxiActions.Pos.z)

	SetBlipSprite (blip, 198)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 1.0)
	SetBlipColour (blip, 5)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(_U('blip_taxi'))
	EndTextCommandSetBlipName(blip)
end)

-- Enter / Exit marker events, and draw markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
			local coords = GetEntityCoords(PlayerPedId())
			local isInMarker, currentZone = false

			for k,v in pairs(Config.Zones) do
				local distance = GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true)

				if v.Type ~= -1 and distance < Config.DrawDistance then
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, v.Rotate, nil, nil, false)
				end

				if distance < v.Size.x then
					isInMarker, currentZone = true, k
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker, LastZone = true, currentZone
				TriggerEvent('esx_taxijob:hasEnteredMarker', currentZone)
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_taxijob:hasExitedMarker', LastZone)
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

-- Taxi Job
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if OnJob then
			if CurrentCustomer == nil then
				DrawSub(_U('drive_search_pass'), 5000)

				if IsPedInAnyVehicle(playerPed, false) and GetEntitySpeed(playerPed) > 0 then
					local waitUntil = GetGameTimer() + GetRandomIntInRange(30000, 45000)

					while OnJob and waitUntil > GetGameTimer() do
						Citizen.Wait(0)
					end

					if OnJob and IsPedInAnyVehicle(playerPed, false) and GetEntitySpeed(playerPed) > 0 then
						CurrentCustomer = GetRandomWalkingNPC()

						if CurrentCustomer ~= nil then
							CurrentCustomerBlip = AddBlipForEntity(CurrentCustomer)

							SetBlipAsFriendly(CurrentCustomerBlip, true)
							SetBlipColour(CurrentCustomerBlip, 2)
							SetBlipCategory(CurrentCustomerBlip, 3)
							SetBlipRoute(CurrentCustomerBlip, true)

							SetEntityAsMissionEntity(CurrentCustomer, true, false)
							ClearPedTasksImmediately(CurrentCustomer)
							SetBlockingOfNonTemporaryEvents(CurrentCustomer, true)

							local standTime = GetRandomIntInRange(60000, 180000)
							TaskStandStill(CurrentCustomer, standTime)

							ESX.ShowNotification(_U('customer_found'))
						end
					end
				end
			else
				if IsPedFatallyInjured(CurrentCustomer) then
					ESX.ShowNotification(_U('client_unconcious'))

					if DoesBlipExist(CurrentCustomerBlip) then
						RemoveBlip(CurrentCustomerBlip)
					end

					if DoesBlipExist(DestinationBlip) then
						RemoveBlip(DestinationBlip)
					end

					SetEntityAsMissionEntity(CurrentCustomer, false, true)

					CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, TargetCoords = nil, nil, nil, false, false, false, nil
				end

				if IsPedInAnyVehicle(playerPed, false) then
					local vehicle          = GetVehiclePedIsIn(playerPed, false)
					local playerCoords     = GetEntityCoords(playerPed)
					local customerCoords   = GetEntityCoords(CurrentCustomer)
					local customerDistance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, customerCoords.x, customerCoords.y, customerCoords.z)

					if IsPedSittingInVehicle(CurrentCustomer, vehicle) then
						if CustomerEnteredVehicle then
							local targetDistance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, TargetCoords.x, TargetCoords.y, TargetCoords.z)

							if targetDistance <= 10.0 then
								TaskLeaveVehicle(CurrentCustomer, vehicle, 0)

								ESX.ShowNotification(_U('arrive_dest'))

								TaskGoStraightToCoord(CurrentCustomer, TargetCoords.x, TargetCoords.y, TargetCoords.z, 1.0, -1, 0.0, 0.0)
								SetEntityAsMissionEntity(CurrentCustomer, false, true)
								TriggerServerEvent('esx_taxijob:success')
								RemoveBlip(DestinationBlip)

								local scope = function(customer)
									ESX.SetTimeout(60000, function()
										DeletePed(customer)
									end)
								end

								scope(CurrentCustomer)

								CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, TargetCoords = nil, nil, nil, false, false, false, nil
							end

							if TargetCoords then
								DrawMarker(36, TargetCoords.x, TargetCoords.y, TargetCoords.z + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 234, 223, 72, 155, false, false, 2, true, nil, nil, false)
							end
						else
							RemoveBlip(CurrentCustomerBlip)
							CurrentCustomerBlip = nil
							TargetCoords = Config.JobLocations[GetRandomIntInRange(1, #Config.JobLocations)]
							local distance = GetDistanceBetweenCoords(playerCoords, TargetCoords.x, TargetCoords.y, TargetCoords.z, true)

							while distance < Config.MinimumDistance do
								Citizen.Wait(5)

								TargetCoords = Config.JobLocations[GetRandomIntInRange(1, #Config.JobLocations)]
								distance = GetDistanceBetweenCoords(playerCoords, TargetCoords.x, TargetCoords.y, TargetCoords.z, true)
							end

							local street = table.pack(GetStreetNameAtCoord(TargetCoords.x, TargetCoords.y, TargetCoords.z))
							local msg    = nil

							if street[2] ~= 0 and street[2] ~= nil then
								msg = string.format(_U('take_me_to_near', GetStreetNameFromHashKey(street[1]), GetStreetNameFromHashKey(street[2])))
							else
								msg = string.format(_U('take_me_to', GetStreetNameFromHashKey(street[1])))
							end

							ESX.ShowNotification(msg)

							DestinationBlip = AddBlipForCoord(TargetCoords.x, TargetCoords.y, TargetCoords.z)

							BeginTextCommandSetBlipName("STRING")
							AddTextComponentSubstringPlayerName("Destination")
							EndTextCommandSetBlipName(blip)
							SetBlipRoute(DestinationBlip, true)

							CustomerEnteredVehicle = true
						end
					else
						DrawMarker(36, customerCoords.x, customerCoords.y, customerCoords.z + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 234, 223, 72, 155, false, false, 2, true, nil, nil, false)

						if not CustomerEnteredVehicle then
							if customerDistance <= 40.0 then

								if not IsNearCustomer then
									ESX.ShowNotification(_U('close_to_client'))
									IsNearCustomer = true
								end

							end

							if customerDistance <= 20.0 then
								if not CustomerIsEnteringVehicle then
									ClearPedTasksImmediately(CurrentCustomer)

									local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

									for i=maxSeats - 1, 0, -1 do
										if IsVehicleSeatFree(vehicle, i) then
											freeSeat = i
											break
										end
									end

									if freeSeat then
										TaskEnterVehicle(CurrentCustomer, vehicle, -1, freeSeat, 2.0, 0)
										CustomerIsEnteringVehicle = true
									end
								end
							end
						end
					end
				else
					DrawSub(_U('return_to_veh'), 5000)
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction and not IsDead then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) and ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
				if CurrentAction == 'taxi_actions_menu' then
					OpenTaxiActionsMenu()
				elseif CurrentAction == 'cloakroom' then
					OpenCloakroom()
				elseif CurrentAction == 'vehicle_spawner' then
					OpenVehicleSpawnerMenu()
				elseif CurrentAction == 'delete_vehicle' then
					DeleteJobVehicle()
				end

				CurrentAction = nil
			end
		end

		if IsControlJustReleased(0, Keys['F6']) and IsInputDisabled(0) and not IsDead and Config.EnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
			OpenMobileTaxiActionsMenu()
		end
	end
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	IsDead = false
end)




--
--
--      Rework appel taxi ici 
--
--


local AppelPris = false
local AppelDejaPris = false
local AppelEnAttente = false 
local AppelCoords = nil




-- Prise de coords des appels
RegisterNetEvent("AppelTaxiGetCoords")
AddEventHandler("AppelTaxiGetCoords", function()
	ped = GetPlayerPed(-1)
	coords = GetEntityCoords(ped, true)
	TriggerServerEvent("Server:TaxiAppel", coords)
	ESX.ShowAdvancedNotification("Taxi", "~b~Demande de taxi", "Votre appel à été pris en compte.\nMerci de patienter", "CHAR_TAXI", 8)
end)



-- Register de l'appel
RegisterNetEvent("AppelTaxiTropBien")
AddEventHandler("AppelTaxiTropBien", function(coords)
	AppelEnAttente = true
	AppelCoords = coords
	ESX.ShowAdvancedNotification("Taxi", "~b~Demande de taxi", "Quelqu'un à besoin d'un taxi !\n~g~Y~w~ pour prendre l'appel\n~r~X~w~ pour refuser", "CHAR_TAXI", 8)
end)



Citizen.CreateThread(function()
     while true do
		Citizen.Wait(1)
		-- Un IF en plus pour éviter la surcharge du script
		if AppelEnAttente then
			if IsControlJustPressed(1, 246) and AppelEnAttente then
				if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'taxi' then
					TriggerServerEvent('PriseAppelServeur')
					TriggerEvent('TaxiAppelPris', AppelCoords)
				end 
			elseif IsControlJustPressed(1, 73) and AppelEnAttente then
				ESX.ShowAdvancedNotification("Taxi", "~b~Demande de taxi", "Vous avez refuser l'appel.", "CHAR_TAXI", 8)
				AppelEnAttente = false
				attente = false
				AppelDejaPris = false
			end
		end
		
		if IsControlJustPressed(1, 246) and AppelDejaPris == true then
			ESX.ShowAdvancedNotification("Taxi", "~b~Demande de taxi", "L'appel à déja été pris, désolé.", "CHAR_TAXI", 8)
		end
     end
end)


RegisterNetEvent("AppelDejaPris")
AddEventHandler("AppelDejaPris", function()
	AppelEnAttente = false
	AppelDejaPris = true
	Citizen.Wait(10000)
	AppelDejaPris = false
end)


-- Prise d'appel taxi
RegisterNetEvent("TaxiAppelPris")
AddEventHandler("TaxiAppelPris", function(AppelCoords)
	ESX.ShowAdvancedNotification("Taxi", "~b~Demande de taxi", "Vous avez pris l'appel, suivez la route GPS.", "CHAR_TAXI", 8)
	local wait = 0
	-- Blip de la zone
	local TaxiBlip = AddBlipForCoord(AppelCoords)
	SetBlipSprite(TaxiBlip, 280)
	SetBlipColour(TaxiBlip, 5)
	SetBlipShrink(TaxiBlip, true)
	SetBlipScale(TaxiBlip, 1.2)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("~b~Appel Taxi")
	EndTextCommandSetBlipName(TaxiBlip)

	-- Ajout du deuxième blip plus animer

	local TaxiBlip2 = AddBlipForCoord(coords)
	SetBlipSprite(TaxiBlip2, 42)
	SetBlipColour(TaxiBlip2, 5)
	SetBlipShrink(TaxiBlip2, true)
	SetBlipScale(TaxiBlip2, 1.2)
	SetBlipAlpha(TaxiBlip2, 120)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("~b~Appel Taxi")
	EndTextCommandSetBlipName(TaxiBlip2)
	-- Ajout de la route
	SetBlipRoute(TaxiBlip, true)


	while wait < 120 do
		wait = wait + 1
		Wait(1000)
	end
	-- Blip retiré
	RemoveBlip(TaxiBlip)
	RemoveBlip(TaxiBlip2)
end)