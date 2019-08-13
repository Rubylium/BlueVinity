local sirene = 1
Citizen.CreateThread(function()
	while true do
		
		----- IS IN VEHICLE -----
		local playerped = GetPlayerPed(-1)		
		if IsPedInAnyVehicle(playerped, false) then	
		
			----- IS DRIVER -----
			local veh = GetVehiclePedIsUsing(playerped)	
			if GetPedInVehicleSeat(veh, -1) == playerped then
				--- IS EMERG VEHICLE ---
				if GetVehicleClass(veh) == 18 then
				
					SetVehRadioStation(veh, "OFF")
					SetVehicleRadioEnabled(veh, false)
				
				
					----- CONTROLS -----	
					
					-- TOG LX SIREN
					if IsDisabledControlJustReleased(0, 19) then
						
						if sirene == 0 then
							-- on
							DisableVehicleImpactExplosionActivation(veh, 0)
							sirene = 1
						else
							-- off
							DisableVehicleImpactExplosionActivation(veh, 1)
							sirene = 0
						end
						
					end
					
				end
			end
		end
		Citizen.Wait(0)
	end
end)