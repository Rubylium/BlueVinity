ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('RubyMenu:getUsergroup', function(source, cb)
     local xPlayer = ESX.GetPlayerFromId(source)
     local group = xPlayer.getGroup()
     cb(group)
end)


RegisterServerEvent("Admin2Menu:MessageResellerCoke2")
AddEventHandler("Admin2Menu:MessageResellerCoke2", function(money, x, y, z)

	local message = money
	print(message)
	local xPlayers	= ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('Admin2Menu:MessageResellerCoke2Police2', xPlayers[i], message, x, y, z)
		else
			TriggerClientEvent('Admin2Menu:MessageResellerCoke22', xPlayers[i], message, x, y, z)
		end
	end
	

end)



RegisterServerEvent("Admin2Menu:MessageResellerWeed2")
AddEventHandler("Admin2Menu:MessageResellerWeed2", function(money, x, y, z)

	local message = money
	print(message)
	local xPlayers	= ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('Admin2Menu:MessageResellerWeed2Police2', xPlayers[i], message, x, y, z)
		else
			TriggerClientEvent('Admin2Menu:MessageResellerWeed22', xPlayers[i], message, x, y, z)
		end
	end
	

end)

RegisterServerEvent("Admin2Menu:MessageResellerOpium2")
AddEventHandler("Admin2Menu:MessageResellerOpium2", function(money, x, y, z)

	local message = money
	print(message)
	local xPlayers	= ESX.GetPlayers()
	

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('Admin2Menu:MessageResellerOpium2Police2', xPlayers[i], message, x, y, z)
		else
			TriggerClientEvent('Admin2Menu:MessageResellerOpium22', xPlayers[i], message, x, y, z)
		end
	end
	

end)

RegisterServerEvent("Admin2Menu:MessageResellerPack2")
AddEventHandler("Admin2Menu:MessageResellerPack2", function(money, x, y, z)

	local message = money
	print(message)
	local xPlayers	= ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('Admin2Menu:MessageResellerPack2Police2', xPlayers[i], message, x, y, z)
		else
			TriggerClientEvent('Admin2Menu:MessageResellerPack22', xPlayers[i], message, x, y, z)
		end
	end
	

end)

RegisterServerEvent("Admin2Menu:MessageResellerFin2")
AddEventHandler("Admin2Menu:MessageResellerFin2", function(money, x, y, z)

	local message = money
	print(message)
	local xPlayers	= ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
		--	TriggerClientEvent('Admin2Menu:MessageResellerFin22Police', xPlayers[i], message, x, y, z)
		else
			TriggerClientEvent('Admin2Menu:MessageResellerFin22', xPlayers[i], message, x, y, z)
		end
	end
	

end)

RegisterServerEvent("Admin2Menu:MessageResellerFin2Voiture")
AddEventHandler("Admin2Menu:MessageResellerFin2Voiture", function(money, x, y, z)

	local message = money
	print(message)
	local xPlayers	= ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
		else
			TriggerClientEvent('Admin2Menu:MessageResellerFin22Voiture', xPlayers[i], message, x, y, z)
		end
	end
	

end)

RegisterServerEvent("Admin2Menu:MessageResellerPolice2")
AddEventHandler("Admin2Menu:MessageResellerPolice2", function(money, x, y, z)

	local message = money
	print(message)
	local xPlayers	= ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		TriggerClientEvent('Admin2Menu:MessageResellerpolice22', xPlayers[i], message, x, y, z)
	end
	

end)

RegisterServerEvent("Admin2Menu:MessageResellerArme2")
AddEventHandler("Admin2Menu:MessageResellerArme2", function(money, x, y, z)

	local message = money
	print(message)
	local xPlayers	= ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('Admin2Menu:MessageResellerArme2Police2', xPlayers[i], message, x, y, z)
		else
			TriggerClientEvent('Admin2Menu:MessageResellerArme22', xPlayers[i], message, x, y, z)
		end
	end
	

end)

RegisterServerEvent("Admin2Menu:MessageResellerVoiture2")
AddEventHandler("Admin2Menu:MessageResellerVoiture2", function(x, y, z)

	local message = money
	print(x, y, z)
	local xPlayers	= ESX.GetPlayers()
	local rand = math.random(0,200)
	print(rand)
	print(rand)
	print(rand)
	print(rand)
	print(rand)
	print(rand)
	print(rand)
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			if (rand < 5) then
				TriggerClientEvent('Admin2Menu:MessageResellerVoiture2Police2', xPlayers[i], x, y, z)
			end
		else
			--TriggerClientEvent('Admin2Menu:MessageResellerVoiture22', xPlayers[i], message, x, y, z)
			TriggerClientEvent('ResellerMissionVoiture', xPlayers[i], x, y, z)
			--TriggerClientEvent('ResellerMissionVoitureCoords', xPlayers[i], x, y, z)
		end
	end
	

end)


RegisterServerEvent('PriseMissionResellerVoiture')
AddEventHandler('PriseMissionResellerVoiture', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('MissionResellerVoitureDebut', xPlayers[i])
	end
end)