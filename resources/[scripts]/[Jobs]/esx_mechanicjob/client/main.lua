local HasAlreadyEnteredMarker, LastZone = false, nil
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local CurrentlyTowedVehicle, Blips, NPCOnJob, NPCTargetTowable, NPCTargetTowableZone = nil, {}, false, nil, nil
local NPCHasSpawnedTowable, NPCLastCancel, NPCHasBeenNextToTowable, NPCTargetDeleterZone = false, GetGameTimer() - 5 * 60000, false, false
local isDead, isBusy = false, false

ESX = nil

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

function SelectRandomTowable()
	local index = GetRandomIntInRange(1,  #Config.Towables)

	for k,v in pairs(Config.Zones) do
		if v.Pos.x == Config.Towables[index].x and v.Pos.y == Config.Towables[index].y and v.Pos.z == Config.Towables[index].z then
			return k
		end
	end
end

function StartNPCJob()
	NPCOnJob = true

	NPCTargetTowableZone = SelectRandomTowable()
	local zone       = Config.Zones[NPCTargetTowableZone]

	Blips['NPCTargetTowableZone'] = AddBlipForCoord(zone.Pos.x,  zone.Pos.y,  zone.Pos.z)
	SetBlipRoute(Blips['NPCTargetTowableZone'], true)

	ESX.ShowNotification(_U('drive_to_indicated'))
end

function StopNPCJob(cancel)
	if Blips['NPCTargetTowableZone'] then
		RemoveBlip(Blips['NPCTargetTowableZone'])
		Blips['NPCTargetTowableZone'] = nil
	end

	if Blips['NPCDelivery'] then
		RemoveBlip(Blips['NPCDelivery'])
		Blips['NPCDelivery'] = nil
	end

	Config.Zones.VehicleDelivery.Type = -1

	NPCOnJob                = false
	NPCTargetTowable        = nil
	NPCTargetTowableZone    = nil
	NPCHasSpawnedTowable    = false
	NPCHasBeenNextToTowable = false

	if cancel then
		ESX.ShowNotification(_U('mission_canceled'))
	else
		--TriggerServerEvent('esx_mechanicjob:onNPCJobCompleted')
	end
end

function OpenMechanicActionsMenu()
	local elements = {
		{label = _U('vehicle_list'),   value = 'vehicle_list'},
		{label = _U('work_wear'),      value = 'cloakroom'},
		{label = _U('civ_wear'),       value = 'cloakroom2'},
		{label = _U('deposit_stock'),  value = 'put_stock'},
		{label = _U('withdraw_stock'), value = 'get_stock'}
	}

	if Config.EnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_actions', {
		css      = 'lsc',
		title    = _U('mechanic'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'vehicle_list' then
			if Config.EnableSocietyOwnedVehicles then

				local elements = {}

				ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(vehicles)
					for i=1, #vehicles, 1 do
						table.insert(elements, {
							label = GetDisplayNameFromVehicleModel(vehicles[i].model) .. ' [' .. vehicles[i].plate .. ']',
							value = vehicles[i]
						})
					end

					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
						css      = 'lsc',
						title    = _U('service_vehicle'),
						align    = 'top-left',
						elements = elements
					}, function(data, menu)
						menu.close()
						local vehicleProps = data.current.value

						ESX.Game.SpawnVehicle(vehicleProps.model, Config.Zones.VehicleSpawnPoint.Pos, 270.0, function(vehicle)
							ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
							local playerPed = PlayerPedId()
							TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
						end)

						TriggerServerEvent('esx_society:removeVehicleFromGarage', 'mechanic', vehicleProps)
					end, function(data, menu)
						menu.close()
					end)
				end, 'mechanic')

			else

				local elements = {
					{label = _U('flat_bed'),  value = 'flatbed'},
					{label = _U('tow_truck'), value = 'towtruck2'}
				}

				if Config.EnablePlayerManagement and ESX.PlayerData.job and (ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'chief' or ESX.PlayerData.job.grade_name == 'experimente') then
					table.insert(elements, {label = 'SlamVan', value = 'slamvan3'})
				end

				ESX.UI.Menu.CloseAll()

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_vehicle', {
					css      = 'lsc',
					title    = _U('service_vehicle'),
					align    = 'top-left',
					elements = elements
				}, function(data, menu)
					if Config.MaxInService == -1 then
						ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
							local playerPed = PlayerPedId()
							TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
						end)
					else
						ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
							if canTakeService then
								ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
									local playerPed = PlayerPedId()
									TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
								end)
							else
								ESX.ShowNotification(_U('service_full') .. inServiceCount .. '/' .. maxInService)
							end
						end, 'mechanic')
					end

					menu.close()
				end, function(data, menu)
					menu.close()
					OpenMechanicActionsMenu()
				end)

			end
		elseif data.current.value == 'cloakroom' then
			menu.close()
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
		elseif data.current.value == 'cloakroom2' then
			menu.close()
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu()
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'mechanic', function(data, menu)
				menu.close()
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'mechanic_actions_menu'
		CurrentActionMsg  = _U('open_actions')
		CurrentActionData = {}
	end)
end

function OpenMechanicHarvestMenu()
	if Config.EnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.grade_name ~= 'recrue' then
		local elements = {
			{label = _U('gas_can'), value = 'gaz_bottle'},
			{label = _U('repair_tools'), value = 'fix_tool'},
			{label = _U('body_work_tools'), value = 'caro_tool'}
		}

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_harvest', {
			css      = 'lsc',
			title    = _U('harvest'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()

			if data.current.value == 'gaz_bottle' then
				TriggerServerEvent('esx_mechanicjob:startHarvest')
			elseif data.current.value == 'fix_tool' then
				TriggerServerEvent('esx_mechanicjob:startHarvest2')
			elseif data.current.value == 'caro_tool' then
				TriggerServerEvent('esx_mechanicjob:startHarvest3')
			end
		end, function(data, menu)
			menu.close()
			CurrentAction     = 'mechanic_harvest_menu'
			CurrentActionMsg  = _U('harvest_menu')
			CurrentActionData = {}
		end)
	else
		ESX.ShowNotification(_U('not_experienced_enough'))
	end
end

function OpenMechanicCraftMenu()
	if Config.EnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.grade_name ~= 'recrue' then
		local elements = {
			{label = _U('blowtorch'),  value = 'blow_pipe'},
			{label = _U('repair_kit'), value = 'fix_kit'},
			{label = _U('body_kit'),   value = 'caro_kit'}
		}

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_craft', {
			css      = 'lsc',
			title    = _U('craft'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()

			if data.current.value == 'blow_pipe' then
				TriggerServerEvent('esx_mechanicjob:startCraft')
			elseif data.current.value == 'fix_kit' then
				TriggerServerEvent('esx_mechanicjob:startCraft2')
			elseif data.current.value == 'caro_kit' then
				TriggerServerEvent('esx_mechanicjob:startCraft3')
			end
		end, function(data, menu)
			menu.close()

			CurrentAction     = 'mechanic_craft_menu'
			CurrentActionMsg  = _U('craft_menu')
			CurrentActionData = {}
		end)
	else
		ESX.ShowNotification(_U('not_experienced_enough'))
	end
end

function OpenMobileMechanicActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_mechanic_actions', {
		css      = 'lsc',
		title    = _U('mechanic'),
		align    = 'top-left',
		elements = {
			{label = _U('billing'),       value = 'billing'},
			{label = _U('hijack'),        value = 'hijack_vehicle'},
			{label = _U('repair'),        value = 'fix_vehicle'},
			{label = _U('clean'),         value = 'clean_vehicle'},
			{label = _U('imp_veh'),       value = 'del_vehicle'},
			{label = _U('flat_bed'),      value = 'dep_vehicle'},
			{label = _U('place_objects'), value = 'object_spawner'}
	}}, function(data, menu)
		if isBusy then return end

		if data.current.value == 'billing' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
				css      = 'lsc',
				title = _U('invoice_amount')
			}, function(data, menu)
				local amount = tonumber(data.value)

				if amount == nil or amount < 0 then
					ESX.ShowNotification(_U('amount_invalid'))
				else
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('no_players_nearby'))
					else
						menu.close()
						TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_mechanic', _U('mechanic'), amount)
					end
				end
			end, function(data, menu)
				menu.close()
			end)
		elseif data.current.value == 'hijack_vehicle' then
			local playerPed = PlayerPedId()
			local vehicle   = ESX.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(_U('inside_vehicle'))
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
				Citizen.CreateThread(function()
					Citizen.Wait(10000)

					SetVehicleDoorsLocked(vehicle, 1)
					SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowNotification(_U('vehicle_unlocked'))
					isBusy = false
				end)
			else
				ESX.ShowNotification(_U('no_vehicle_nearby'))
			end
		elseif data.current.value == 'fix_vehicle' then
			local playerPed = PlayerPedId()
			local vehicle   = ESX.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(_U('inside_vehicle'))
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
				SetVehicleDoorOpen(vehicle, 4, false, false) 
				Citizen.CreateThread(function()
					Citizen.Wait(20000)

					SetVehicleFixed(vehicle)
					SetVehicleDeformationFixed(vehicle)
					SetVehicleUndriveable(vehicle, false)
					SetVehicleEngineOn(vehicle, true, true)
					ClearPedTasksImmediately(playerPed)
					TaskEnterVehicle(playerPed, vehicle, 1, -1, 2.0, 16, 0)
					local veh = GetVehiclePedIsIn(playerPed, false)
					local DansUnVeh = IsPedInAnyVehicle(playerPed, false)
					while DansUnVeh == false do
						local DansUnVeh = IsPedInAnyVehicle(playerPed, false)
						Wait(50)
					end
					SetVehicleFixed(veh)
					SetVehicleDeformationFixed(veh)
					SetVehicleUndriveable(veh, false)
					SetVehicleEngineOn(veh, true, true)

					ESX.ShowNotification(_U('vehicle_repaired'))
					isBusy = false
				end)
			else
				ESX.ShowNotification(_U('no_vehicle_nearby'))
			end
		elseif data.current.value == 'clean_vehicle' then
			local playerPed = PlayerPedId()
			local vehicle   = ESX.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(_U('inside_vehicle'))
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
				Citizen.CreateThread(function()
					Citizen.Wait(10000)

					SetVehicleDirtLevel(vehicle, 0)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowNotification(_U('vehicle_cleaned'))
					isBusy = false
				end)
			else
				ESX.ShowNotification(_U('no_vehicle_nearby'))
			end
		elseif data.current.value == 'del_vehicle' then
			local playerPed = PlayerPedId()

			if IsPedSittingInAnyVehicle(playerPed) then
				local vehicle = GetVehiclePedIsIn(playerPed, false)

				if GetPedInVehicleSeat(vehicle, -1) == playerPed then
					ESX.ShowNotification(_U('vehicle_impounded'))
					ESX.Game.DeleteVehicle(vehicle)
				else
					ESX.ShowNotification(_U('must_seat_driver'))
				end
			else
				local vehicle = ESX.Game.GetVehicleInDirection()

				if DoesEntityExist(vehicle) then
					ESX.ShowNotification(_U('vehicle_impounded'))
					ESX.Game.DeleteVehicle(vehicle)
				else
					ESX.ShowNotification(_U('must_near'))
				end
			end
		elseif data.current.value == 'dep_vehicle' then
			local playerPed = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(playerPed, true)

			local towmodel = GetHashKey('flatbed')
			local isVehicleTow = IsVehicleModel(vehicle, towmodel)

			if isVehicleTow then
				local targetVehicle = ESX.Game.GetVehicleInDirection()

				if CurrentlyTowedVehicle == nil then
					if targetVehicle ~= 0 then
						if not IsPedInAnyVehicle(playerPed, true) then
							if vehicle ~= targetVehicle then
								AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
								CurrentlyTowedVehicle = targetVehicle
								ESX.ShowNotification(_U('vehicle_success_attached'))

								if NPCOnJob then
									if NPCTargetTowable == targetVehicle then
										ESX.ShowNotification(_U('please_drop_off'))
										Config.Zones.VehicleDelivery.Type = 1

										if Blips['NPCTargetTowableZone'] then
											RemoveBlip(Blips['NPCTargetTowableZone'])
											Blips['NPCTargetTowableZone'] = nil
										end

										Blips['NPCDelivery'] = AddBlipForCoord(Config.Zones.VehicleDelivery.Pos.x, Config.Zones.VehicleDelivery.Pos.y, Config.Zones.VehicleDelivery.Pos.z)
										SetBlipRoute(Blips['NPCDelivery'], true)
									end
								end
							else
								ESX.ShowNotification(_U('cant_attach_own_tt'))
							end
						end
					else
						ESX.ShowNotification(_U('no_veh_att'))
					end
				else
					AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
					DetachEntity(CurrentlyTowedVehicle, true, true)

					if NPCOnJob then
						if NPCTargetDeleterZone then

							if CurrentlyTowedVehicle == NPCTargetTowable then
								ESX.Game.DeleteVehicle(NPCTargetTowable)
								TriggerServerEvent('esx_mechanicjob:onNPCJobMissionCompleted')
								StopNPCJob()
								NPCTargetDeleterZone = false
							else
								ESX.ShowNotification(_U('not_right_veh'))
							end

						else
							ESX.ShowNotification(_U('not_right_place'))
						end
					end

					CurrentlyTowedVehicle = nil
					ESX.ShowNotification(_U('veh_det_succ'))
				end
			else
				ESX.ShowNotification(_U('imp_flatbed'))
			end
		elseif data.current.value == 'object_spawner' then
			local playerPed = PlayerPedId()

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(_U('inside_vehicle'))
				return
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_mechanic_actions_spawn', {
				css      = 'lsc',
				title    = _U('objects'),
				align    = 'top-left',
				elements = {
					{label = _U('roadcone'), value = 'prop_roadcone02a'},
					{label = _U('toolbox'),  value = 'prop_toolchest_01'}
			}}, function(data2, menu2)
				local model   = data2.current.value
				local coords  = GetEntityCoords(playerPed)
				local forward = GetEntityForwardVector(playerPed)
				local x, y, z = table.unpack(coords + forward * 1.0)

				if model == 'prop_roadcone02a' then
					z = z + 2.0
				elseif model == 'prop_toolchest_01' then
					z = z + 2.0
				end

				ESX.Game.SpawnObject(model, {x = x, y = y, z = z}, function(obj)
					SetEntityHeading(obj, GetEntityHeading(playerPed))
					PlaceObjectOnGroundProperly(obj)
				end)
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('esx_mechanicjob:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {
				label = 'x' .. items[i].count .. ' ' .. items[i].label,
				value = items[i].name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			css      = 'lsc',
			title    = _U('mechanic_stock'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				css      = 'lsc',
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('invalid_quantity'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_mechanicjob:getStockItem', itemName, count)

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
	ESX.TriggerServerCallback('esx_mechanicjob:getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type  = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			css      = 'lsc',
			title    = _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				css      = 'lsc',
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('invalid_quantity'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_mechanicjob:putStockItems', itemName, count)

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

RegisterNetEvent('esx_mechanicjob:onHijack')
AddEventHandler('esx_mechanicjob:onHijack', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		local chance = math.random(100)
		local alarm  = math.random(100)

		if DoesEntityExist(vehicle) then
			if alarm <= 33 then
				SetVehicleAlarm(vehicle, true)
				StartVehicleAlarm(vehicle)
			end

			TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)

			Citizen.CreateThread(function()
				Citizen.Wait(10000)
				if chance <= 66 then
					SetVehicleDoorsLocked(vehicle, 1)
					SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					ClearPedTasksImmediately(playerPed)
					ESX.ShowNotification(_U('veh_unlocked'))
				else
					ESX.ShowNotification(_U('hijack_failed'))
					ClearPedTasksImmediately(playerPed)
				end
			end)
		end
	end
end)

RegisterNetEvent('esx_mechanicjob:onCarokit')
AddEventHandler('esx_mechanicjob:onCarokit', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_HAMMERING', 0, true)
			Citizen.CreateThread(function()
				Citizen.Wait(10000)
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				ClearPedTasksImmediately(playerPed)
				ESX.ShowNotification(_U('body_repaired'))
			end)
		end
	end
end)

RegisterNetEvent('esx_mechanicjob:onFixkit')
AddEventHandler('esx_mechanicjob:onFixkit', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
			Citizen.CreateThread(function()
				Citizen.Wait(20000)
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				SetVehicleUndriveable(vehicle, false)
				ClearPedTasksImmediately(playerPed)
				ESX.ShowNotification(_U('veh_repaired'))
			end)
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

AddEventHandler('esx_mechanicjob:hasEnteredMarker', function(zone)
	if zone == 'NPCJobTargetTowable' then

	elseif zone =='VehicleDelivery' then
		NPCTargetDeleterZone = true
	elseif zone == 'MechanicActions' then
		CurrentAction     = 'mechanic_actions_menu'
		CurrentActionMsg  = _U('open_actions')
		CurrentActionData = {}
	elseif zone == 'Garage' then
		CurrentAction     = 'mechanic_harvest_menu'
		CurrentActionMsg  = _U('harvest_menu')
		CurrentActionData = {}
	elseif zone == 'Craft' then
		CurrentAction     = 'mechanic_craft_menu'
		CurrentActionMsg  = _U('craft_menu')
		CurrentActionData = {}
	elseif zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed,  false)

			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('veh_stored')
			CurrentActionData = {vehicle = vehicle}
		end
	end
end)

AddEventHandler('esx_mechanicjob:hasExitedMarker', function(zone)
	if zone =='VehicleDelivery' then
		NPCTargetDeleterZone = false
	elseif zone == 'Craft' then
		TriggerServerEvent('esx_mechanicjob:stopCraft')
		TriggerServerEvent('esx_mechanicjob:stopCraft2')
		TriggerServerEvent('esx_mechanicjob:stopCraft3')
	elseif zone == 'Garage' then
		TriggerServerEvent('esx_mechanicjob:stopHarvest')
		TriggerServerEvent('esx_mechanicjob:stopHarvest2')
		TriggerServerEvent('esx_mechanicjob:stopHarvest3')
	end

	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

AddEventHandler('esx_mechanicjob:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' and not IsPedInAnyVehicle(playerPed, false) then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = _U('press_remove_obj')
		CurrentActionData = {entity = entity}
	end
end)

AddEventHandler('esx_mechanicjob:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)


-- Pop NPC mission vehicle when inside area
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if NPCTargetTowableZone and not NPCHasSpawnedTowable then
			local coords = GetEntityCoords(PlayerPedId())
			local zone   = Config.Zones[NPCTargetTowableZone]

			if GetDistanceBetweenCoords(coords, zone.Pos.x, zone.Pos.y, zone.Pos.z, true) < Config.NPCSpawnDistance then
				local model = Config.Vehicles[GetRandomIntInRange(1,  #Config.Vehicles)]

				ESX.Game.SpawnVehicle(model, zone.Pos, 0, function(vehicle)
					NPCTargetTowable = vehicle
				end)

				NPCHasSpawnedTowable = true
			end
		end

		if NPCTargetTowableZone and NPCHasSpawnedTowable and not NPCHasBeenNextToTowable then
			local coords = GetEntityCoords(PlayerPedId())
			local zone   = Config.Zones[NPCTargetTowableZone]

			if GetDistanceBetweenCoords(coords, zone.Pos.x, zone.Pos.y, zone.Pos.z, true) < Config.NPCNextToDistance then
				ESX.ShowNotification(_U('please_tow'))
				NPCHasBeenNextToTowable = true
			end
		end
	end
end)

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.MechanicActions.Pos.x, Config.Zones.MechanicActions.Pos.y, Config.Zones.MechanicActions.Pos.z)

	SetBlipSprite (blip, 446)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 1.0)
	SetBlipColour (blip, 5)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('mechanic'))
	EndTextCommandSetBlipName(blip)

--		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
--			local blip2 = AddBlipForCoord(Config.Zones.Garage.Pos.x, Config.Zones.Garage.Pos.y, Config.Zones.Garage.Pos.z)
--
--			SetBlipSprite (blip2, 440)
--			SetBlipDisplay(blip2, 4)
--			SetBlipScale  (blip2, 1.2)
--			SetBlipColour (blip2, 4)
--			SetBlipAsShortRange(blip2, true)
--
--			BeginTextCommandSetBlipName('STRING')
--			AddTextComponentSubstringPlayerName('Récolte d\'outils')
--			EndTextCommandSetBlipName(blip2)
--		end
--	end
end)


-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
			local coords, letSleep = GetEntityCoords(PlayerPedId()), true
			for k,v in pairs(Config.Zones) do
				if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance then
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, nil, nil, false)
					letSleep = false
				end
			end

			if letSleep then
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)



-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then

			local coords      = GetEntityCoords(PlayerPedId())
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker = true
				LastZone                = currentZone
				TriggerEvent('esx_mechanicjob:hasEnteredMarker', currentZone)
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_mechanicjob:hasExitedMarker', LastZone)
			end

		end
	end
end)

Citizen.CreateThread(function()
	local trackedEntities = {
		'prop_roadcone02a',
		'prop_toolchest_01'
	}

	while true do
		Citizen.Wait(500)

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		local closestDistance = -1
		local closestEntity   = nil

		for i=1, #trackedEntities, 1 do
			local object = GetClosestObjectOfType(coords, 3.0, GetHashKey(trackedEntities[i]), false, false, false)

			if DoesEntityExist(object) then
				local objCoords = GetEntityCoords(object)
				local distance  = GetDistanceBetweenCoords(coords, objCoords, true)

				if closestDistance == -1 or closestDistance > distance then
					closestDistance = distance
					closestEntity   = object
				end
			end
		end

		if closestDistance ~= -1 and closestDistance <= 3.0 then
			if LastEntity ~= closestEntity then
				TriggerEvent('esx_mechanicjob:hasEnteredEntityZone', closestEntity)
				LastEntity = closestEntity
			end
		else
			if LastEntity then
				TriggerEvent('esx_mechanicjob:hasExitedEntityZone', LastEntity)
				LastEntity = nil
			end
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) and ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then

				if CurrentAction == 'mechanic_actions_menu' then
					OpenMechanicActionsMenu()
				elseif CurrentAction == 'mechanic_harvest_menu' then
					OpenMechanicHarvestMenu()
				elseif CurrentAction == 'mechanic_craft_menu' then
					OpenMechanicCraftMenu()
				elseif CurrentAction == 'delete_vehicle' then

					if Config.EnableSocietyOwnedVehicles then

						local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
						TriggerServerEvent('esx_society:putVehicleInGarage', 'mechanic', vehicleProps)

					else

						if
							GetEntityModel(vehicle) == GetHashKey('flatbed')   or
							GetEntityModel(vehicle) == GetHashKey('towtruck2') or
							GetEntityModel(vehicle) == GetHashKey('slamvan3')
						then
							TriggerServerEvent('esx_service:disableService', 'mechanic')
						end

					end

					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)

				elseif CurrentAction == 'remove_entity' then
					DeleteEntity(CurrentActionData.entity)
				end

				CurrentAction = nil
			end
		end

		if IsControlJustReleased(0, 167) and not isDead and ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
			OpenMobileMechanicActionsMenu()
		end

		if IsControlJustReleased(0, 178) and not isDead and ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
			if NPCOnJob then
				if GetGameTimer() - NPCLastCancel > 5 * 60000 then
					StopNPCJob(true)
					NPCLastCancel = GetGameTimer()
				else
					ESX.ShowNotification(_U('wait_five'))
				end
			else
				local playerPed = PlayerPedId()

				if IsPedInAnyVehicle(playerPed, false) and IsVehicleModel(GetVehiclePedIsIn(playerPed, false), GetHashKey('flatbed')) then
					StartNPCJob()
				else
					ESX.ShowNotification(_U('must_in_flatbed'))
				end
			end
		end

	end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
end)


RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
  local specialContact = {
    name       = _U('mechanic'),
    number     = 'mechanic',
    base64Icon = 'data:image/png;base64,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'
  }
  TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)



