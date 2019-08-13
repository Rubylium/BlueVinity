

ESX = nil


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


function CountCops()

	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1000, CountCops)
	--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | 8h32 il y avait 8 policier, à voir pour une actualisation^0')
end

CountCops()

    ESX.RegisterServerCallback('Lenzh_chopshop:anycops',function(source, cb)
        local anycops = 0
        local playerList = GetPlayers()
        for i=1, #playerList, 1 do
            local _source = playerList[i]
            local xPlayer = ESX.GetPlayerFromId(_source)
            local playerjob = xPlayer.job.name
            if playerjob == 'police' then
                anycops = anycops + 1
            end
        end
        cb(anycops)
    end)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5000)
            PrixPolicierVente = CopsConnected * 150
            PrixArgentProre = CopsConnected * 150
            local r = math.random(7000, 9000) + PrixPolicierVente
            PrixVente = r
        end
    end)

    RegisterServerEvent("lenzh_chopshop:rewards")
    AddEventHandler("lenzh_chopshop:rewards", function(bonus)
        --Rewards()
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if not xPlayer then return; end
        local bonusFinal = bonus * 10
        if bonus > 900 then
            TriggerClientEvent('esx:showAdvancedNotification', source, 'RESELLER', '~b~Récompense reseller', '🔧~w~Véhicule en parfait état ! Bonus de ~g~'..bonusFinal..'$', 'CHAR_LESTER_DEATHWISH', 3)
        elseif bonus > 600 then
            TriggerClientEvent('esx:showAdvancedNotification', source, 'RESELLER', '~b~Récompense reseller', '🔧~w~Véhicule en états correct ! Bonus de ~g~'..bonusFinal..'$', 'CHAR_LESTER_DEATHWISH', 3)
        elseif bonus > 400 then
            TriggerClientEvent('esx:showAdvancedNotification', source, 'RESELLER', '~b~Récompense reseller', '🔧~w~Véhicule assez abimé ! Bonus de ~g~'..bonusFinal..'$', 'CHAR_LESTER_DEATHWISH', 3)
        elseif bonus > 100 then
            TriggerClientEvent('esx:showAdvancedNotification', source, 'RESELLER', '~b~Récompense reseller', '🔧~w~Véhicule complétement abimé ! Bonus de ~g~'..bonusFinal..'$', 'CHAR_LESTER_DEATHWISH', 3)
        end
        PrixVente = PrixVente + bonusFinal
        xPlayer.addAccountMoney('black_money', PrixVente)
        xPlayer.addMoney(PrixVente)
        TriggerClientEvent('esx:showAdvancedNotification', source, 'RESELLER', '~b~Récompense reseller', '✅~w~Vous avez gagné ~g~'..PrixVente..'$~w~', 'CHAR_LESTER_DEATHWISH', 3)
    end)


    RegisterServerEvent('chopNotify')
    AddEventHandler('chopNotify', function()
        TriggerClientEvent("chopEnable", source)
    end)


    RegisterServerEvent('ChopInProgress')
    AddEventHandler('ChopInProgress', function(street1, street2, sex)
        TriggerClientEvent("outlawChopNotify", -1, "")
    end)


    RegisterServerEvent('ChopInProgressS1')
    AddEventHandler('ChopInProgressS1', function(street1, sex)
        TriggerClientEvent("outlawChopNotify", -1, "")

    end)

    RegisterServerEvent('ChoppingInProgressPos')
    AddEventHandler('ChoppingInProgressPos', function(gx, gy, gz)
        TriggerClientEvent('Choplocation', -1, gx, gy, gz)
    end)