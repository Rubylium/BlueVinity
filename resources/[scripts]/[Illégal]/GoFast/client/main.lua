
ESX = nil

PlayerData = {}


-- Coordonée pour le point de début de mission

local PosX = 471.153
local PosY = -3084.63
local PosZ = 6.07
local DebutMission = {coords = vector3(471.153, -3084.63, 6.07)},

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

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
     PlayerData.job = job
end)

-- Affichage du points sur la map

Citizen.CreateThread(function()
	while true do
		local sleepThread = 500
		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)
		local dstCheck = GetDistanceBetweenCoords(pedCoords, PosX, PosY, PosZ, true)
		if dstCheck <= 20.0 then
			sleepThread = 5
			if dstCheck <= 4.2 then
				ESX.Game.Utils.DrawText3D(DebutMission.coords, "[E] Ouvrir le menu de ~g~GoFast\n~r~Activitée illégal", 1.0)
				if IsControlJustPressed(0, 38) then
					DebutMissionMenu()
				end
			end
		end
		Citizen.Wait(sleepThread)
	end
end)


-- Menu de début de mission 

function DebutMissionMenu()
	local elements = {}

	table.insert(elements, { ["label"] = "Commencer un GoFast", ["value"] = "start" })

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sell_veh',
		{
			title    = "Menu GoFast",
			align    = 'top-right',
			elements = elements
		},
	function(data, menu)
		local action = data.current.value

		if action == "start" then
			print('test')
		end
	end, function(data, menu)
		menu.close()
	end)
end