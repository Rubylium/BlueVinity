ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("esx:bike:lowmoney")
AddEventHandler("esx:bike:lowmoney", function(money)
	local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeMoney(money)
	TriggerClientEvent('esx:showAdvancedNotification', source, "Location véhicule", "~b~Vous avez loué un véhicule", "Merci d'avoir loué un véhicule, une caution de ~g~50$~w~ à été prise.", "CHAR_CARSITE", 8)
end)


RegisterServerEvent("esx:bike:lowmoneyRendu")
AddEventHandler("esx:bike:lowmoneyRendu", function(money)
	local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(money)
	TriggerClientEvent('esx:showAdvancedNotification', source, "Location véhicule", "~b~Vous avez rendu un véhicule", "Merci d'avoir rendu un véhicule, vous avez gagné ~g~50$", "CHAR_CARSITE", 8)
end)

RegisterServerEvent("esx:bike:antifdp")
AddEventHandler("esx:bike:antifdp", function(source)
	local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.RemoveMoney(200)
	DropPlayer(_source, "RUBY-ANTICHEAT | Alors ? Tu à essayer de glitch l'argent ? Dégage du serveur.")
end)