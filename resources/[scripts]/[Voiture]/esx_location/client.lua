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

ESX          = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local havebike = false
local RendreScoot = false
local model = 0
local antifdp = 0

Citizen.CreateThread(function()

	if not Config.EnableBlips then return end
	
	for _, info in pairs(Config.BlipZones) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 0.5)
		SetBlipColour(info.blip, info.colour)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)
	end
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for k in pairs(Config.MarkerZones) do
			if havebike == false then
				DrawMarker(27, Config.MarkerZones[k].x, Config.MarkerZones[k].y, Config.MarkerZones[k].z, 0, 0, 0, 0, 0, 0, 4.00, 4.00, 4.00, 255, 255, 255, 100, 0, 0, 0, 0)	
			elseif havebike == true then
				DrawMarker(27, Config.MarkerZones[k].x, Config.MarkerZones[k].y, Config.MarkerZones[k].z, 0, 0, 0, 0, 0, 0, 4.00, 4.00, 4.00, 255, 0, 0, 100, 0, 0, 0, 0)
			end
			if model == 1 and havebike == false then
				DrawMarker(27, Config.MarkerZones[k].x, Config.MarkerZones[k].y, Config.MarkerZones[k].z, 0, 0, 0, 0, 0, 0, 4.00, 4.00, 4.00, 255, 0, 0, 100, 0, 0, 0, 0)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn( ped, false )
		local plate = GetVehicleNumberPlateText(vehicle)
		model = IsVehicleModel(vehicle, 'faggio3')
		if model == 1 then
			RendreScoot = true
		else 
			RendreScoot = false
		end
	end
end)

function DelVeh(veh)
	SetEntityAsMissionEntity(Object, 1, 1)
	DeleteEntity(Object)
	SetEntityAsMissionEntity(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1, 1)
	DeleteEntity(GetVehiclePedIsIn(GetPlayerPed(-1), false))
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for k in pairs(Config.MarkerZones) do
			local ped = PlayerPedId()
			local pedcoords = GetEntityCoords(ped, false)
			local distance = Vdist(pedcoords.x, pedcoords.y, pedcoords.z, Config.MarkerZones[k].x, Config.MarkerZones[k].y, Config.MarkerZones[k].z)
			local hash = GetHashKey('faggio3')
			local vehicle = GetVehiclePedIsIn(ped, false)
			local plate = GetVehicleNumberPlateText(vehicle) 
			if distance <= 3 then
				if RendreScoot == true then
					helptext('Appuyer sur E pour vendre un scooteur.')
					if IsControlJustPressed(0, Keys['E']) then
						if antifdp == 0 then
							--TriggerEvent('esx:deleteVehicle')
							DelVeh(vehicle)
							TriggerServerEvent("esx:bike:lowmoneyRendu", 50)
							havebike = false
							antifdp = antifdp + 1
							Citizen.Wait(1000)
							antifdp = antifdp - 1
						elseif antifdp >= 2 then
							print('FDP DETECTER')
							TriggerServerEvent("esx:bike:antifdp")
						end
					end
					break
				end
				if havebike == false then
					helptext('Appuyer sur E pour prendre un scooteur.')
					if IsControlJustPressed(0, Keys['E']) and IsPedOnFoot(ped) then
						OpenBikesMenu()
					end 
				elseif havebike == true then
					if antifdp == 0 then
						helptext(_U('storebike'))
						if IsControlJustPressed(0, Keys['E']) and IsPedInAnyVehicle(ped, false) then 
							--TriggerEvent('esx:deleteVehicle')
							DelVeh(vehicle)
							TriggerServerEvent("esx:bike:lowmoneyRendu", 50)
							if Config.EnableEffects then
								ESX.ShowNotification(_U('bikemessage'))
							else
								TriggerEvent("chatMessage", _U('bikes'), {255,255,0}, _U('bikemessage'))
							end
							havebike = false
							antifdp = antifdp + 1
							Citizen.Wait(1000)
							antifdp = antifdp - 1
						end 	
					elseif antifdp >= 2 then
						print('FDP DETECTER')
						TriggerServerEvent("esx:bike:antifdp")
					end
				end
			elseif distance < 3 then
				ESX.UI.Menu.CloseAll()
            end
        end
    end
end)



function OpenBikesMenu()
	
	local elements = {}
	
	if Config.EnablePrice == false then
		--table.insert(elements, {label = _U('bikefree'), value = 'bike'}) 
		--table.insert(elements, {label = _U('bike2free'), value = 'bike2'}) 
		--table.insert(elements, {label = _U('bike3free'), value = 'bike3'}) 
		--table.insert(elements, {label = _U('bike4free'), value = 'bike4'}) 
		table.insert(elements, {label = 'Petit Scooter', value = 'faggio3'}) 
	end
	
	
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'client',
    {
		title    = _U('biketitle'),
		align    = 'bottom-right',
		elements = elements,
    },
	
	
	function(data, menu)

	if data.current.value == 'faggio3' then
		local ped = PlayerPedId()
		TriggerServerEvent("esx:bike:lowmoney", 50)
		--spawn_effect2("faggio3")
		RequestModel('faggio3')
		while not HasModelLoaded('faggio3') do
			Citizen.Wait(0)
		end
		local veh = CreateVehicle(GetHashKey('faggio3'), GetEntityCoords(ped), GetEntityHeading(ped), true, true)
		TaskWarpPedIntoVehicle(ped, veh, -1)
		SetVehicleEnginePowerMultiplier(veh, 2.0 * 2.0)
		SetVehicleNumberPlateText(veh, 'GRATUIT')
		havebike = true
		ESX.UI.Menu.CloseAll()
	end

	ESX.UI.Menu.CloseAll()
	havebike = true	
	

	end,
	function(data, menu)
		menu.close()
		end
	)
end


function helptext(text)
	SetTextComponentFormat('STRING')
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function spawn_effect(somecar) 
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	TriggerEvent('esx:spawnVehicle', somecar)
	DoScreenFadeIn(3000) 
	Citizen.Wait(1000)
	SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0 * 5.0)
	havebike = true
end

function spawn_effect2(somecar) 
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	TriggerEvent('esx:spawnVehicle', somecar)
	RequestModel('faggio3')
	while not HasModelLoaded('faggio3') do
		Citizen.Wait(0)
	end

	local veh = CreateVehicle(GetHashKey('faggio3'), GetEntityCoords(ped), GetEntityHeading(ped), true, true)
	DoScreenFadeIn(3000) 
	Citizen.Wait(1000)
	SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0 * 2.0)
	Citizen.Wait(1000)
	havebike = true
	SetModelAsNoLongerNeeded('faggio3')
end