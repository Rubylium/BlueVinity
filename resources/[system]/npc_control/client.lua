DensityMultiplier = 0.0
local playerPed = GetPlayerPed(-1)
local playerLocalisation = GetEntityCoords(playerPed)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		SetVehicleDensityMultiplierThisFrame(DensityMultiplier)
		SetPedDensityMultiplierThisFrame(DensityMultiplier)
		SetRandomVehicleDensityMultiplierThisFrame(DensityMultiplier)
		SetParkedVehicleDensityMultiplierThisFrame(DensityMultiplier)
		SetScenarioPedDensityMultiplierThisFrame(DensityMultiplier, DensityMultiplier)
		SetGarbageTrucks(false) -- Stop garbage trucks from randomly spawning
		SetRandomBoats(false) -- Stop random boats from spawning in the water.
		SetCreateRandomCops(false) -- disable random cops walking/driving around.
		SetCreateRandomCopsNotOnScenarios(false) -- stop random cops (not in a scenario) from spawning.
		SetCreateRandomCopsOnScenarios(false) -- stop random cops (in a scenario) from spawning.
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
		ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
		RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0);
		ClearAreaOfCops(playerLocalisation.x, playerLocalisation.y, playerLocalisation.z, 400.0)
	end
end)

--Citizen.CreateThread(function()
--	for _, player in ipairs(GetActivePlayers()) do
--		Citizen.InvokeNative(0xDC0F817884CDD856, player, false)
--	end
--	while true do
--		Citizen.Wait(0)
--		if GetPlayerWantedLevel(PlayerId()) ~= 0 then
--			ClearPlayerWantedLevel(PlayerId())
--		end
--	end
--end)