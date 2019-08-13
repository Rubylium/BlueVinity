ESX = nil


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent("GoFast:VenteDuVehicule")
AddEventHandler("GoFast:VenteDuVehicule", function(bonus)
     local PrixVente = math.random(500, 1000)
     local _source = source
     local xPlayer = ESX.GetPlayerFromId(_source)
     if not xPlayer then return; end
     local bonusFinal = bonus
     if bonus > 900 then
          TriggerClientEvent('esx:showAdvancedNotification', source, 'GoFast', '~b~Récompense GoFast', '🔧~w~Véhicule en parfait état ! Bonus de ~g~'..bonusFinal..'$', 'CHAR_LESTER_DEATHWISH', 3)
     elseif bonus > 600 then
          TriggerClientEvent('esx:showAdvancedNotification', source, 'GoFast', '~b~Récompense GoFast', '🔧~w~Véhicule en états correct ! Bonus de ~g~'..bonusFinal..'$', 'CHAR_LESTER_DEATHWISH', 3)
     elseif bonus > 400 then
          TriggerClientEvent('esx:showAdvancedNotification', source, 'GoFast', '~b~Récompense GoFast', '🔧~w~Véhicule assez abimé ! Bonus de ~g~'..bonusFinal..'$', 'CHAR_LESTER_DEATHWISH', 3)
     elseif bonus > 100 then
          TriggerClientEvent('esx:showAdvancedNotification', source, 'GoFast', '~b~Récompense GoFast', '🔧~w~Véhicule complétement abimé ! Bonus de ~g~'..bonusFinal..'$', 'CHAR_LESTER_DEATHWISH', 3)
     end
     PrixVente = PrixVente + bonusFinal
     xPlayer.addMoney(PrixVente)
     TriggerClientEvent('esx:showAdvancedNotification', source, 'GoFast', '~b~Récompense GoFast', '✅~w~Vous avez gagné ~g~'..PrixVente..'$', 'CHAR_LESTER_DEATHWISH', 3)
end)