ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('Organisation:Menotte')
AddEventHandler('Organisation:Menotte', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('Organisation:Menotte', target)
end)


RegisterServerEvent('Organisation:requestarrest')
AddEventHandler('Organisation:requestarrest', function(targetid, playerheading, playerCoords,  playerlocation)
     _source = source
     print(targetid)
     print(playerheading)
     print(playerCoords)
     print(playerlocation)
	TriggerClientEvent('Organisation:getarrested', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('Organisation:doarrested', _source)
end)

RegisterServerEvent('Organisation:requestrelease')
AddEventHandler('Organisation:requestrelease', function(targetid, playerheading, playerCoords,  playerlocation)
	_source = source
	TriggerClientEvent('Organisation:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('Organisation:douncuffing', _source)
end)
