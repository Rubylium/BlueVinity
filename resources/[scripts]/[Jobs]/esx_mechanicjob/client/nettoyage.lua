ESX = nil
local PlayerData                = {}

local nettoyage = {coords = vector3(-210.83, -1313.82, 31.08)}
--local nettoyagePublique = {coords = vector3(21.09, -1391.97, 29.8)}
local nettoyagePublique = {coords = vector3(47.68, -1391.991, 29.4)}

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



-- Zone de mise nettoyage

Citizen.CreateThread(function()
     while true do
          while ESX == nil do
               Citizen.Wait(10)
          end
		local sleepThread = 1000
		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)
          local dstCheck = GetDistanceBetweenCoords(pedCoords, nettoyage.coords, true)
          local dstCheckPublic = GetDistanceBetweenCoords(pedCoords, nettoyagePublique.coords, true)
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
			if dstCheck <= 2.5 then
				sleepThread = 5
				ESX.Game.Utils.DrawText3D(nettoyage.coords, "~b~[E] ~w~Réparation global du véhicules\n~b~Activité d'entreprise", 1.0)
				if IsControlJustPressed(0, 38) then
					NettoyageFunction()
				end
			end
          end
          if dstCheckPublic <= 30 then
               sleepThread = 5
               DrawMarker(20, nettoyagePublique.coords.x, nettoyagePublique.coords.y, nettoyagePublique.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 3, 252, 48, 100, false, true, 2, false, nil, nil, false)
          end
          if dstCheckPublic <= 2.5 then
               sleepThread = 5
               ESX.Game.Utils.DrawText3D(nettoyagePublique.coords, "~b~[E] ~w~Nettoyage de véhicule\n~b~Activité civil", 1.0)
               if IsControlJustPressed(0, 38) then
                    NettoyageFunctionPublic()
               end
          end
		Citizen.Wait(sleepThread)
	end
end)


function NettoyageFunction()
	local ped = PlayerPedId()
     local vehicle = GetVehiclePedIsIn( ped, false )
     if IsPedInAnyVehicle(ped, false) then
          if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
               ESX.ShowAdvancedNotification("Mécano", "~b~Réparation et néttoyage", "Réparation et néttoyage du véhicule en cours...", "CHAR_LS_CUSTOMS", 8)
-- Cam
               local camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
               SetCamCoord(camera, -208.02, -1311.53, 32.99)
               PointCamAtEntity(camera, ped, 0, 0, 0, 1)
               SetCamNearDof(camera, 10)
               RenderScriptCams(1, 1, 6500, 1, 1)
               SetCamShakeAmplitude(camera, 13.0)
               -- porte
               SetVehicleDoorOpen(vehicle, 0, false, false)
               SetVehicleDoorOpen(vehicle, 1, false, false)
               SetVehicleDoorOpen(vehicle, 2, false, false)
               SetVehicleDoorOpen(vehicle, 3, false, false)
               SetVehicleDoorOpen(vehicle, 4, false, false)
               SetVehicleDoorOpen(vehicle, 5, false, false)
               SetVehicleDoorOpen(vehicle, 6, false, false)
               SetVehicleDoorOpen(vehicle, 7, false, false)
               Wait(8500)
               RenderScriptCams(0, 1, 3500, 1, 1)
               Wait(3501)
               SetCamCoord(camera, -212.34, -1312.99, 30.99)
               RenderScriptCams(1, 1, 5500, 1, 1)
               Wait(6600)
               RenderScriptCams(0, 1, 3500, 1, 1)
               Wait(3501)
               SetCamCoord(camera, -210.41, -1315.09, 36.99)
               RenderScriptCams(1, 1, 7500, 1, 1)
               Wait(8500)
-- Fin cam
               RenderScriptCams(0, 1, 5000, 1, 1)
               DestroyCam(camera, true)
               ESX.ShowAdvancedNotification("Mécano", "~b~Réparation et néttoyage", "Terminé", "CHAR_LS_CUSTOMS", 8)
               -- porte
               SetVehicleDoorShut(vehicle, 0, false)
               SetVehicleDoorShut(vehicle, 1, false)
               SetVehicleDoorShut(vehicle, 2, false)
               SetVehicleDoorShut(vehicle, 3, false)
               SetVehicleDoorShut(vehicle, 4, false)
               SetVehicleDoorShut(vehicle, 5, false)
               SetVehicleDoorShut(vehicle, 6, false)
               SetVehicleDoorShut(vehicle, 7, false)
               -- clean et fix 
               SetVehicleDirtLevel(vehicle, 1.0)
               SetVehicleFixed(vehicle)
          end
     else
          ESX.ShowAdvancedNotification("Mécano", "~b~Déstruction du véhicule", "Tu doit etre en véhicule pour faire ça.", "CHAR_LS_CUSTOMS", 8)
     end
end

function NettoyageFunctionPublic()
	local ped = PlayerPedId()
     local vehicle = GetVehiclePedIsIn( ped, false )
     if IsPedInAnyVehicle(ped, false) then
          TaskVehicleDriveToCoord(ped, vehicle, 21.09, -1391.97, 29.8, 3.0, 5.0, hash, 16777216, 1.0, true)
          Citizen.Wait(1000)
          local stopped = IsVehicleStopped(vehicle)
          while stopped == false do
               stopped = IsVehicleStopped(vehicle)
               Citizen.Wait(50)
          end
          ESX.ShowAdvancedNotification("Station Lavage", "~b~Action station de lavage", "Le néttoyage à commencer...", "CHAR_LS_CUSTOMS", 8)
-- Cam
          local camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
          SetCamCoord(camera, 15.25, -1392.20, 31.99)
          PointCamAtEntity(camera, ped, 0, 0, 0, 1)
          SetCamNearDof(camera, 10)
          RenderScriptCams(1, 1, 6500, 1, 1)
          SetCamShakeAmplitude(camera, 13.0)
          -- porte
          SetVehicleDoorOpen(vehicle, 0, false, false)
          SetVehicleDoorOpen(vehicle, 1, false, false)
          SetVehicleDoorOpen(vehicle, 2, false, false)
          SetVehicleDoorOpen(vehicle, 3, false, false)
          SetVehicleDoorOpen(vehicle, 4, false, false)
          SetVehicleDoorOpen(vehicle, 5, false, false)
          SetVehicleDoorOpen(vehicle, 6, false, false)
          SetVehicleDoorOpen(vehicle, 7, false, false)
          SetVehicleEngineOn(vehicle, false, false, true)
          Wait(8500)
          DoScreenFadeOut(1500)
          Wait(1300)
          RenderScriptCams(0, 1, 500, 1, 1)
          Wait(500)
          DoScreenFadeIn(4300)
          SetCamCoord(camera, 17.97, -1394.04, 28.73)
          RenderScriptCams(1, 1, 4500, 1, 1)
          Wait(6600)
          DoScreenFadeOut(1500)
          Wait(1500)
          RenderScriptCams(0, 1, 500, 1, 1)
          Wait(500)
          DoScreenFadeIn(1500)
          SetCamCoord(camera, 24.46, -1389.37, 32.86)
          RenderScriptCams(1, 1, 7500, 1, 1)
          Wait(8500)
-- Fin ca
          RenderScriptCams(0, 1, 5000, 1, 1)
          DestroyCam(camera, true)
          ESX.ShowAdvancedNotification("Station Lavage", "~b~Action station de lavage", "Terminé", "CHAR_LS_CUSTOMS", 8)
          -- porte
          SetVehicleDoorShut(vehicle, 0, false)
          SetVehicleDoorShut(vehicle, 1, false)
          SetVehicleDoorShut(vehicle, 2, false)
          SetVehicleDoorShut(vehicle, 3, false)
          SetVehicleDoorShut(vehicle, 4, false)
          SetVehicleDoorShut(vehicle, 5, false)
          SetVehicleDoorShut(vehicle, 6, false)
          SetVehicleDoorShut(vehicle, 7, false)
          SetVehicleEngineOn(vehicle, true, false, true)
          local hash = GetHashKey(vehicle)
          TaskVehicleDriveToCoord(ped, vehicle, -8.309, -1392.28, 29.30, 3.0, 5.0, hash, 16777216, 1.0, true)
          --TaskVehiclePark(ped, vehicle, -8.77, -1385.52, 29.35, 0.2, 1, 20.0, true)
          -- clean
          SetVehicleDirtLevel(vehicle, 1.0)
     else
          ESX.ShowAdvancedNotification("Station Lavage", "~b~Action station de lavage", "Tu doit etre en véhicule pour faire ça.", "CHAR_LS_CUSTOMS", 8)
     end
end