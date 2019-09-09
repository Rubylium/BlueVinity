-- CONFIG --

ESX          = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
-- Blacklisted vehicle models
carblacklist = {
	"RHINO",
	"BLIMP",
	"BLIMP2",
	"CARGOPLANE",
	"BESRA",
	"CUBAN800",
	"DODO",
	"JET",
	"MILJET",
	"FAGGIO3",
	"CARGOBOB",
	"hydra",
	"CUTTER",
	"DUMP",
	"BULLDOZER",
	"Lazer",
	"luxor",
	"luxor2",
	"miljet",
	"nimbus",
	"shamal",
	"mammatus",
	"besra",
	"TITAN"
}

-- CODE --

Citizen.CreateThread(function()
	while true do
		Wait(250)

		playerPed = GetPlayerPed(-1)
		if playerPed then
			checkCar(GetVehiclePedIsIn(playerPed, false))

			coords = GetEntityCoords(playerPed, true)
			x, y, z = table.unpack(GetEntityCoords(playerPed, true))
			--for _, blacklistedCar in pairs(carblacklist) do
			--	checkCar(GetClosestVehicle(x, y, z, 500.0, GetHashKey(blacklistedCar), 70))
			--end
			for _, blacklistedCar in pairs(carblacklist) do
				local voiture = ESX.Game.GetVehiclesInArea(coords, 500)
				for _, voiture in pairs(voiture) do
					checkCar(voiture)
				end
			end
			--for _, blacklistedCar in pairs(carblacklist) do
			--	local voiture = ESX.Game.GetClosestVehicle(coords)
			--	checkCar(voiture)
			--end
		end
	end
end)

function checkCar(car)
	if car then
		carModel = GetEntityModel(car)
		carName = GetDisplayNameFromVehicleModel(carModel)

		if isCarBlacklisted(carModel) then
			_DeleteEntity(car)
			AfficherAC("~r~RUBY ANTI CHEAT ACTIVER - SUPPRESSION DE VEHICULE BLACKLIST EN COURS !\nPERTE DE FPS POSSIBLE !")
		end
	end
end


function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end


local textActif = false
local wait = 0
function AfficherAC(text)
	if textActif == false then
		Citizen.CreateThread(function()
			textActif = true
			while wait < 200 do
				wait = wait + 1
				DrawAdvancedText(0.588, 0.836, 0.005, 0.0028, 0.4, text, 255, 255, 255, 255, 6, 0)
				Wait(10)
			end
			wait = 0
			textActif = false
		end)
	end
end

function isCarBlacklisted(model)
	for _, blacklistedCar in pairs(carblacklist) do
		if model == GetHashKey(blacklistedCar) then
			return true
		end
	end

	return false
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

