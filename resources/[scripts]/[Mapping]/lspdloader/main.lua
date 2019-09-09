Citizen.CreateThread(function()
	LoadInterior(GetInteriorAtCoords(440.84, -983.14, 30.69))
end)


Citizen.CreateThread(function() 
	local Interior = GetInteriorAtCoords(440.84, -983.14, 30.69) 
	LoadInterior(Interior) 
end)