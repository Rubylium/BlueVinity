
ESX = nil

PlayerData = {}


-- Coordonée pour le point de début de mission

local PosX =
local PosY = 
local PosZ =  

Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(10)
		TriggerEvent("esx:getSharedObject", function(response)
			ESX = response
		end)
	end
	if ESX.IsPlayerLoaded() then
		PlayerData = ESX.GetPlayerData()
	end
end)


-- Chargement des points quand le joueur spawn
RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	PlayerData = response
	LoadSellPlace()
	SpawnVehicles()
end)

-- Affichage du points sur la map

function LoadSellPlace()
	Citizen.CreateThread(function()
		while true do

			local sleepThread = 500
			local ped = PlayerPedId()
			local pedCoords = GetEntityCoords(ped)
			local dstCheck = GetDistanceBetweenCoords(pedCoords, PosX, PosY, PosZ, true)

			if dstCheck <= 20.0 then
				sleepThread = 5

				if dstCheck <= 4.2 then
					ESX.Game.Utils.DrawText3D(SellPos, "[E] Ouvrir le menu de vente", 1.0)
					if IsControlJustPressed(0, 38) then
						OpenSellMenu(GetVehiclePedIsUsing(ped))
					end
				end
			end
		

			Citizen.Wait(sleepThread)
		end
	end)

end