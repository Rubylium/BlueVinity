-- CONFIG --

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
	"TITAN"
}

-- CODE --

Citizen.CreateThread(function()
	while true do
		Wait(1)

		playerPed = GetPlayerPed(-1)
		if playerPed then
			checkCar(GetVehiclePedIsIn(playerPed, false))

			x, y, z = table.unpack(GetEntityCoords(playerPed, true))
			for _, blacklistedCar in pairs(carblacklist) do
				checkCar(GetClosestVehicle(x, y, z, 500.0, GetHashKey(blacklistedCar), 70))
			end
		end
	end
end)


--local First = vector3(0.0, 0.0, 0.0)
--local Second = vector3(5.0, 5.0, 5.0)
----Config = {} 
----Config.DamageNeeded = 100.0 -- 100.0 being broken and 1000.0 being fixed a lower value than 100.0 will break it
--
--local Vehicle = {Coords = nil, Vehicle = nil, Dimension = nil, IsInFront = false, Distance = nil}
--Citizen.CreateThread(function()
--	Citizen.Wait(200)
--	while true do
--		local ped = PlayerPedId()
--		local closestVehicle, Distance = ESX.Game.GetClosestVehicle()
--		local vehicleCoords = GetEntityCoords(closestVehicle)
--		local dimension = GetModelDimensions(GetEntityModel(closestVehicle), First, Second)
--		if Distance < 1000  and not IsPedInAnyVehicle(ped, false) then
--			Vehicle.Coords = vehicleCoords
--			Vehicle.Dimensions = dimension
--			Vehicle.Vehicle = closestVehicle
--			Vehicle.Distance = Distance
--			if GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle), GetEntityCoords(ped), true) > GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle) * -1, GetEntityCoords(ped), true) then
--				Vehicle.IsInFront = false
--			else
--				Vehicle.IsInFront = true
--			end
--		else
--			Vehicle = {Coords = nil, Vehicle = nil, Dimensions = nil, IsInFront = false, Distance = nil}
--		end
--		Citizen.Wait(500)
--	end
--end)
--
--Citizen.CreateThread(function()
--	while true do 
--		Citizen.Wait(100)
--		local ped = PlayerPedId()
--		local playerPed = GetPlayerPed(-1)
--		coord = table.unpack(GetEntityCoords(playerPed, true))
--		for _, blacklistedCar in pairs(carblacklist) do
--			checkCar(ESX.Game.GetClosestVehicle(coord))
--		end
--	end
--end)

function checkCar(car)
	if car then
		carModel = GetEntityModel(car)
		carName = GetDisplayNameFromVehicleModel(carModel)

		if isCarBlacklisted(carModel) then
			_DeleteEntity(car)
			sendForbiddenMessage("Véhicule interdit supprimé!")
		end
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


