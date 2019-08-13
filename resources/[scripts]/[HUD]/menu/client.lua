------------------------------------------------------------------
--                          Variables
------------------------------------------------------------------

local showMenu = false
local showCrosshair = false
local toggleCoffre = 0
local toggleCapot = 0
local toggleLocked = 0
local playing_emote = false

------------------------------------------------------------------
--                          Functions
------------------------------------------------------------------

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function startAnimAction(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(plyPed, lib, anim, 8.0, 1.0, -1, 49, 0, false, false, false)
	end)
end

local function notification(msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(false, false)
end

-- Show crosshair (circle) when player targets entities (vehicle, pedestrian…)
function Crosshair(enable)
	showCrosshair = enable
	SendNUIMessage({
		crosshair = enable
	})
end

-- Toggle focus (Example of Vehcile's menu)
RegisterNUICallback('disablenuifocus', function(data)
	showMenu = data.nuifocus
	SetNuiFocus(data.nuifocus, data.nuifocus)
end)

-- Toggle car trunk (Example of Vehcile's menu)
RegisterNUICallback('togglecoffre', function(data)
	if(toggleCoffre == 0)then
		SetVehicleDoorOpen(data.id, 5, false)
		toggleCoffre = 1
	else
		SetVehicleDoorShut(data.id, 5, false)
		toggleCoffre = 0
	end
end)

-- Toggle car hood (Example of Vehcile's menu)
RegisterNUICallback('togglecapot', function(data)
	if(toggleCapot == 0)then
		SetVehicleDoorOpen(data.id, 4, false)
		toggleCapot = 1
	else
		SetVehicleDoorShut(data.id, 4, false)
		toggleCapot = 0
	end
end)


RegisterNUICallback('reparation', function(data)
	if(reparation == 0)then
		TriggerEvent('iens:repair2')
	else
		TriggerEvent('iens:repair2')
	end
end)

RegisterNUICallback('lock', function(data)
	if(reparation == 0)then
		TriggerEvent('VerouillerLeVehiculeMenu')
	else
		TriggerEvent('VerouillerLeVehiculeMenu')
	end
end)

-- Toggle car lock (Example of Vehcile's menu)
RegisterNUICallback('togglelock', function(data)
	if(toggleLocked == 0)then
		SetVehicleDoorsLocked(data.id, 2)
		TriggerEvent('InteractSound_CL:PlayOnOne', 'lock', 1.0)
		toggleLocked = 1
	else
		SetVehicleDoorsLocked(data.id, 1)
		TriggerEvent('InteractSound_CL:PlayOnOne', 'unlock', 1.0)
		toggleLocked = 0
	end
end)

-- Example of animation (Ped's menu)
RegisterNUICallback('cheer', function(data)
	local plyPed = PlayerPedId()
	if (not IsPedInAnyVehicle(plyPed)) then
		if plyPed then
			if playing_emote == false then
				TaskStartScenarioInPlace(plyPed, 'WORLD_HUMAN_CHEERING', 0, true);
				playing_emote = true
			end
		end
	end
end)


RegisterNUICallback('salue', function(data)
	local plyPed = PlayerPedId()
	if (not IsPedInAnyVehicle(plyPed)) then
		if plyPed then
			if playing_emote == false then
				local lib, anim = 'gestures@m@standing@casual', 'gesture_hello'
				--TaskStartScenarioInPlace(plyPed, 'gesture_hello', 0, true);
				TaskPlayAnim(plyPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
				--playing_emote = true
			end
		end
	end
end)


------------------------------------------------------------------
--                          Citizen
------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local plyPed = PlayerPedId()

		local ent = exports['target']:GetTarget(plyPed, 6.0)
		local entType = GetEntityType(ent)

		if entType == 2 then
			Crosshair(true)

			if IsControlJustReleased(1, 38) then
				showMenu = true
				SetNuiFocus(true, true)
				SendNUIMessage({
					menu = 'vehicle',
					idEntity = ent
				})
			end
		elseif entType == 1 then
			Crosshair(true)

			if IsControlJustReleased(1, 38) then
				showMenu = true
				SetNuiFocus(true, true)
				SendNUIMessage({
				menu = 'user',
				idEntity = ent
			})
			end
		end

		if entType ~= 1 and entType ~= 2 then
			if showCrosshair then
				Crosshair(false)
			end
			if showMenu then
				showMenu = false
				SetNuiFocus(false, false)
				SendNUIMessage({
					menu = false
				})
			end
		end

		-- Stop emotes if user press E
		-- TODO: Stop emotes if user move
		if playing_emote == true then
			if IsControlPressed(1, 38) then
				ClearPedTasks(plyPed)
				playing_emote = false
			end
		end

		Citizen.Wait(0)
	end
end)
