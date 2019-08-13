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

local PlayerData              = {}
local HasAlreadyEnteredMarker = false
local LastStation             = nil
local LastPart                = nil
local LastPartNum             = nil
local LastEntity              = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local IsHandcuffed            = false
local HandcuffTimer           = {}
local DragStatus              = {}
DragStatus.IsDragged          = false
local hasAlreadyJoined        = false
local blipsCops               = {}
local isDead                  = false
local CurrentTask             = {}
local playerInService         = false

ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

function SetVehicleMaxMods(vehicle)
	local props = {
		modEngine       = 2,
		modBrakes       = 2,
		modTransmission = 2,
		modSuspension   = 3,
		modTurbo        = true
	}

	ESX.Game.SetVehicleProperties(vehicle, props)
end

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

function setUniform(job, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.Uniforms[job].male ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end

			if job == 'bullet_wear' then
				SetPedArmour(playerPed, 100)
			end
		else
			if Config.Uniforms[job].female ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end

			if job == 'bullet_wear' then
				SetPedArmour(playerPed, 100)
			end
		end
	end)
end

function OpenCloakroomMenu()

	local playerPed = PlayerPedId()
	local grade = PlayerData.job.grade_name

	local elements = {
		{ label = _U('citizen_wear'), value = 'citizen_wear' },
		{ label = _U('bullet_wear'), value = 'bullet_wear' },
		{ label = _U('gilet_wear'), value = 'gilet_wear' }
	}

	if grade == 'recruit' then
		table.insert(elements, {label = _U('mercenaire_wear'), value = 'recruit_wear'})
	elseif grade == 'officer' then
		table.insert(elements, {label = _U('mercenaire_wear'), value = 'officer_wear'})
	elseif grade == 'sergeant' then
		table.insert(elements, {label = _U('mercenaire_wear'), value = 'sergeant_wear'})
	elseif grade == 'intendent' then
		table.insert(elements, {label = _U('mercenaire_wear'), value = 'intendent_wear'})
	elseif grade == 'lieutenant' then
		table.insert(elements, {label = _U('mercenaire_wear'), value = 'lieutenant_wear'})
	elseif grade == 'chef' then
		table.insert(elements, {label = _U('mercenaire_wear'), value = 'chef_wear'})
	elseif grade == 'boss' then
		table.insert(elements, {label = _U('mercenaire_wear'), value = 'boss_wear'})
	end

	if Config.EnableNonFreemodePeds then
		table.insert(elements, {label = 'Sheriff wear', value = 'freemode_ped', maleModel = 's_m_y_sheriff_01', femaleModel = 's_f_y_sheriff_01'})
		table.insert(elements, {label = 'Police wear', value = 'freemode_ped', maleModel = 's_m_y_cop_01', femaleModel = 's_f_y_cop_01'})
		table.insert(elements, {label = 'Swat wear', value = 'freemode_ped', maleModel = 's_m_y_swat_01', femaleModel = 's_m_y_swat_01'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	{
		title    = _U('cloakroom'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		cleanPlayer(playerPed)

		if data.current.value == 'citizen_wear' then
			
			if Config.EnableNonFreemodePeds then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					local isMale = skin.sex == 0

					TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
							TriggerEvent('esx:restoreLoadout')
						end)
					end)

				end)
			else
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end

			if Config.MaxInService ~= -1 then

				ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
					if isInService then

						playerInService = false

						local notification = {
							title    = _U('service_anonunce'),
							subject  = '',
							msg      = _U('service_out_announce', GetPlayerName(PlayerId())),
							iconType = 1
						}

						TriggerServerEvent('esx_service:notifyAllInService', notification, 'mercenaire')

						TriggerServerEvent('esx_service:disableService', 'mercenaire')
						TriggerEvent('esx_mercenairejob:updateBlip')
						ESX.ShowNotification(_U('service_out'))
					end
				end, 'mercenaire')
			end

		end

		if Config.MaxInService ~= -1 and data.current.value ~= 'citizen_wear' then
			local serviceOk = 'waiting'

			ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
				if not isInService then

					ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
						if not canTakeService then
							ESX.ShowNotification(_U('service_max', inServiceCount, maxInService))
						else

							serviceOk = true
							playerInService = true

							local notification = {
								title    = _U('service_anonunce'),
								subject  = '',
								msg      = _U('service_in_announce', GetPlayerName(PlayerId())),
								iconType = 1
							}
	
							TriggerServerEvent('esx_service:notifyAllInService', notification, 'mercenaire')
							TriggerEvent('esx_mercenairejob:updateBlip')
							ESX.ShowNotification(_U('service_in'))
						end
					end, 'mercenaire')

				else
					serviceOk = true
				end
			end, 'mercenaire')

			while type(serviceOk) == 'string' do
				Citizen.Wait(5)
			end

			-- if we couldn't enter service don't let the player get changed
			if not serviceOk then
				return
			end
		end

		if
			data.current.value == 'recruit_wear' or
			data.current.value == 'officer_wear' or
			data.current.value == 'sergeant_wear' or
			data.current.value == 'intendent_wear' or
			data.current.value == 'lieutenant_wear' or
			data.current.value == 'chef_wear' or
			data.current.value == 'boss_wear' or
			data.current.value == 'bullet_wear' or
			data.current.value == 'gilet_wear'
		then
			setUniform(data.current.value, playerPed)
		end

		if data.current.value == 'freemode_ped' then
			local modelHash = ''

			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					modelHash = GetHashKey(data.current.maleModel)
				else
					modelHash = GetHashKey(data.current.femaleModel)
				end

				ESX.Streaming.RequestModel(modelHash, function()
					SetPlayerModel(PlayerId(), modelHash)
					SetModelAsNoLongerNeeded(modelHash)

					TriggerEvent('esx:restoreLoadout')
				end)
			end)

		end



	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end)
end

function OpenArmoryMenu(station)

	if Config.EnableArmoryManagement then

		local elements = {
			{label = _U('get_weapon'),     value = 'get_weapon'},
			{label = _U('put_weapon'),     value = 'put_weapon'},
			{label = _U('remove_object'),  value = 'get_stock'},
			{label = _U('deposit_object'), value = 'put_stock'}
		}

		--if PlayerData.job.grade_name == 'boss' then
			--table.insert(elements, {label = _U('buy_weapons'), value = 'buy_weapons'})
		--end

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory',
		{
			title    = _U('armory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			if data.current.value == 'get_weapon' then
				OpenGetWeaponMenu()
			elseif data.current.value == 'put_weapon' then
				OpenPutWeaponMenu()
			--elseif data.current.value == 'buy_weapons' then
				--OpenBuyWeaponsMenu(station)
			elseif data.current.value == 'put_stock' then
				OpenPutStocksMenu()
			elseif data.current.value == 'get_stock' then
				OpenGetStocksMenu()
			end

		end, function(data, menu)
			menu.close()

			CurrentAction     = 'menu_armory'
			CurrentActionMsg  = _U('open_armory')
			CurrentActionData = {station = station}
		end)

	else

		local elements = {}

		for i=1, #Config.PoliceStations[station].AuthorizedWeapons, 1 do
			local weapon = Config.PoliceStations[station].AuthorizedWeapons[i]

			table.insert(elements, {
				label = ESX.GetWeaponLabel(weapon.name),
				value = weapon.name
			})
		end

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory',
		{
			title    = _U('armory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local weapon = data.current.value
			TriggerServerEvent('esx_mercenairejob:giveWeapon', weapon, 1000)
		end, function(data, menu)
			menu.close()

			CurrentAction     = 'menu_armory'
			CurrentActionMsg  = _U('open_armory')
			CurrentActionData = {station = station}
		end)

	end

end

function OpenVehicleSpawnerMenu(station, partNum)

	ESX.UI.Menu.CloseAll()

	if Config.EnableSocietyOwnedVehicles then

		local elements = {}

		ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)

			for i=1, #garageVehicles, 1 do
				table.insert(elements, {
					label = GetDisplayNameFromVehicleModel(garageVehicles[i].model) .. ' [' .. garageVehicles[i].plate .. ']',
					value = garageVehicles[i]
				})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
			{
				title    = _U('vehicle_menu'),
				align    = 'top-left',
				elements = elements
			}, function(data, menu)
				menu.close()

				local vehicleProps = data.current.value
				local foundSpawnPoint, spawnPoint = GetAvailableVehicleSpawnPoint(station, partNum)

				if foundSpawnPoint then
					ESX.Game.SpawnVehicle(vehicleProps.model, spawnPoint, spawnPoint.heading, function(vehicle)
						ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
						TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
					end)

					TriggerServerEvent('esx_society:removeVehicleFromGarage', 'mercenaire', vehicleProps)
				end
			end, function(data, menu)
				menu.close()

				CurrentAction     = 'menu_vehicle_spawner'
				CurrentActionMsg  = _U('vehicle_spawner')
				CurrentActionData = {station = station, partNum = partNum}
			end)

		end, 'mercenaire')

	else

		local elements = {}

		local sharedVehicles = Config.AuthorizedVehicles.Shared
		for i=1, #sharedVehicles, 1 do
			table.insert(elements, { label = sharedVehicles[i].label, model = sharedVehicles[i].model})
		end

		local authorizedVehicles = Config.AuthorizedVehicles[PlayerData.job.grade_name]
		for i=1, #authorizedVehicles, 1 do
			table.insert(elements, { label = authorizedVehicles[i].label, model = authorizedVehicles[i].model})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
		{
			title    = _U('vehicle_menu'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()

			local foundSpawnPoint, spawnPoint = GetAvailableVehicleSpawnPoint(station, partNum)

			if foundSpawnPoint then
				if Config.MaxInService == -1 then
					ESX.Game.SpawnVehicle(data.current.model, spawnPoint, spawnPoint.heading, function(vehicle)
						TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
						SetVehicleMaxMods(vehicle)
					end)
				else

					ESX.TriggerServerCallback('esx_service:isInService', function(isInService)

						if isInService then
							ESX.Game.SpawnVehicle(data.current.model, spawnPoint, spawnPoint.heading, function(vehicle)
								TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
								SetVehicleMaxMods(vehicle)
							end)
						else
							ESX.ShowNotification(_U('service_not'))
						end

					end, 'mercenaire')
				end
			end

		end, function(data, menu)
			menu.close()

			CurrentAction     = 'menu_vehicle_spawner'
			CurrentActionMsg  = _U('vehicle_spawner')
			CurrentActionData = {station = station, partNum = partNum}
		end)

	end
end

function GetAvailableVehicleSpawnPoint(station, partNum)
	local spawnPoints = Config.PoliceStations[station].Vehicles[partNum].SpawnPoints
	local found, foundSpawnPoint = false, nil

	for i=1, #spawnPoints, 1 do
		if ESX.Game.IsSpawnPointClear(spawnPoints[i], spawnPoints[i].radius) then
			found, foundSpawnPoint = true, spawnPoints[i]
			break
		end
	end

	if found then
		return true, foundSpawnPoint
	else
		ESX.ShowNotification(_U('vehicle_blocked'))
		return false
	end
end

function OpenPoliceActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mercenaire_actions',
	{
		title    = 'Mercenaire',
		align    = 'top-left',
		elements = {
			{label = _U('citizen_interaction'),	value = 'citizen_interaction'},
			{label = _U('vehicle_interaction'),	value = 'vehicle_interaction'},
			--{label = _U('object_spawner'),		value = 'object_spawner'}
		}
	}, function(data, menu)

		if data.current.value == 'citizen_interaction' then
			local elements = {
				{label = _U('id_card'),			value = 'identity_card'},
				{label = _U('search'),			value = 'body_search'},
				{label = _U('handcuff'),		value = 'handcuff'},
				{label = _U('drag'),			value = 'drag'},
				{label = _U('put_in_vehicle'),	value = 'put_in_vehicle'},
				{label = _U('out_the_vehicle'),	value = 'out_the_vehicle'},
				--{label = _U('fine'),			value = 'fine'},
				--{label = _U('unpaid_bills'),	value = 'unpaid_bills'}
			}
		
			--if Config.EnableLicenses then
				--table.insert(elements, { label = _U('license_check'), value = 'license' })
			--end
		
			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'citizen_interaction',
			{
				title    = _U('citizen_interaction'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					local action = data2.current.value

					if action == 'identity_card' then
						OpenIdentityCardMenu(closestPlayer)
					elseif action == 'body_search' then
						TriggerServerEvent('esx_mercenairejob:message', GetPlayerServerId(closestPlayer), _U('being_searched'))
						OpenBodySearchMenu(closestPlayer)
					elseif action == 'handcuff' then
						TriggerServerEvent('esx_mercenairejob:handcuff', GetPlayerServerId(closestPlayer))
					elseif action == 'drag' then
						TriggerServerEvent('esx_mercenairejob:drag', GetPlayerServerId(closestPlayer))
					elseif action == 'put_in_vehicle' then
						TriggerServerEvent('esx_mercenairejob:putInVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'out_the_vehicle' then
						TriggerServerEvent('esx_mercenairejob:OutVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'fine' then
						OpenFineMenu(closestPlayer)
					elseif action == 'license' then
						ShowPlayerLicense(closestPlayer)
					elseif action == 'unpaid_bills' then
						OpenUnpaidBillsMenu(closestPlayer)
					end

				else
					ESX.ShowNotification(_U('no_players_nearby'))
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'vehicle_interaction' then
			local elements  = {}
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			local vehicle   = ESX.Game.GetVehicleInDirection()
			
			if DoesEntityExist(vehicle) then
				table.insert(elements, {label = _U('vehicle_info'),	value = 'vehicle_infos'})
				table.insert(elements, {label = _U('pick_lock'),	value = 'hijack_vehicle'})
				table.insert(elements, {label = _U('impound'),		value = 'impound'})
			end
			
			table.insert(elements, {label = _U('search_database'), value = 'search_database'})

			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'vehicle_interaction',
			{
				title    = _U('vehicle_interaction'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				coords  = GetEntityCoords(playerPed)
				vehicle = ESX.Game.GetVehicleInDirection()
				action  = data2.current.value
				
				if action == 'search_database' then
					LookupVehicle()
				elseif DoesEntityExist(vehicle) then
					local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
					if action == 'vehicle_infos' then
						OpenVehicleInfosMenu(vehicleData)
						
					elseif action == 'hijack_vehicle' then
						if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
							TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
							Citizen.Wait(20000)
							ClearPedTasksImmediately(playerPed)

							SetVehicleDoorsLocked(vehicle, 1)
							SetVehicleDoorsLockedForAllPlayers(vehicle, false)
							ESX.ShowNotification(_U('vehicle_unlocked'))
						end
					elseif action == 'impound' then
					
						-- is the script busy?
						if CurrentTask.Busy then
							return
						end

						ESX.ShowHelpNotification(_U('impound_prompt'))
						
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
						
						CurrentTask.Busy = true
						CurrentTask.Task = ESX.SetTimeout(10000, function()
							ClearPedTasks(playerPed)
							ImpoundVehicle(vehicle)
							Citizen.Wait(100) -- sleep the entire script to let stuff sink back to reality
						end)
						
						-- keep track of that vehicle!
						Citizen.CreateThread(function()
							while CurrentTask.Busy do
								Citizen.Wait(1000)
							
								vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
								if not DoesEntityExist(vehicle) and CurrentTask.Busy then
									ESX.ShowNotification(_U('impound_canceled_moved'))
									ESX.ClearTimeout(CurrentTask.Task)
									ClearPedTasks(playerPed)
									CurrentTask.Busy = false
									break
								end
							end
						end)
					end
				else
					ESX.ShowNotification(_U('no_vehicles_nearby'))
				end

			end, function(data2, menu2)
				menu2.close()
			end)

		elseif data.current.value == 'object_spawner' then
			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'citizen_interaction',
			{
				title    = _U('traffic_interaction'),
				align    = 'top-left',
				elements = {
					{label = _U('cone'),		value = 'prop_roadcone02a'},
					{label = _U('barrier'),		value = 'prop_barrier_work05'},
					{label = _U('spikestrips'),	value = 'p_ld_stinger_s'},
					{label = _U('box'),			value = 'prop_boxpile_07d'},
					{label = _U('cash'),		value = 'hei_prop_cash_crate_half_full'}
				}
			}, function(data2, menu2)
				local model     = data2.current.value
				local playerPed = PlayerPedId()
				local coords    = GetEntityCoords(playerPed)
				local forward   = GetEntityForwardVector(playerPed)
				local x, y, z   = table.unpack(coords + forward * 1.0)

				if model == 'prop_roadcone02a' then
					z = z - 2.0
				end

				ESX.Game.SpawnObject(model, {
					x = x,
					y = y,
					z = z
				}, function(obj)
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

function OpenIdentityCardMenu(player)

	ESX.TriggerServerCallback('esx_mercenairejob:getOtherPlayerData', function(data)

		local elements    = {}
		local nameLabel   = _U('name', data.name)
		local jobLabel    = nil
		local sexLabel    = nil
		local dobLabel    = nil
		local heightLabel = nil
		local idLabel     = nil
	
		if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
			jobLabel = _U('job', data.job.label .. ' - ' .. data.job.grade_label)
		else
			jobLabel = _U('job', data.job.label)
		end
	
		if Config.EnableESXIdentity then
	
			nameLabel = _U('name', data.firstname .. ' ' .. data.lastname)
	
			if data.sex ~= nil then
				if string.lower(data.sex) == 'm' then
					sexLabel = _U('sex', _U('male'))
				else
					sexLabel = _U('sex', _U('female'))
				end
			else
				sexLabel = _U('sex', _U('unknown'))
			end
	
			if data.dob ~= nil then
				dobLabel = _U('dob', data.dob)
			else
				dobLabel = _U('dob', _U('unknown'))
			end
	
			if data.height ~= nil then
				heightLabel = _U('height', data.height)
			else
				heightLabel = _U('height', _U('unknown'))
			end
	
			if data.name ~= nil then
				idLabel = _U('id', data.name)
			else
				idLabel = _U('id', _U('unknown'))
			end
	
		end
	
		local elements = {
			{label = nameLabel, value = nil},
			{label = jobLabel,  value = nil},
		}
	
		if Config.EnableESXIdentity then
			table.insert(elements, {label = sexLabel, value = nil})
			table.insert(elements, {label = dobLabel, value = nil})
			table.insert(elements, {label = heightLabel, value = nil})
			table.insert(elements, {label = idLabel, value = nil})
		end
	
		if data.drunk ~= nil then
			table.insert(elements, {label = _U('mercenaire', data.drunk), value = nil})
		end
	
		if data.licenses ~= nil then
	
			table.insert(elements, {label = _U('license_label'), value = nil})
	
			for i=1, #data.licenses, 1 do
				table.insert(elements, {label = data.licenses[i].label, value = nil})
			end
	
		end
	
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction',
		{
			title    = _U('citizen_interaction'),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
	
		end, function(data, menu)
			menu.close()
		end)
	
	end, GetPlayerServerId(player))

end

function OpenBodySearchMenu(player)

	ESX.TriggerServerCallback('esx_mercenairejob:getOtherPlayerData', function(data)

		local elements = {}

		for i=1, #data.accounts, 1 do

			if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then

				table.insert(elements, {
					label    = _U('confiscate_dirty', ESX.Round(data.accounts[i].money)),
					value    = 'black_money',
					itemType = 'item_account',
					amount   = data.accounts[i].money
				})

				break
			end

		end

		table.insert(elements, {label = _U('guns_label'), value = nil})

		for i=1, #data.weapons, 1 do
			table.insert(elements, {
				label    = _U('confiscate_weapon', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
				value    = data.weapons[i].name,
				itemType = 'item_weapon',
				amount   = data.weapons[i].ammo
			})
		end

		table.insert(elements, {label = _U('inventory_label'), value = nil})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
				label    = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
				value    = data.inventory[i].name,
				itemType = 'item_standard',
				amount   = data.inventory[i].count
				})
			end
		end


		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search',
		{
			title    = _U('search'),
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)

			local itemType = data.current.itemType
			local itemName = data.current.value
			local amount   = data.current.amount

			if data.current.value ~= nil then
				TriggerServerEvent('esx_mercenairejob:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)
				OpenBodySearchMenu(player)
			end

		end, function(data, menu)
			menu.close()
		end)

	end, GetPlayerServerId(player))

end

function OpenFineMenu(player)

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine',
	{
		title    = _U('fine'),
		align    = 'top-left',
		elements = {
			{label = _U('traffic_offense'), value = 0},
			{label = _U('minor_offense'),   value = 1},
			{label = _U('average_offense'), value = 2},
			{label = _U('major_offense'),   value = 3}
		}
	}, function(data, menu)
		OpenFineCategoryMenu(player, data.current.value)
	end, function(data, menu)
		menu.close()
	end)

end

function OpenFineCategoryMenu(player, category)

	ESX.TriggerServerCallback('esx_mercenairejob:getFineList', function(fines)

		local elements = {}

		for i=1, #fines, 1 do
			table.insert(elements, {
				label     = fines[i].label .. ' <span style="color: green;">$' .. fines[i].amount .. '</span>',
				value     = fines[i].id,
				amount    = fines[i].amount,
				fineLabel = fines[i].label
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine_category',
		{
			title    = _U('fine'),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)

			local label  = data.current.fineLabel
			local amount = data.current.amount

			menu.close()

			if Config.EnablePlayerManagement then
				TriggerServerEvent('esx_billing:envoiBill', GetPlayerServerId(player), 'society_mercenaire', _U('fine_total', label), amount)
			else
				TriggerServerEvent('esx_billing:envoiBill', GetPlayerServerId(player), '', _U('fine_total', label), amount)
			end

			ESX.SetTimeout(300, function()
				OpenFineCategoryMenu(player, category)
			end)

		end, function(data, menu)
			menu.close()
		end)

	end, category)

end

function LookupVehicle()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle',
	{
		title = _U('search_database_title'),
	}, function(data, menu)
		local length = string.len(data.value)
		if data.value == nil or length < 2 or length > 13 then
			ESX.ShowNotification(_U('search_database_error_invalid'))
		else
			ESX.TriggerServerCallback('esx_mercenairejob:getVehicleFromPlate', function(owner, found)
				if found then
					ESX.ShowNotification(_U('search_database_found', owner))
				else
					ESX.ShowNotification(_U('search_database_error_not_found'))
				end
			end, data.value)
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function ShowPlayerLicense(player)
	local elements = {}
	local targetName
	ESX.TriggerServerCallback('esx_mercenairejob:getOtherPlayerData', function(data)
		if data.licenses ~= nil then
			for i=1, #data.licenses, 1 do
				if data.licenses[i].label ~= nil and data.licenses[i].type ~= nil then
					table.insert(elements, {label = data.licenses[i].label, value = data.licenses[i].type})
				end
			end
		end
		
		if Config.EnableESXIdentity then
			targetName = data.firstname .. ' ' .. data.lastname
		else
			targetName = data.name
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_license',
		{
			title    = _U('license_revoke'),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
			ESX.ShowNotification(_U('licence_you_revoked', data.current.label, targetName))
			TriggerServerEvent('esx_mercenairejob:message', GetPlayerServerId(player), _U('license_revoked', data.current.label))
			
			TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.value)
			
			ESX.SetTimeout(300, function()
				ShowPlayerLicense(player)
			end)
		end, function(data, menu)
			menu.close()
		end)

	end, GetPlayerServerId(player))
end

function OpenUnpaidBillsMenu(player)
	local elements = {}

	ESX.TriggerServerCallback('esx_billing:getTargetBills', function(bills)
		for i=1, #bills, 1 do
			table.insert(elements, {
				label = bills[i].label .. ' - <span style="color: red;">$' .. bills[i].amount .. '</span>',
				value = bills[i].id
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing',
		{
			title    = _U('unpaid_bills'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
	
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenVehicleInfosMenu(vehicleData)

	ESX.TriggerServerCallback('esx_mercenairejob:getVehicleInfos', function(retrivedInfo)

		local elements = {}

		table.insert(elements, {label = _U('plate', retrivedInfo.plate), value = nil})

		if retrivedInfo.owner == nil then
			table.insert(elements, {label = _U('owner_unknown'), value = nil})
		else
			table.insert(elements, {label = _U('owner', retrivedInfo.owner), value = nil})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos',
		{
			title    = _U('vehicle_info'),
			align    = 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)

	end, vehicleData.plate)

end

function OpenGetWeaponMenu()

	ESX.TriggerServerCallback('esx_mercenairejob:getArmoryWeapons', function(weapons)
		local elements = {}

		for i=1, #weapons, 1 do
			if weapons[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name),
					value = weapons[i].name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon',
		{
			title    = _U('get_weapon_menu'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			menu.close()

			ESX.TriggerServerCallback('esx_mercenairejob:removeArmoryWeapon', function()
				OpenGetWeaponMenu()
			end, data.current.value)

		end, function(data, menu)
			menu.close()
		end)
	end)

end

function OpenPutWeaponMenu()
	local elements   = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()

	for i=1, #weaponList, 1 do
		local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			table.insert(elements, {
				label = weaponList[i].label,
				value = weaponList[i].name
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon',
	{
		title    = _U('put_weapon_menu'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		menu.close()

		ESX.TriggerServerCallback('esx_mercenairejob:addArmoryWeapon', function()
			OpenPutWeaponMenu()
		end, data.current.value, true)

	end, function(data, menu)
		menu.close()
	end)
end



function OpenGetStocksMenu()

	ESX.TriggerServerCallback('esx_mercenairejob:getStockItems', function(items)

		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {
				label = 'x' .. items[i].count .. ' ' .. items[i].label,
				value = items[i].name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
		{
			title    = _U('mercenaire_stock'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)

				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_mercenairejob:getStockItem', itemName, count)

					Citizen.Wait(300)
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

	ESX.TriggerServerCallback('esx_mercenairejob:getPlayerInventory', function(inventory)

		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
		{
			title    = _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)

				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_mercenairejob:putStockItems', itemName, count)

					Citizen.Wait(300)
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

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	
	Citizen.Wait(5000)
	TriggerServerEvent('esx_mercenairejob:forceBlip')
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = _U('phone_mercenaire'),
		number     = 'mercenaire',
		base64Icon = 'data:image/png;base64,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/P6fHg/at7a3bX6yYAQaSXBMniSEIg32aNmKZmNeArRUWtNidvajH05feukbsTqYTCbT6dw0xXA4TOLUu4bahpSMtQKwLqp1dTIYjXujIXSuMpPJeLpcymS1Wq1+/z+99sorL770wi0AqC/EdrHc5qcAQGLTmwihnjuYm8+3nvwpRXZDcCjwEZdwl0oDVUZApFEMgK0z1gGQQCfT3tummiulDvZ63VxeXFy8+qP/9PyzL9dVk+peW7V33z/e3TnQWl/fvxVF0WI6m06nrql7eayocW0j4ddzG0WRjlRd13VdK626/U6vnzE7+CqJHACzPpNEA+3JmZdfuPE/nb5Xw2oF783GrkzwbEFWJWnrWiewKN0rv/Y3GxGTcB/efa8s1865UFADQBR98hw+IunokfaB/izodrudTme5Ws5ms7feeouZB4PBer3uqysLcUVs+KioKW0uEgvQppCWELRtrG2t9Z7feuutbqevlOp0Om1rguuKICV74QASgbF4iLqu7XR6cHDQH/aPjo7atn799dfv3T3+h//w70WRAj6n3+DnBNtovMAD4zju9/ta6zfeeOO5555rrPlP3/uDp596VpE6ODiw1s7n87op27ZFqDUvZbBEDwaduq6LctW2bRRFYZu01mXZCEFSKiFBxKF+sHN2d+ew1+tN5xNrt3EfG9MfgLLcCIFZN/nqV78aRdG777wXQgcAHB4ePv/889jIfo8wi+cz4OeGDJuyMR6z2erVV19dLpeh75sRAhs54bKUKG+csuHGkOmLjwqv+MsYfSAkTzsAdrU6Gg6rXncQ4jVDwiFz21ExEYGk1iQiYT2Mc9VqRUQH1w6rqrh///5kcv4P/sFvxrEeDHr1+uLntzufD65WghJCdDqdLMuaRt17cP/o/oPHH388iqIkSZI8m0+mk8mE4YhISblNvgPQslvV5bosoijqDgej0UhHsvU26eTOOedtazdhwlJJSaqjummeAZMr09jItFEct00TdmZ//+CVl18hxo9//OPlchm++au/+qtf//rX8TMUQ/5i8HPz+T3xxBNJEuog4PT09OJi2u12b9++zUKykE5KJ8lJ8kJ6SV6QF7SpKx+KKW2Tj69UxcNliLJzTilRFMXJycnFxVld16GMEDM7y87De289ACFlCFDl8/Pzt99+8913316vl//gv/ov0zS+fuPg/t0Pf94b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pFVmjEmShHOeQ2gILOKCHmA+bw0AZNFxvLgbMWJBEFQKPYJJnRlGgEJwQETKC5R5TcYRoFUmpSSjAdnWLVue3v6MGzitZh1U1G43V6xYIQQ7PjHW7cKtt10dhmGl2nP48NG7v/7tNWtWDA4OCydI0+yee+7JNG3durlUKiHR/v37EXHNmjVSymXLlrmBqNfrROR7Xn9//8zMzO59e7dt3z4/HwPA+edvHBzqtwbGx453u938kX9iG2FBzKqbeL7j+57nlQJPaG2EEENDI6Viod1u1+dnm81mEsV5RsEY8/xC1I2zJBMOSMfjwp2Zq23ZesaVV71u/Ojod797/+jYBABkWfae97xncHDgZK+LH6adituk72O5mmV+y9euXfuWt7wlb/7v2bPvs5/9LBGefvrp9XozjtJ87RpjGONxnEoplVKMsTwmIKN8fUOu3WKtw0WWaattpVjprfQy4CrOyAIQI4bWQr6PMlYhYjEEa23gOtYoncVbNq0DMmjUM9ufvOfeb05MTXqBq0zW6badADZsWFcoeAS6UHTjCAaGysWSBxQXQ+EI02npUqHgCOG6rud5aZwIIbrdrtba93038IeHl1WqvWvXbRg7PnfXV759+HANAAYH3U0bNyJiEHpPb3+yUi3lukf59YFF9BERaW3jKNXa+I7vuguSWb7v9/b2DQ8Pr169et26davWrB4aGiqVSr7vxxmlBgrlXj8oEvB2N3W98H0//wuFQum7D9z/rW/f64e+I53Vq1e/5c23vlyenlPcXjXOkA/yxnGcD6YBgBDixhtvvOiii3zfl0IePHj4nm/de8W11y1fscoiI5RcSuG4XIo8MiiVMsaWPCGfC8qfn4yY1eRJt1yslAplwaTNjM4MGch9TymVZdnCCIQxQeDoLAGypJXR2UBPZbi/mnT1ob17x6e7K9eszEwWq6SbdFetGmi1a9okcdRANJ4PPdVClrWibs2YzvLlfY4ERwirdafV8hxncnJCSikY11oXi8U4ThOVzdVrQbGQaogVIECpiFdcfqnvu2maNuuNgwfH8kB0Yk+Nc54P9HAus0w36q16vZEkGRCzBrrdOElTznm1t3/NmjWbNm1av3HD6rVrlq9csXrDlpl6e//h0WMT04oEd/2zL7hg82lnztfqTz7x9P79R5RSmcpuvPHGradtLoavyn7CS9mrxhkAgDG2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'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

-- don't show dispatches if the player isn't in service
AddEventHandler('esx_phone:cancelMessage', function(dispatchNumber)
	if type(PlayerData.job.name) == 'string' and PlayerData.job.name == 'mercenaire' and PlayerData.job.name == dispatchNumber then
		-- if esx_service is enabled
		if Config.MaxInService ~= -1 and not playerInService then
			CancelEvent()
		end
	end
end)

AddEventHandler('esx_mercenairejob:hasEnteredMarker', function(station, part, partNum)

	if part == 'Cloakroom' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}

	elseif part == 'Armory' then

		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}

	elseif part == 'VehicleSpawner' then

		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('vehicle_spawner')
		CurrentActionData = {station = station, partNum = partNum}

	elseif part == 'HelicopterSpawner' then

		local helicopters = Config.PoliceStations[station].Helicopters

		if not IsAnyVehicleNearPoint(helicopters[partNum].SpawnPoint.x, helicopters[partNum].SpawnPoint.y, helicopters[partNum].SpawnPoint.z,  3.0) then
			ESX.Game.SpawnVehicle('polmav', helicopters[partNum].SpawnPoint, helicopters[partNum].Heading, function(vehicle)
				SetVehicleModKit(vehicle, 0)
				SetVehicleLivery(vehicle, 0)
			end)
		end

	elseif part == 'VehicleDeleter' then

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed,  false) then

			local vehicle = GetVehiclePedIsIn(playerPed, false)

			if DoesEntityExist(vehicle) then
				CurrentAction     = 'delete_vehicle'
				CurrentActionMsg  = _U('store_vehicle')
				CurrentActionData = {vehicle = vehicle}
			end

		end

	elseif part == 'BossActions' then

		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}

	end

end)

AddEventHandler('esx_mercenairejob:hasExitedMarker', function(station, part, partNum)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

AddEventHandler('esx_mercenairejob:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if PlayerData.job ~= nil and PlayerData.job.name == 'mercenaire' and IsPedOnFoot(playerPed) then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = _U('remove_prop')
		CurrentActionData = {entity = entity}
	end

	if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed)

			for i=0, 7, 1 do
				SetVehicleTyreBurst(vehicle, i, true, 1000)
			end
		end
	end
end)

AddEventHandler('esx_mercenairejob:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

RegisterNetEvent('esx_mercenairejob:handcuff')
AddEventHandler('esx_mercenairejob:handcuff', function()
	IsHandcuffed    = not IsHandcuffed
	local playerPed = PlayerPedId()

	Citizen.CreateThread(function()
		if IsHandcuffed then

			RequestAnimDict('mp_arresting')
			while not HasAnimDictLoaded('mp_arresting') do
				Citizen.Wait(100)
			end

			TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

			SetEnableHandcuffs(playerPed, true)
			DisablePlayerFiring(playerPed, true)
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
			SetPedCanPlayGestureAnims(playerPed, false)
			FreezeEntityPosition(playerPed, true)
			DisplayRadar(false)

			if Config.EnableHandcuffTimer then

				if HandcuffTimer.Active then
					ESX.ClearTimeout(HandcuffTimer.Task)
				end

				StartHandcuffTimer()
			end

		else

			if Config.EnableHandcuffTimer and HandcuffTimer.Active then
				ESX.ClearTimeout(HandcuffTimer.Task)
			end

			ClearPedSecondaryTask(playerPed)
			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed, true)
			FreezeEntityPosition(playerPed, false)
			DisplayRadar(true)
		end
	end)

end)

RegisterNetEvent('esx_mercenairejob:unrestrain')
AddEventHandler('esx_mercenairejob:unrestrain', function()
	if IsHandcuffed then
		local playerPed = PlayerPedId()
		IsHandcuffed = false

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)

		-- end timer
		if Config.EnableHandcuffTimer and HandcuffTimer.Active then
			ESX.ClearTimeout(HandcuffTimer.Task)
		end
	end
end)

RegisterNetEvent('esx_mercenairejob:drag')
AddEventHandler('esx_mercenairejob:drag', function(copID)
	if not IsHandcuffed then
		return
	end

	DragStatus.IsDragged = not DragStatus.IsDragged
	DragStatus.CopId     = tonumber(copID)
end)

Citizen.CreateThread(function()
	local playerPed
	local targetPed

	while true do
		Citizen.Wait(1)

		if IsHandcuffed then
			playerPed = PlayerPedId()

			if DragStatus.IsDragged then
				targetPed = GetPlayerPed(GetPlayerFromServerId(DragStatus.CopId))

				-- undrag if target is in an vehicle
				if not IsPedSittingInAnyVehicle(targetPed) then
					AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					DragStatus.IsDragged = false
					DetachEntity(playerPed, true, false)
				end

				if IsPedDeadOrDying(targetPed, true) then
					DragStatus.IsDragged = false
					DetachEntity(playerPed, true, false)
				end

			else
				DetachEntity(playerPed, true, false)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_mercenairejob:putInVehicle')
AddEventHandler('esx_mercenairejob:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if not IsHandcuffed then
		return
	end

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
			local freeSeat = nil

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat ~= nil then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				DragStatus.IsDragged = false
			end
		end
	end
end)

RegisterNetEvent('esx_mercenairejob:OutVehicle')
AddEventHandler('esx_mercenairejob:OutVehicle', function()
	local playerPed = PlayerPedId()

	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
end)

-- Handcuff
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local playerPed = PlayerPedId()

		if IsHandcuffed then
			DisableControlAction(0, 1, true) -- Disable pan
			DisableControlAction(0, 2, true) -- Disable tilt
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, Keys['W'], true) -- W
			DisableControlAction(0, Keys['A'], true) -- A
			DisableControlAction(0, 31, true) -- S (fault in Keys table!)
			DisableControlAction(0, 30, true) -- D (fault in Keys table!)

			DisableControlAction(0, Keys['R'], true) -- Reload
			DisableControlAction(0, Keys['SPACE'], true) -- Jump
			DisableControlAction(0, Keys['Q'], true) -- Cover
			DisableControlAction(0, Keys['TAB'], true) -- Select Weapon
			DisableControlAction(0, Keys['F'], true) -- Also 'enter'?

			DisableControlAction(0, Keys['F1'], true) -- Disable phone
			DisableControlAction(0, Keys['F2'], true) -- Inventory
			DisableControlAction(0, Keys['F3'], true) -- Animations
			DisableControlAction(0, Keys['F6'], true) -- Job

			DisableControlAction(0, Keys['V'], true) -- Disable changing view
			DisableControlAction(0, Keys['C'], true) -- Disable looking behind
			DisableControlAction(0, Keys['X'], true) -- Disable clearing animation
			DisableControlAction(2, Keys['P'], true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle

			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Create blips
Citizen.CreateThread(function()

	for k,v in pairs(Config.PoliceStations) do
		local blip = AddBlipForCoord(v.Blip.Pos.x, v.Blip.Pos.y, v.Blip.Pos.z)

		SetBlipSprite (blip, v.Blip.Sprite)
		SetBlipDisplay(blip, v.Blip.Display)
		SetBlipScale  (blip, v.Blip.Scale)
		SetBlipColour (blip, v.Blip.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('map_blip'))
		EndTextCommandSetBlipName(blip)
	end

end)

-- Display markers
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(1)

		if PlayerData.job ~= nil and PlayerData.job.name == 'mercenaire' then

			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)

			for k,v in pairs(Config.PoliceStations) do

				for i=1, #v.Cloakrooms, 1 do
					if GetDistanceBetweenCoords(coords, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, true) < Config.DrawDistance then
						DrawMarker(Config.MarkerType, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

				for i=1, #v.Armories, 1 do
					if GetDistanceBetweenCoords(coords, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, true) < Config.DrawDistance then
						DrawMarker(Config.MarkerType, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

				for i=1, #v.Vehicles, 1 do
					if GetDistanceBetweenCoords(coords, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, true) < Config.DrawDistance then
						DrawMarker(Config.MarkerType, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

				for i=1, #v.VehicleDeleters, 1 do
					if GetDistanceBetweenCoords(coords, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, true) < Config.DrawDistance then
						DrawMarker(Config.MarkerType, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

				if Config.EnablePlayerManagement and PlayerData.job.grade_name == 'boss' then
					for i=1, #v.BossActions, 1 do
						if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, true) < Config.DrawDistance then
							DrawMarker(Config.MarkerType, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
						end
					end
				end

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

		if PlayerData.job ~= nil and PlayerData.job.name == 'mercenaire' then

			local playerPed      = PlayerPedId()
			local coords         = GetEntityCoords(playerPed)
			local isInMarker     = false
			local currentStation = nil
			local currentPart    = nil
			local currentPartNum = nil

			for k,v in pairs(Config.PoliceStations) do

				for i=1, #v.Cloakrooms, 1 do
					if GetDistanceBetweenCoords(coords, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, true) < Config.MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'Cloakroom'
						currentPartNum = i
					end
				end

				for i=1, #v.Armories, 1 do
					if GetDistanceBetweenCoords(coords, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, true) < Config.MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'Armory'
						currentPartNum = i
					end
				end

				for i=1, #v.Vehicles, 1 do
					if GetDistanceBetweenCoords(coords, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, true) < Config.MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'VehicleSpawner'
						currentPartNum = i
					end
				end

				for i=1, #v.Helicopters, 1 do
					if GetDistanceBetweenCoords(coords, v.Helicopters[i].Spawner.x, v.Helicopters[i].Spawner.y, v.Helicopters[i].Spawner.z, true) < Config.MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'HelicopterSpawner'
						currentPartNum = i
					end
				end

				for i=1, #v.VehicleDeleters, 1 do
					if GetDistanceBetweenCoords(coords, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, true) < Config.MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'VehicleDeleter'
						currentPartNum = i
					end
				end

				if Config.EnablePlayerManagement and PlayerData.job.grade_name == 'boss' then
					for i=1, #v.BossActions, 1 do
						if GetDistanceBetweenCoords(coords, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, true) < Config.MarkerSize.x then
							isInMarker     = true
							currentStation = k
							currentPart    = 'BossActions'
							currentPartNum = i
						end
					end
				end

			end

			local hasExited = false

			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then

				if
					(LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
					(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('esx_mercenairejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker = true
				LastStation             = currentStation
				LastPart                = currentPart
				LastPartNum             = currentPartNum

				TriggerEvent('esx_mercenairejob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_mercenairejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
			end

		else
			Citizen.Wait(500)
		end

	end
end)

-- Enter / Exit entity zone events
Citizen.CreateThread(function()
	local trackedEntities = {
		'prop_roadcone02a',
		'prop_barrier_work05',
		'p_ld_stinger_s',
		'prop_boxpile_07d',
		'hei_prop_cash_crate_half_full'
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
				TriggerEvent('esx_mercenairejob:hasEnteredEntityZone', closestEntity)
				LastEntity = closestEntity
			end
		else
			if LastEntity ~= nil then
				TriggerEvent('esx_mercenairejob:hasExitedEntityZone', LastEntity)
				LastEntity = nil
			end
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do

    Citizen.Wait(10)

    if CurrentAction ~= nil then

      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

            if IsControlJustReleased(0, Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'mercenaire' then

                if CurrentAction == 'menu_cloakroom' then
                    OpenCloakroomMenu()
                elseif CurrentAction == 'menu_armory' then
                    if Config.MaxInService == -1 then
                        OpenArmoryMenu(CurrentActionData.station)
                    elseif playerInService then
						OpenArmoryMenu(CurrentActionData.station)
					else
						ESX.ShowNotification(_U('service_not'))
					end
				elseif CurrentAction == 'menu_vehicle_spawner' then
					OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
				elseif CurrentAction == 'delete_vehicle' then
					if Config.EnableSocietyOwnedVehicles then
						local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
						TriggerServerEvent('esx_society:putVehicleInGarage', 'mercenaire', vehicleProps)
					end
					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				elseif CurrentAction == 'menu_boss_actions' then
					ESX.UI.Menu.CloseAll()
					TriggerEvent('esx_society:ouvrirBossMenu', 'mercenaire', function(data, menu)
						menu.close()
						CurrentAction     = 'menu_boss_actions'
						CurrentActionMsg  = _U('open_bossmenu')
						CurrentActionData = {}
					end, { wash = true }) -- disable washing money
				elseif CurrentAction == 'remove_entity' then
					DeleteEntity(CurrentActionData.entity)
				end
				
				CurrentAction = nil
			end
		end -- CurrentAction end
		
		if IsControlJustReleased(0, Keys['F6']) and not isDead and PlayerData.job ~= nil and PlayerData.job.name == 'mercenaire' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'mercenaire_actions') then
			if Config.MaxInService == -1 then
				OpenPoliceActionsMenu()
			elseif playerInService then
				OpenPoliceActionsMenu()
			else
				ESX.ShowNotification(_U('service_not'))
			end
		end
		
		if IsControlJustReleased(0, Keys['E']) and CurrentTask.Busy then
			ESX.ShowNotification(_U('impound_canceled'))
			ESX.ClearTimeout(CurrentTask.Task)
			ClearPedTasks(PlayerPedId())
			
			CurrentTask.Busy = false
		end
	end
end)

-- Create blip for colleagues
function createBlip(id)
	local ped = GetPlayerPed(id)
	local blip = GetBlipFromEntity(ped)

	if not DoesBlipExist(blip) then -- Add blip and create head display on player
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 1)
		ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
		SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
		SetBlipNameToPlayerName(blip, id) -- update blip name
		SetBlipScale(blip, 0.85) -- set scale
		SetBlipAsShortRange(blip, true)
		
		table.insert(blipsCops, blip) -- add blip to array so we can remove it later
	end
end

RegisterNetEvent('esx_mercenairejob:updateBlip')
AddEventHandler('esx_mercenairejob:updateBlip', function()
	
	-- Refresh all blips
	for k, existingBlip in pairs(blipsCops) do
		RemoveBlip(existingBlip)
	end
	
	-- Clean the blip table
	blipsCops = {}

	-- Enable blip?
	if Config.MaxInService ~= -1 and not playerInService then
		return
	end

	if not Config.EnableJobBlip then
		return
	end
	
	-- Is the player a cop? In that case show all the blips for other cops
	if PlayerData.job ~= nil and PlayerData.job.name == 'mercenaire' then
		ESX.TriggerServerCallback('esx_society:getOnlinePlayers', function(players)
			for i=1, #players, 1 do
				if players[i].job.name == 'mercenaire' then
					local id = GetPlayerFromServerId(players[i].source)
					if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
						createBlip(id)
					end
				end
			end
		end)
	end

end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
	TriggerEvent('esx_mercenairejob:unrestrain')
	
	if not hasAlreadyJoined then
		TriggerServerEvent('esx_mercenairejob:spawned')
	end
	hasAlreadyJoined = true
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_mercenairejob:unrestrain')
		TriggerEvent('esx_phone:removeSpecialContact', 'mercenaire')

		if Config.MaxInService ~= -1 then
			TriggerServerEvent('esx_service:disableService', 'mercenaire')
		end

		if Config.EnableHandcuffTimer and HandcuffTimer.Active then
			ESX.ClearTimeout(HandcuffTimer.Task)
		end
	end
end)

-- handcuff timer, unrestrain the player after an certain amount of time
function StartHandcuffTimer()
	if Config.EnableHandcuffTimer and HandcuffTimer.Active then
		ESX.ClearTimeout(HandcuffTimer.Task)
	end

	HandcuffTimer.Active = true

	HandcuffTimer.Task = ESX.SetTimeout(Config.HandcuffTimer, function()
		ESX.ShowNotification(_U('unrestrained_timer'))
		TriggerEvent('esx_mercenairejob:unrestrain')
		HandcuffTimer.Active = false
	end)
end

-- TODO
--   - return to garage if owned
--   - message owner that his vehicle has been impounded
function ImpoundVehicle(vehicle)
	--local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
	ESX.Game.DeleteVehicle(vehicle) 
	ESX.ShowNotification(_U('impound_successful'))
	CurrentTask.Busy = false
end
