--       Licensed under: AGPLv3        --
--  GNU AFFERO GENERAL PUBLIC LICENSE  --
--     Version 3, 19 November 2007     --

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if NetworkIsSessionStarted() then
			TriggerServerEvent('es:firstJoinProper')
			TriggerEvent('es:allowedToSpawn')
			return
		end
	end
end)

local loaded = false
local oldPos
local pvpEnabled = true
local count = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local pos = GetEntityCoords(PlayerPedId())
		count = count + 1

		if(oldPos ~= pos)then
			TriggerServerEvent('es:updatePositions', pos.x, pos.y, pos.z)
			
			oldPos = pos
		end

		if count >= 240 then
			ShowNotification('✅ Synchronisation effectuée.')
			--TriggerServerEvent('SavellPlayer')
			count = 0
		end
	end
end)

function ShowNotification(text)
	SetNotificationBackgroundColor(184)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end



AddEventHandler('playerSpawned', function(spawn)
	SetCanAttackFriendly(PlayerPedId(), true, false)
	NetworkSetFriendlyFireOption(true)
end)

AddEventHandler('playerDropped', function(reason)
	local pos = GetEntityCoords(PlayerPedId())
	TriggerServerEvent('es:updatePositions', pos.x, pos.y, pos.z)
end)

local myDecorators = {}

RegisterNetEvent("es:setPlayerDecorator")
AddEventHandler("es:setPlayerDecorator", function(key, value, doNow)
	myDecorators[key] = value
	DecorRegister(key, 3)

	if(doNow)then
		DecorSetInt(PlayerPedId(), key, value)
	end
end)

local enableNative = {}

local firstSpawn = true
AddEventHandler("playerSpawned", function()
	for k,v in pairs(myDecorators)do
		DecorSetInt(PlayerPedId(), k, v)
	end

	TriggerServerEvent('playerSpawn')
end)

RegisterNetEvent("es:enablePvp")
AddEventHandler("es:enablePvp", function()
	pvpEnabled = true
end)