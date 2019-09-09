

function drawTxt2(x,y ,width,height,scale, text, r,g,b,a)
	if not HideHud then
		SetTextFont(6)
		SetTextProportional(0)
		SetTextScale(0.4, 0.4)
		SetTextColour(r, g, b, a)
		SetTextDropShadow(0, 0, 0, 0,255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(x - width/2, y - height/2 + 0.005)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local ped = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(ped, false)
			if (vehicle ~= 0) then 
				local pos = GetEntityCoords(PlayerPedId())
				local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
				local current_zone = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))

				if GetStreetNameFromHashKey(var1) and GetNameOfZone(pos.x, pos.y, pos.z) then
					if GetStreetNameFromHashKey(var1) then
						if GetStreetNameFromHashKey(var2) == "" then
							drawTxt2(x-0.266, y+0.45, 1.0,1.0,0.45, current_zone, town_r, town_g, town_b, town_a)
						else 
							drawTxt2(x-0.266, y+0.45, 1.0,1.0,0.45, GetStreetNameFromHashKey(var2) .. ", " .. GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z)), str_around_r, str_around_g, str_around_b, str_around_a)
						end 
							drawTxt2(x-0.266, y+0.42, 1.0,1.0,0.55, GetStreetNameFromHashKey(var1), curr_street_r, curr_street_g, curr_street_b, curr_street_a)
					end
				end

		end
	end
end)