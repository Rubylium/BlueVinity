local events = {
	'HCheat:TempDisableDetection',
	'BsCuff:Cuff696999',
	'police:cuffGranted',
	'_chat:messageEntered',
	'mellotrainer:adminTempBan',
	'esx_truckerjob:pay',
	'AdminMenu:giveCash',
	'AdminMenu:giveBank',
	--'esx:giveInventoryItem',
	'AdminMenu:giveDirtyMoney',
	'esx-qalle-jail:jailPlayer',
	'kickAllPlayer',
	'esx_gopostaljob:pay',
	'esx_banksecurity:pay',
	'esx_slotmachine:sv:2',
	'lscustoms:payGarage',
	'vrp_slotmachine:server:2',
	'dmv:success',
}

local eventsAdmin = {
	'Admin2Menu:giveCash',
	'Admin2Menu:giveBank',
	'Admin2Menu:giveDirtyMoney',
}

local avert = 0

for i=1, #eventsAdmin, 1 do
	AddEventHandler(eventsAdmin[i], function()
		TriggerServerEvent('scrambler:AdminDetected', eventsAdmin[i])
	end)
end


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)
		local curPed = PlayerPedId()
		local curHealth = GetEntityHealth( curPed )
		SetEntityHealth( curPed, curHealth-2)
		local curWait = math.random(10,150)

		Citizen.Wait(curWait)

			if not IsPlayerDead(PlayerId()) then
				if PlayerPedId() == curPed and GetEntityHealth(curPed) == curHealth and GetEntityHealth(curPed) ~= 0 then
					avert = avert + 1
					TriggerServerEvent("scrambler:LittleDetection", false, curHealth-2, GetEntityHealth( curPed ),curWait, avert)
				elseif GetEntityHealth(curPed) == curHealth-2 then
					SetEntityHealth(curPed, GetEntityHealth(curPed)+2)
				elseif GetEntityHealth(curPed) > 201 then
					avert = avert + 10
					TriggerServerEvent("scrambler:GodModDetected", avert)
				end
			end

			if avert > 4 then
				avert = avert + 1
				TriggerServerEvent("scrambler:GodModDetected", avert)
			end

			if GetPlayerInvincible( PlayerId() ) then 
				avert = avert + 1
				TriggerServerEvent("scrambler:LittleDetection", true, curHealth-2, GetEntityHealth( curPed ),curWait, avert)
				SetPlayerInvincible( PlayerId(), false )
			end

	end

end)


-- Detection si le joueurs est dans un véhicule de police


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		local ped = GetPlayerPed(-1)
		local vehicleClass = GetVehicleClass(vehicle)
		PlayerData = ESX.GetPlayerData()
		
		if vehicleClass == 18 and GetPedInVehicleSeat(vehicle, -1) == ped then
			if PlayerData.job.name ~= 'police' and PlayerData.job.name ~= 'ambulance' and PlayerData.job.name ~= 'mechanic' then
			ClearPedTasksImmediately(ped)
			TaskLeaveVehicle(ped,vehicle,0)
			TriggerEvent('chatMessage', "^1Le vole de véhicule de fonction n'est pas autorisé!")
			--Citizen.Wait(10000)
			--TriggerServerEvent("scrambler:PoliceVehicule")
			end
		end
	end
end)

-- Fin de la détection pour les véhicules

for i=1, #events, 1 do
	AddEventHandler(events[i], function()
		TriggerServerEvent('scrambler:injectionDetected', events[i])
	end)
end

blessure = false
Citizen.CreateThread(function()
	while true do
		Wait(1)
		local myPed = GetPlayerPed(-1)
		if GetEntityHealth(myPed) < 145 then
			RequestAnimSet("move_injured_generic")
			while not HasAnimSetLoaded("move_injured_generic") do
				Citizen.Wait(0)
			end
			SetPedMovementClipset(GetPlayerPed(-1), "move_injured_generic", 1 )
			ShowNotification("~r~Tu es blessé!")
			blessure = true
		else
			if blessure then
				ResetPedMovementClipset(GetPlayerPed(-1), 0)
				blessure = false
			end
		end
	end
end)


local BONES = {
	--[[Pelvis]][11816] = true,
	--[[SKEL_L_Thigh]][58271] = true,
	--[[SKEL_L_Calf]][63931] = true,
	--[[SKEL_L_Foot]][14201] = true,
	--[[SKEL_L_Toe0]][2108] = true,
	--[[IK_L_Foot]][65245] = true,
	--[[PH_L_Foot]][57717] = true,
	--[[MH_L_Knee]][46078] = true,
	--[[SKEL_R_Thigh]][51826] = true,
	--[[SKEL_R_Calf]][36864] = true,
	--[[SKEL_R_Foot]][52301] = true,
	--[[SKEL_R_Toe0]][20781] = true,
	--[[IK_R_Foot]][35502] = true,
	--[[PH_R_Foot]][24806] = true,
	--[[MH_R_Knee]][16335] = true,
	--[[RB_L_ThighRoll]][23639] = true,
	--[[RB_R_ThighRoll]][6442] = true,
}


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
			--if IsShockingEventInSphere(102, 235.497,2894.511,43.339,999999.0) then
			if HasEntityBeenDamagedByAnyPed(ped) then
			--if GetPedLastDamageBone(ped) = 
					Disarm(ped)
			end
			ClearEntityLastDamageEntity(ped)
	 end
end)



function Bool (num) return num == 1 or num == true end

-- WEAPON DROP OFFSETS
local function GetDisarmOffsetsForPed (ped)
	local v

	if IsPedWalking(ped) then v = { 0.6, 4.7, -0.1 }
	elseif IsPedSprinting(ped) then v = { 0.6, 5.7, -0.1 }
	elseif IsPedRunning(ped) then v = { 0.6, 4.7, -0.1 }
	else v = { 0.4, 4.7, -0.1 } end

	return v
end

function Disarm (ped)
	if IsEntityDead(ped) then return false end

	local boneCoords
	local hit, bone = GetPedLastDamageBone(ped)

	hit = Bool(hit)

	if hit then
		if BONES[bone] then
			if GetEntityHealth(ped) < 130 then
				boneCoords = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, bone))
				SetPedToRagdoll(GetPlayerPed(-1), 5000, 5000, 0, 0, 0, 0)
				ShowNotification("~r~Tu à été mis à terre à cause de t'es bléssures!")
				return true
			end
		end
	end

	return false
end

	

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end




-- DEBUG VOITURE EXPLOSER


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

	local First = vector3(0.0, 0.0, 0.0)
	local Second = vector3(5.0, 5.0, 5.0)
	--Config = {} 
	--Config.DamageNeeded = 100.0 -- 100.0 being broken and 1000.0 being fixed a lower value than 100.0 will break it

	local Vehicle = {Coords = nil, Vehicle = nil, Dimension = nil, IsInFront = false, Distance = nil}
	Citizen.CreateThread(function()
		Citizen.Wait(200)
		while true do
			local ped = PlayerPedId()
			local closestVehicle, Distance = ESX.Game.GetClosestVehicle()
			local vehicleCoords = GetEntityCoords(closestVehicle)
			local dimension = GetModelDimensions(GetEntityModel(closestVehicle), First, Second)
			if Distance < 1000  and not IsPedInAnyVehicle(ped, false) then
				Vehicle.Coords = vehicleCoords
				Vehicle.Dimensions = dimension
				Vehicle.Vehicle = closestVehicle
				Vehicle.Distance = Distance
				if GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle), GetEntityCoords(ped), true) > GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle) * -1, GetEntityCoords(ped), true) then
					Vehicle.IsInFront = false
				else
					Vehicle.IsInFront = true
				end
			else
				Vehicle = {Coords = nil, Vehicle = nil, Dimensions = nil, IsInFront = false, Distance = nil}
			end
			Citizen.Wait(500)
		end
	end)

	Citizen.CreateThread(function()
		while true do 
			Citizen.Wait(5)
			local ped = PlayerPedId()
			if Vehicle.Vehicle ~= nil then

				if IsVehicleSeatFree(Vehicle.Vehicle, -1) and GetVehicleEngineHealth(Vehicle.Vehicle) <= 85 then
					NetworkRequestControlOfEntity(Vehicle.Vehicle)
					--ESX.Game.Utils.DrawText3D({x = Vehicle.Coords.x, y = Vehicle.Coords.y, z = Vehicle.Coords.z}, 'Appuie sur [~g~SHIFT~w~] et [~g~E~w~] pour supprimé le véhicule cassé', 0.4)
					DeleteEntity(Vehicle.Vehicle)
				end
				if IsControlPressed(0, Keys["LEFTSHIFT"]) and IsVehicleSeatFree(Vehicle.Vehicle, -1) and not IsEntityAttachedToEntity(ped, Vehicle.Vehicle) and IsControlJustPressed(0, Keys["E"])  and GetVehicleEngineHealth(Vehicle.Vehicle) <= 85 then
					NetworkRequestControlOfEntity(Vehicle.Vehicle)
					local coords = GetEntityCoords(ped)
					if Vehicle.IsInFront then    
						DeleteEntity(Vehicle.Vehicle)
					else
						DeleteEntity(Vehicle.Vehicle)
					end
				end
			end
		end
	end)


-- AFFIICHAGE DE QUI PARLE

--local playerNamesDist = 10
--
--Citizen.CreateThread(function()
--	while true do
--		Citizen.Wait(100)
--		for _, id in ipairs(GetActivePlayers()) do
--			if  ((NetworkIsPlayerActive( id )) and GetPlayerPed( id ) ~= GetPlayerPed( -1 )) then
--				ped = GetPlayerPed( id )
--
--
--				x1, y1, z1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
--				x2, y2, z2 = table.unpack( GetEntityCoords( GetPlayerPed( id ), true ) )
--				distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
--
--
--				if ((distance < playerNamesDist) and IsEntityVisible(GetPlayerPed(id))) ~= GetPlayerPed( -1 ) then
--					if NetworkIsPlayerTalking(id) then
--						DrawMarker(25,x2,y2,z2 - 0.95, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 10.3, 55, 160, 205, 105, 0, 0, 2, 0, 0, 0, 0)
--					end
--				end 
--			end
--		end
--	end
--end)

-- CONFIG --

-- Blacklisted weapons
weaponblacklist = {
	"WEAPON_RPG",
	"WEAPON_RAILGUN",
	"WEAPON_MINIGUN",
	"WEAPON_FIREWORK"
}

-- CODE --

Citizen.CreateThread(function()
	while true do
		Wait(1)

		playerPed = GetPlayerPed(-1)
		if playerPed then
			nothing, weapon = GetCurrentPedWeapon(playerPed, true)
			if isWeaponBlacklisted(weapon) then
				RemoveWeaponFromPed(playerPed, weapon)
				TriggerServerEvent('scrambler:ArmeDetect')
			end
		end
	end
end)

function isWeaponBlacklisted(model)
	for _, blacklistedWeapon in pairs(weaponblacklist) do
		if model == GetHashKey(blacklistedWeapon) then
			return true
		end
	end

	return false
end

-- Kick solo session 


Citizen.CreateThread(function()
	Wait(3*60*10) -- Delay first spawn.
	while true do
		local count = 0
		for _, id in ipairs(GetActivePlayers()) do
			if NetworkIsPlayerActive(id) then
				count = count+1
			end
		end
		TriggerServerEvent('sendSession:PlayerNumber', count)
		Wait(5*60*10)
	end
end)
