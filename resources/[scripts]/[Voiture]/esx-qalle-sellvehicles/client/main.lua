ESX = nil

PlayerData = {}
local SpamDeFDP = false
local type = {}

Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(10)

		TriggerEvent("esx:getSharedObject", function(response)
			ESX = response
		end)
	end

	if ESX.IsPlayerLoaded() then
		PlayerData = ESX.GetPlayerData()
		RemoveVehicles()
		Citizen.Wait(500)
		LoadSellPlace()
		SpawnVehicles()
	end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	PlayerData = response
	LoadSellPlace()
	SpawnVehicles()
end)

RegisterNetEvent("esx-qalle-sellvehicles:refreshVehicles")
AddEventHandler("esx-qalle-sellvehicles:refreshVehicles", function()
	RemoveVehicles()
	Citizen.Wait(1000)
	SpawnVehicles()
end)

RegisterNetEvent("ActualisationVeh")
AddEventHandler("ActualisationVeh", function()
	RemoveVehicles()
	Citizen.Wait(100)
	RemoveVehicles()
	Citizen.Wait(100)
	RemoveVehicles()
	Citizen.Wait(100)
	SpawnVehicles()
end)


RegisterNetEvent("RemoveAllVeh")
AddEventHandler("RemoveAllVeh", function()
	RemoveVehicles()
end)

RegisterNetEvent("SpawnAllVeh")
AddEventHandler("SpawnAllVeh", function()
	SpawnVehicles()
end)

function LoadSellPlace()
	Citizen.CreateThread(function()

		local SellPos = Config.SellPosition

		local Blip = AddBlipForCoord(SellPos["x"], SellPos["y"], SellPos["z"])
		SetBlipSprite (Blip, 269)
		SetBlipDisplay(Blip, 6)
		SetBlipScale  (Blip, 0.8)
		SetBlipColour (Blip, 5)
		SetBlipAsShortRange(Blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Vente véhicule d'occasion")
		EndTextCommandSetBlipName(Blip)

		while true do
			local sleepThread = 500

			local ped = PlayerPedId()
			local pedCoords = GetEntityCoords(ped)

			local dstCheck = GetDistanceBetweenCoords(pedCoords, SellPos["x"], SellPos["y"], SellPos["z"], true)

			if dstCheck <= 20.0 then
				sleepThread = 5

				if dstCheck <= 4.2 then
					ESX.Game.Utils.DrawText3D(SellPos, "[E] Ouvrir le menu de vente", 1.0)
					if IsControlJustPressed(0, 38) then
						if IsPedInAnyVehicle(ped, false) then
							OpenSellMenu(GetVehiclePedIsUsing(ped))
						else
							ESX.ShowNotification("Tu doit être dans le ~g~vehicle")
						end
					end
				end
			end

			for i = 1, #Config.VehiclePositions, 1 do
				if Config.VehiclePositions[i]["entityId"] ~= nil then
					local pedCoords = GetEntityCoords(ped)
					local vehCoords = GetEntityCoords(Config.VehiclePositions[i]["entityId"])

					local dstCheck = GetDistanceBetweenCoords(pedCoords, vehCoords, true)
					local pPed = GetPlayerPed(-1)
					local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(Config.VehiclePositions[i]["entityId"])))
					local vehicleClass = GetVehicleClass(Config.VehiclePositions[i]["entityId"])
					
					if vehicleClass == 0 then
						type = 'Compacts'
					elseif vehicleClass == 1 then
						type = 'Sedans'
					elseif vehicleClass == 2 then
						type = 'SUV'
					elseif vehicleClass == 3 then
						type = 'Coupes'
					elseif vehicleClass == 4 then
						type = 'Muscle'
					elseif vehicleClass == 5 then
						type = 'Sportive Classique'
					elseif vehicleClass == 6 then
						type = 'Sportive'
					elseif vehicleClass == 7 then
						type = 'Super sportive'
					elseif vehicleClass == 8 then
						type = 'Moto'
					elseif vehicleClass == 9 then
						type = 'Offroad'
					elseif vehicleClass == 10 then
						type = 'Industrial'
					elseif vehicleClass == 11 then
						type = 'Utilitaire'
					elseif vehicleClass == 12 then
						type = 'Vans'
					elseif vehicleClass == 13 then
						type = 'Vélo'
					else
						type = 'Inconnu'
					end

					if dstCheck <= 2.5 then
						sleepThread = 5

						ESX.Game.Utils.DrawText3D(vehCoords, "~b~[E] ~w~Pour acheter.\nPrix: ~g~" .. Config.VehiclePositions[i]["price"] .. "$ \n~w~Modèle: ~g~"..VehName.."\n~w~Type: ~g~"..type.."", 0.8)

						if IsControlJustPressed(0, 38) then
							ESX.TriggerServerCallback('RubyMenu:getUsergroup', function(group)
								playergroup = group
								if playergroup == 'superadmin' or playergroup == 'owner' then
									if IsPedInVehicle(ped, Config.VehiclePositions[i]["entityId"], false) then
										OpenSellMenuStaff(Config.VehiclePositions[i]["entityId"], Config.VehiclePositions[i]["price"], true, Config.VehiclePositions[i]["owner"])
										print(Config.VehiclePositions[i]["vehicleProps"])
									else
										ESX.ShowNotification("Tu doit être dans le ~g~vehicule~s~!")
									end
								else
									if IsPedInVehicle(ped, Config.VehiclePositions[i]["entityId"], false) then
										OpenSellMenu(Config.VehiclePositions[i]["entityId"], Config.VehiclePositions[i]["price"], true, Config.VehiclePositions[i]["owner"])
									else
										ESX.ShowNotification("Tu doit être dans le ~g~vehicule~s~!")
									end
								end
							end)
						end
					end
				end
			end
			Citizen.Wait(sleepThread)
		end
	end)
end


function OpenSellMenu(veh, price, buyVehicle, owner)
	local elements = {}

	if not buyVehicle then
		if price ~= nil then
			table.insert(elements, { ["label"] = "Changer le prix - " .. price .. "$", ["value"] = "price" })
			table.insert(elements, { ["label"] = "Mettre le véhicule en vente", ["value"] = "sell" })
		else
			table.insert(elements, { ["label"] = "Mettre un prix : ", ["value"] = "price" })
		end
	else
		table.insert(elements, { ["label"] = "Acheter pour " .. price .. "$", ["value"] = "buy" })

		if owner then
			table.insert(elements, { ["label"] = "Reprendre le véhicule", ["value"] = "remove" })
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sell_veh',
		{
			title    = "Vehicle Menu",
			align    = 'top-right',
			elements = elements
		},
	function(data, menu)
		local action = data.current.value

		if action == "price" then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'sell_veh_price',
				{
					title = "Vehicle Price"
				},
			function(data2, menu2)

				local vehPrice = tonumber(data2.value)

				menu2.close()
				menu.close()

				OpenSellMenu(veh, vehPrice)
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif action == "sell" then
			local vehProps = ESX.Game.GetVehicleProperties(veh)

			ESX.TriggerServerCallback("esx-qalle-sellvehicles:isVehicleValid", function(valid)

				if valid then
					if SpamDeFDP == false then
						local pPed = GetPlayerPed(-1)
						local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(pPed))))
						local vehicle2 = GetVehiclePedIsIn(GetPlayerPed(-1), false)
						local vehicleClass = GetVehicleClass(vehicle2)
						if vehicleClass == 0 then
							type = 'Compacts'
						elseif vehicleClass == 1 then
							type = 'Sedans'
						elseif vehicleClass == 2 then
							type = 'SUV'
						elseif vehicleClass == 3 then
							type = 'Coupes'
						elseif vehicleClass == 4 then
							type = 'Muscle'
						elseif vehicleClass == 5 then
							type = 'Sportive Classique'
						elseif vehicleClass == 6 then
							type = 'Sportive'
						elseif vehicleClass == 7 then
							type = 'Super sportive'
						elseif vehicleClass == 8 then
							type = 'Moto'
						elseif vehicleClass == 9 then
							type = 'Offroad'
						elseif vehicleClass == 10 then
							type = 'Industrial'
						elseif vehicleClass == 11 then
							type = 'Utilitaire'
						elseif vehicleClass == 12 then
							type = 'Vans'
						elseif vehicleClass == 13 then
							type = 'Vélo'
						else
							type = 'Inconnu'
						end
						DeleteVehicle(veh)
						ESX.ShowNotification("Vous avez mis le véhicule en vente pour " .. price .. "$")
						TriggerServerEvent("AnnounceVenteVehicule", price, VehName, type)
						menu.close()
						SpamDeFDP = true
						attend()
					elseif SpamDeFDP == true then
						ESX.ShowNotification("Ne Spam pas comme un idiot !")
					end
				else
					ESX.ShowNotification("Vous devez ~r~avoir~s~ le ~g~vehicule!~s~ ou trop de véhicule son en vente: " .. #Config.VehiclePositions .. " véhicules en ventes")
				end
	
			end, vehProps, price)
		elseif action == "buy" then
			ESX.TriggerServerCallback("esx-qalle-sellvehicles:buyVehicle", function(isPurchasable, totalMoney)
				if isPurchasable then
					if SpamDeFDP == false then
						local pPed = GetPlayerPed(-1)
						--ocal VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(pPed))))
						DeleteVehicle(veh)
						ESX.ShowNotification("Vous avez ~g~Achetée~s~ le véhicule pour " .. price .. " :-")
						TriggerServerEvent("AnnounceVenteVehiculeAchat", price)
						menu.close()
						SpamDeFDP = true
						attend()
					elseif SpamDeFDP == true then
						ESX.ShowNotification("Ne Spam pas comme un idiot !")
					end
				else
					ESX.ShowNotification("Vous ~r~n'avez pas~s~ assez d'argent, il manque " .. price - totalMoney .. "$")
				end
			end, ESX.Game.GetVehicleProperties(veh), price)
		elseif action == "remove" then
			ESX.TriggerServerCallback("esx-qalle-sellvehicles:buyVehicle", function(isPurchasable, totalMoney)
				if isPurchasable then
					if SpamDeFDP == false then
						DeleteVehicle(veh)
						ESX.ShowNotification("Véhicule ~g~retiré~s~ de la vente")
						menu.close()
						SpamDeFDP = true
						attend()
					elseif SpamDeFDP == true then
						ESX.ShowNotification("Ne Spam pas comme un idiot !")
					end
				end
			end, ESX.Game.GetVehicleProperties(veh), 0)
		end
		
	end, function(data, menu)
		menu.close()
	end)
end


function OpenSellMenuStaff(veh, price, buyVehicle, owner)
	local elements = {}

	if not buyVehicle then
		if price ~= nil then
			table.insert(elements, { ["label"] = "Changer le prix - " .. price .. "$", ["value"] = "price" })
			table.insert(elements, { ["label"] = "Mettre le véhicule en vente", ["value"] = "sell" })
		else
			table.insert(elements, { ["label"] = "Mettre un prix : ", ["value"] = "price" })
		end
	else
		table.insert(elements, { ["label"] = "Acheter pour " .. price .. "$", ["value"] = "buy" })

		table.insert(elements, { ["label"] = "Retirer le véhicule ( STAFF )", ["value"] = "remove" })
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sell_veh',
		{
			title    = "Vehicle Menu",
			align    = 'top-right',
			elements = elements
		},
	function(data, menu)
		local action = data.current.value

		if action == "price" then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'sell_veh_price',
				{
					title = "Vehicle Price"
				},
			function(data2, menu2)

				local vehPrice = tonumber(data2.value)

				menu2.close()
				menu.close()

				OpenSellMenu(veh, vehPrice)
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif action == "sell" then
			local vehProps = ESX.Game.GetVehicleProperties(veh)

			ESX.TriggerServerCallback("esx-qalle-sellvehicles:isVehicleValid", function(valid)

				if valid then
					if SpamDeFDP == false then
						local pPed = GetPlayerPed(-1)
						local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(pPed))))
						DeleteVehicle(veh)
						ESX.ShowNotification("Vous avez mis le véhicule en vente pour " .. price .. "$")
						TriggerServerEvent("AnnounceVenteVehicule", price, VehName)
						menu.close()
						SpamDeFDP = true
						attend()
					elseif SpamDeFDP == true then
						ESX.ShowNotification("Ne Spam pas comme un idiot !")
					end
				else
					ESX.ShowNotification("Vous devez ~r~avoir~s~ le ~g~vehicule!~s~ ou trop de véhicule son en vente: " .. #Config.VehiclePositions .. " véhicules en ventes")
				end
	
			end, vehProps, price)
		elseif action == "buy" then
			ESX.TriggerServerCallback("esx-qalle-sellvehicles:buyVehicle", function(isPurchasable, totalMoney)
				if isPurchasable then
					if SpamDeFDP == false then
						local pPed = GetPlayerPed(-1)
						local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(pPed))))
						DeleteVehicle(veh)
						ESX.ShowNotification("Vous avez ~g~Achetée~s~ le véhicule pour " .. price .. " :-")
						TriggerServerEvent("AnnounceVenteVehiculeAchat", price, VehName)
						menu.close()
						SpamDeFDP = true
						attend()
					elseif SpamDeFDP == true then
						ESX.ShowNotification("Ne Spam pas comme un idiot !")
					end
				else
					ESX.ShowNotification("Vous ~r~n'avez pas~s~ assez d'argent, il manque " .. price - totalMoney .. "$")
				end
			end, ESX.Game.GetVehicleProperties(veh), price)
		elseif action == "remove" then
			ESX.TriggerServerCallback("esx-qalle-sellvehicles:buyVehicleStaff", function(isPurchasable, totalMoney)
				if isPurchasable then
					if SpamDeFDP == false then
						DeleteVehicle(veh)
						ESX.ShowNotification("Véhicule ~g~retiré~s~ de la vente")
						menu.close()
						SpamDeFDP = true
						attend()
					elseif SpamDeFDP == true then
						ESX.ShowNotification("Ne Spam pas comme un idiot !")
					end
				end
			end, ESX.Game.GetVehicleProperties(veh), 0)
		end
		
	end, function(data, menu)
		menu.close()
	end)
end

function attend()
	Citizen.Wait(10000)
	SpamDeFDP = false
end

--function RemoveVehicles()
--	local VehPos = Config.VehiclePositions
--
--	for i = 1, #VehPos, 1 do
--		local veh, distance = ESX.Game.GetClosestVehicle(VehPos[i])
--
--		if DoesEntityExist(veh) and distance <= 1.0 then
--			--DeleteEntity(veh)
--			local entity = veh
--			carModel = GetEntityModel(entity)
--			carName = GetDisplayNameFromVehicleModel(carModel)
--			NetworkRequestControlOfEntity(entity)
--			
--			local timeout = 2000
--			while timeout > 0 and not NetworkHasControlOfEntity(entity) do
--				Wait(100)
--				timeout = timeout - 100
--			end
--		
--			SetEntityAsMissionEntity(entity, true, true)
--		
--			local timeout = 2000
--			while timeout > 0 and not IsEntityAMissionEntity(entity) do
--				Wait(100)
--				timeout = timeout - 100
--			end
--		
--			Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
--			
--			if (DoesEntityExist(entity)) then 
--				DeleteEntity(entity)
--			end 
--		end
--	end
--end

function RemoveVehicles()
	local VehPos = Config.VehiclePositions

	for i = 1, #VehPos, 1 do
		local veh, distance = ESX.Game.GetClosestVehicle(VehPos[i])

		if DoesEntityExist(veh) and distance <= 1.0 then
			DeleteEntity(veh)
		end
	end
end

function SpawnVehicles()
	local VehPos = Config.VehiclePositions

	ESX.TriggerServerCallback("esx-qalle-sellvehicles:retrieveVehicles", function(vehicles)
		for i = 1, #vehicles, 1 do

			local vehicleProps = vehicles[i]["vehProps"]

			LoadModel(vehicleProps["model"])

			VehPos[i]["entityId"] = CreateVehicle(vehicleProps["model"], VehPos[i]["x"], VehPos[i]["y"], VehPos[i]["z"] - 0.975, VehPos[i]["h"], false)
			VehPos[i]["price"] = vehicles[i]["price"]
			VehPos[i]["owner"] = vehicles[i]["owner"]

			ESX.Game.SetVehicleProperties(VehPos[i]["entityId"], vehicleProps)

			FreezeEntityPosition(VehPos[i]["entityId"], true)

			SetEntityAsMissionEntity(VehPos[i]["entityId"], true, true)
			SetModelAsNoLongerNeeded(vehicleProps["model"])
		end
	end)

end

LoadModel = function(model)
	while not HasModelLoaded(model) do
		RequestModel(model)

		Citizen.Wait(1)
	end
end
