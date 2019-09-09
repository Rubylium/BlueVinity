--	  LosOceanic_TA =  Traffic / Pedestrian / Parked Cars Adjuster		--
--	Every 5 Minutes, count player total and update the calculation		--
--		By DK - 2019...	Dont forget your Bananas!			--
------------------------------------------------------------------------------
------------------------------------------------------------------------------

-- The math is, (( Config.PopulationNumber - (Config.Players * 2.25 )) / Config.1000)  =  0.3880 or less
-- The deal is to reduce the overal feel of the city as the player population is introduced.
		
-- The natives take a .0 as nothing, 1 as normal, 2 as doubled etc value. 
-- So why not make it like 0.10 @ 128 Players??

------------------------------------------------------------------------------
-- Threads														--
------------------------------------------------------------------------------

Citizen.CreateThread(function()
	local iPlayer = GetEntityCoords(PlayerPedId())	-- Your Ped as an Entity. Vector3 (x,y,z)
	local iPlayerID = GetPlayerServerId()			-- Your Ped's ID.
	
	DisablePlayerVehicleRewards(iPlayerID)		-- Call it once.
	
	while Config.Switch == true do				-- Call it all...
		Citizen.Wait(0)							-- Every Frame!
		for i = 0, 15 do						-- For all gangs and emergancy services.	
			EnableDispatchService(i, Config.Dispatch)		-- Disable responding/dispatch.
		end			
		SetVehicleDensityMultiplierThisFrame((Config.TrafficX - Config.iPlayers) / Config.Divider)
		SetPedDensityMultiplierThisFrame((Config.PedestrianX - Config.iPlayers) / Config.Divider)
		SetRandomVehicleDensityMultiplierThisFrame((Config.TrafficX - Config.iPlayers) / Config.Divider)
		SetParkedVehicleDensityMultiplierThisFrame((Config.ParkedX - Config.iPlayers) / Config.Divider)
		SetScenarioPedDensityMultiplierThisFrame((Config.PedestrianX - Config.iPlayers) / Config.Divider, (Config.PedestrianX - Config.iPlayers) / Config.Divider)
		ClearAreaOfCops(iPlayer.x, iPlayer.y, iPlayer.z, 5000.0)
		RemoveVehiclesFromGeneratorsInArea(iPlayer.x - 45.0, iPlayer.y - 45.0, iPlayer.z - 15.0, iPlayer.x + 45.0, iPlayer.y + 45.0, iPlayer.z + 15.0);
		SetGarbageTrucks(0)
		SetRandomBoats(0)
	end
end)

Citizen.CreateThread(function()
	for _, player in ipairs(GetActivePlayers()) do
		Citizen.InvokeNative(0xDC0F817884CDD856, i, false)
	end
	while true do
		Citizen.Wait(0)
		if GetPlayerWantedLevel(PlayerId()) ~= 0 then
			ClearPlayerWantedLevel(PlayerId())
		end
	end
end)

------------------------------------------------------------------------------
-- Functions																--
------------------------------------------------------------------------------

function Check()			-- Tell that Global Variable to be beautiful.

	Config.Switch = false
	local Multiplier = 0		-- Player Count.

	for _,i in ipairs(GetActivePlayers()) do
		local iPed = GetPlayerPed(i)

		if DoesEntityExist(iPed) then
			Multiplier = Multiplier + 1
		end
	end
		
	if Multiplier ~= 0 then
		Config.iPlayers = Config.Static * Multiplier
	end	

	Wait(100)
	Config.Switch = true
end
	
------------------------------------------------------------------------------
-- Events													--
------------------------------------------------------------------------------

RegisterNetEvent('LosOce_TA:Force')
AddEventHandler('LosOce_TA:Force', function()
	Check()
end)
