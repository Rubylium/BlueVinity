

-- Boucle pour la vitesse des vhécules
Citizen.CreateThread(function() 
	local headId = {}
	while true do
		Citizen.Wait(1000)
		ped = GetPlayerPed(-1)
		veh = GetVehiclePedIsIn(ped, false)
		vehClass = GetVehicleClass(veh)
		if vehClass == 7 then
			SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0 * 20.0)
		elseif vehClass == 6 then
			SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0 * 13.0)
		elseif vehClass == 5 then
			SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0 * 7.0)
		elseif vehClass == 8 then
			SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0 * 4.0)
		end
	end
end)