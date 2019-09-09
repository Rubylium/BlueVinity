
local hasAlreadyEnteredMarker, hasPaid, currentActionData = false, false, {}
local lastZone, currentAction, currentActionMsg
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function OpenShopMenu()
	local elements = {}


	table.insert(elements, {label = "Achats de vêtements <span style='color:cyan;'> >",  value = 'shop_clothes'})
	table.insert(elements, {label = "Changer ça tenu <span style='color:cyan;'> >", value = 'player_dressing'})
	table.insert(elements, {label = "Supprimer une tenu <span style='color:cyan;'> >", value = 'suppr_cloth'})
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'shop_main',
		{
			css = 'vestiaire',
			title    = "Shop de vêtements",
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)
		menu.close()

		if data.current.value == 'shop_clothes' then
			hasPaid = false

			TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)
				menu.close()
			
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
					title = "Valider l'achat",
					align = 'top-left',
					elements = {
						{label = _U('no'), value = 'no'},
						{label = _U('yes'), value = 'yes'}
				}}, function(data, menu)
					menu.close()
				
					if data.current.value == 'yes' then
						ESX.TriggerServerCallback('esx_clotheshop:buyClothes', function(bought)
							if bought then
								TriggerEvent('skinchanger:getSkin', function(skin)
									TriggerServerEvent('esx_skin:save', skin)
								end)
							
								hasPaid = true
							
								ESX.TriggerServerCallback('esx_clotheshop:checkPropertyDataStore', function(foundStore)
									if foundStore then
										ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'save_dressing', {
											title = _U('save_in_dressing'),
											align = 'top-left',
											elements = {
												{label = _U('no'),  value = 'no'},
												{label = _U('yes'), value = 'yes'}
										}}, function(data2, menu2)
											menu2.close()
										
											if data2.current.value == 'yes' then
												ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'outfit_name', {
													title = _U('name_outfit')
												}, function(data3, menu3)
													menu3.close()
												
													TriggerEvent('skinchanger:getSkin', function(skin)
														TriggerServerEvent('esx_clotheshop:saveOutfit', data3.value, skin)
														ESX.ShowNotification(_U('saved_outfit'))
													end)
												end, function(data3, menu3)
													menu3.close()
												end)
											end
										end)
									end
								end)
							
							else
								ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
									TriggerEvent('skinchanger:loadSkin', skin)
								end)
							
								ESX.ShowNotification(_U('not_enough_money'))
							end
						end)
					elseif data.current.value == 'no' then
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
						end)
					end
				
					currentAction     = 'shop_menu'
					currentActionMsg  = _U('press_menu')
					currentActionData = {}
				end, function(data, menu)
					menu.close()
				
					currentAction     = 'shop_menu'
					currentActionMsg  = _U('press_menu')
					currentActionData = {}
				end)
			
			end, function(data, menu)
				menu.close()
			
				currentAction     = 'shop_menu'
				currentActionMsg  = _U('press_menu')
				currentActionData = {}
			end, {
				'tshirt_1', 'tshirt_2',
				'torso_1', 'torso_2',
				'decals_1', 'decals_2',
				'arms',
				'pants_1', 'pants_2',
				'shoes_1', 'shoes_2',
				'chain_1', 'chain_2',
				'helmet_1', 'helmet_2',
				'glasses_1', 'glasses_2'
			})
		end
		if data.current.value == 'player_dressing' then
		
			ESX.TriggerServerCallback('esx_eden_clotheshop:getPlayerDressing', function(dressing)
				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {label = dressing[i], value = i})
				end

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'player_dressing',
				{
					css = 'vestiaire',
					title    = "Liste des tenues",
					align    = 'top-left',
					elements = elements,
				},
				function(data, menu)

				TriggerEvent('skinchanger:getSkin', function(skin)

					ESX.TriggerServerCallback('esx_eden_clotheshop:getPlayerOutfit', function(clothes)

						TriggerEvent('skinchanger:loadClothes', skin, clothes)
						TriggerEvent('esx_skin:setLastSkin', skin)

						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('esx_skin:save', skin)
						end)

						ESX.ShowNotification(_U('loaded_outfit'))
						HasLoadCloth = true

					end, data.current.value)

				end)

			end,
			function(data, menu)
			menu.close()
				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_menu')
				CurrentActionData = {}
			end
			)
		end)
	end

	if data.current.value == 'suppr_cloth' then
		ESX.TriggerServerCallback('esx_eden_clotheshop:getPlayerDressing', function(dressing)
			local elements = {}

			for i=1, #dressing, 1 do
				table.insert(elements, {label = dressing[i], value = i})
			end
			
			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'supprime_cloth',
				{
					css = 'vestiaire',
					title    = "Supprimer une tenue",
					align    = 'top-left',
					elements = elements,
				},
				function(data, menu)
					menu.close()
					TriggerServerEvent('esx_eden_clotheshop:deleteOutfit', data.current.value)
					ESX.ShowNotification(_U('supprimed_cloth'))
				end,
				function(data, menu)
				menu.close()
					CurrentAction     = 'shop_menu'
					CurrentActionMsg  = _U('press_menu')
					CurrentActionData = {}
				end
			)
			end)
		end

		end,
		function(data, menu)
			menu.close()

			CurrentAction     = 'room_menu'
			CurrentActionMsg  = _U('press_menu')
			CurrentActionData = {}
		end
		)
	--end
end

AddEventHandler('esx_clotheshop:hasEnteredMarker', function(zone)
	currentAction     = 'shop_menu'
	currentActionMsg  = _U('press_menu')
	currentActionData = {}
end)

AddEventHandler('esx_clotheshop:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	currentAction = nil

	if not hasPaid then
		TriggerEvent('esx_skin:getLastSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)
	end
end)

-- Create Blips
Citizen.CreateThread(function()
	for k,v in ipairs(Config.Shops) do
		local blip = AddBlipForCoord(v)

		SetBlipSprite (blip, 366)
		SetBlipColour (blip, 84)
		SetBlipDisplay(blip, 2)
		SetBlipScale(blip, 0.85)
		SetBlipCategory(blip, 10)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName("~g~Shop de vêtements")
		EndTextCommandSetBlipName(blip)
	end
end)

-- Enter / Exit marker events & draw markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords, isInMarker, currentZone, letSleep = GetEntityCoords(PlayerPedId()), false, nil, true

		for k,v in pairs(Config.Shops) do
			local distance = #(playerCoords - v)

			if distance < Config.DrawDistance then
				letSleep = false
				DrawMarker(20, v+1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 221, 225, 255, true, true, 2, false, nil, nil, false)

				if distance < Config.MarkerSize.x then
					isInMarker, currentZone = true, k
				end
			end
		end

		if (isInMarker and not hasAlreadyEnteredMarker) or (isInMarker and lastZone ~= currentZone) then
			hasAlreadyEnteredMarker, lastZone = true, currentZone
			TriggerEvent('esx_clotheshop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_clotheshop:hasExitedMarker', lastZone)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if currentAction then
			ESX.ShowHelpNotification(currentActionMsg)

			if IsControlJustReleased(0, 38) then
				if currentAction == 'shop_menu' then
					OpenShopMenu()
				end

				currentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)
