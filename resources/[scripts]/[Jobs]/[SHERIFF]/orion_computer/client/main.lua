--------------------------------------------------[ KEYS ]--------------------------------------------------
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
--------------------------------------------------[ KEYS ]--------------------------------------------------
local redbookShow = false 
local PlayerData = {}
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	--radar()
	--photo()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job

end)

local texte = {coords = vector3(-449.41, 6012.07, 31.71)}
local texteSecondaire = {coords = vector3(1853.17, 3690.02, 34.26)}

Citizen.CreateThread(function ()
	while true do 
		Citizen.Wait(1)

		-- BCSO
		if PlayerData.job ~= nil and PlayerData.job.name == 'sheriff' then

			-- POSTE PRINCIPAL
			if(GetDistanceBetweenCoords(texte.coords, GetEntityCoords(GetPlayerPed(-1)), true) < 10) then 
				DrawMarker(20,texte.coords,0,0,0,0,0,43.0,0.5,0.5,0.5,3,252,53,200,1,0,0,0)
			end
			if(GetDistanceBetweenCoords(texte.coords, GetEntityCoords(GetPlayerPed(-1)), true) < 2) then 
				--DrawMarker(20,texte.coords,0,0,0,0,0,0,2.001,2.0001,0.5001,255,255,255,200,0,0,0,0)
				ESX.Game.Utils.DrawText3D(texte.coords, "~b~[F3] ~g~Pour ouvrir l'ordinateur de service.", 1.0)
				if IsControlJustPressed(1, Keys["F3"]) then
					if not redbookShow then
						openGui()
					else 
						closeGui()
					end
				end
			end

			-- POSTE SECONDAIRE

			if(GetDistanceBetweenCoords(texteSecondaire.coords, GetEntityCoords(GetPlayerPed(-1)), true) < 10) then 
				DrawMarker(20,texteSecondaire.coords,0,0,0,0,0,299.0,0.5,0.5,0.5,3,252,53,200,1,0,0,0)
			end
			if(GetDistanceBetweenCoords(texteSecondaire.coords, GetEntityCoords(GetPlayerPed(-1)), true) < 2) then 
				--DrawMarker(20,texte.coords,0,0,0,0,0,0,2.001,2.0001,0.5001,255,255,255,200,0,0,0,0)
				ESX.Game.Utils.DrawText3D(texteSecondaire.coords, "~b~[F3] ~g~Pour ouvrir l'ordinateur de service.", 1.0)
				if IsControlJustPressed(1, Keys["F3"]) then
					if not redbookShow then
						openGui()
					else 
						closeGui()
					end
				end
			end
		end
		
		if redbookShow then
			DisableControlAction(0, 1, redbookShow) 
			DisableControlAction(0, 2, redbookShow) 
			DisableControlAction(0, 142, redbookShow) 
			DisableControlAction(0, 106, redbookShow) 
		end

		if IsControlJustPressed(1, Keys["F3"]) and IsPedInAnyPoliceVehicle(GetPlayerPed(-1)) then
			if not redbookShow then
				openGui()
			else 
				closeGui()
			end
		end
		
	end
end)

function openGui()
	SetNuiFocus(true, true)
	SendNUIMessage({openRedPad = true})
	redbookShow = true
end

function closeGui()
	SetNuiFocus(false)
	SendNUIMessage({openRedPad = false})
	redbookShow = false 
end

RegisterNUICallback('close', function(data, cb)
	closeGui()
	cb('ok')
end)