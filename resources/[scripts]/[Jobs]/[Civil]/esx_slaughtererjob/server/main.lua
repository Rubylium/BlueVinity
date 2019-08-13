ESX = nil
local PlayersTransforming  = {}
local PlayersSelling       = {}
local PlayersHarvesting = {}
local packaged_chicken = 1
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'slaughterer', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'slaughterer', _U('slaughterer_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'slaughterer', 'Abatteur', 'society_slaughterer', 'society_slaughterer', 'society_slaughterer', {type = 'private'})
local function Harvest(source, zone)
	if PlayersHarvesting[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "FarmChicken" then
			local itemQuantity = xPlayer.getInventoryItem('alive_chicken').count
			if itemQuantity >= 50 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_place'))
				return
			else
				SetTimeout(1500, function()
					xPlayer.addInventoryItem('alive_chicken', 1)
					xPlayer.removeMoney(1)
					Harvest(source, zone)
				end)
				TriggerClientEvent('esx:showNotification', source, ('Un Poulet coûte ~g~$2'))
			end
		end
	end
end

RegisterServerEvent('esx_slaughtererjob:startHarvest')
AddEventHandler('esx_slaughtererjob:startHarvest', function(zone)
	local _source = source
  	
	if PlayersHarvesting[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersHarvesting[_source]=false
	else
		PlayersHarvesting[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('chicken_taken'))  
		Harvest(_source,zone)
	end
end)


RegisterServerEvent('esx_slaughtererjob:stopHarvest')
AddEventHandler('esx_slaughtererjob:stopHarvest', function()
	local _source = source
	
	if PlayersHarvesting[_source] == true then
		PlayersHarvesting[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~Acheter des Poulets')
		PlayersHarvesting[_source]=true
	end
end)


local function Transform(source, zone)

	if PlayersTransforming[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "ConditChicken" then
			local itemQuantity = xPlayer.getInventoryItem('slaughtered_chicken').count
			local itemQuantity2 = xPlayer.getInventoryItem('packaged_chicken').count
			
			if itemQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_chickend'))
				return
			else
				local rand = math.random(0,100)
				if (rand >= 98) then
					SetTimeout(1500, function()
						if itemQuantity2 >= 50 then
							TriggerClientEvent('esx:showNotification', source, _U('not_enough_place'))
							return
						else
							xPlayer.removeInventoryItem('slaughtered_chicken', 1)
							xPlayer.addInventoryItem('packaged_chicken', 1)
							TriggerClientEvent('esx:showNotification', source, _U('not_enough_chickend'))
							Transform(source, zone)
						end
					end)
				else
					SetTimeout(1500, function()
						if itemQuantity2 >= 50 then
							TriggerClientEvent('esx:showNotification', source, _U('not_enough_place'))
							return
						else
							xPlayer.removeInventoryItem('slaughtered_chicken', 1)
							xPlayer.addInventoryItem('packaged_chicken', 1)
				
							Transform(source, zone)
						end
					end)
				end
			end
		elseif zone == "ChickenDead" then
			local itemQuantity = xPlayer.getInventoryItem('alive_chicken').count
			local itemQuantity2 = xPlayer.getInventoryItem('slaughtered_chicken').count
			if itemQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_chicken'))
				return
			else
				SetTimeout(1500, function()
					if itemQuantity2 >= 50 then
						TriggerClientEvent('esx:showNotification', source, _U('not_enough_place'))
						return
					else
						xPlayer.removeInventoryItem('alive_chicken', 1)
						xPlayer.addInventoryItem('slaughtered_chicken', 1)
		  
						Transform(source, zone)	  
					end
				end)
			end
		end
	end	
end	

RegisterServerEvent('esx_slaughtererjob:startTransform')
AddEventHandler('esx_slaughtererjob:startTransform', function(zone)
	local _source = source
  	
	if PlayersTransforming[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersTransforming[_source]=false
	else
		PlayersTransforming[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('transforming_in_progress')) 
		Transform(_source,zone)
	end
end)

RegisterServerEvent('esx_slaughtererjob:stopTransform')
AddEventHandler('esx_slaughtererjob:stopTransform', function()

	local _source = source
	
	if PlayersTransforming[_source] == true then
		PlayersTransforming[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez vous remettre au ~g~Travail')
		PlayersTransforming[_source]=true
		
	end
end)

local function Sell(source, zone)

	if PlayersSelling[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)
		local nombrePoulet = xPlayer.getInventoryItem('packaged_chicken').count
		
		if zone == 'ChickenSell' then
			if xPlayer.getInventoryItem('packaged_chicken').count <= 0 then
				packaged_chicken = 0
			else
				packaged_chicken = 1
			end
			
		
			if packaged_chicken == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_product_sale'))
				return
			elseif xPlayer.getInventoryItem('packaged_chicken').count <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_chicken_sale'))
				packaged_chicken = 0
				return
			else
				if (packaged_chicken == 1) then
					SetTimeout(1100, function()
						local argent = math.random(13,14)
						local argentTotal = argent * nombrePoulet
						local money = math.random(14,17)
						local moneyTotal = money * nombrePoulet
						xPlayer.removeInventoryItem('packaged_chicken', nombrePoulet)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_slaughterer', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
						
							xPlayer.addMoney(argentTotal)
							societyAccount.addMoney(moneyTotal)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_earned') .. argentTotal)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. moneyTotal)
						end
						Sell(source,zone)
					end)
				end
				
			end
		end
	end
end

RegisterServerEvent('esx_slaughtererjob:startSell')
AddEventHandler('esx_slaughtererjob:startSell', function(zone)

	local _source = source
	
	if PlayersSelling[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersSelling[_source]=false
	else
		PlayersSelling[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))
		Sell(_source, zone)
	end

end)

RegisterServerEvent('esx_slaughtererjob:stopSell')
AddEventHandler('esx_slaughtererjob:stopSell', function()

	local _source = source
	
	if PlayersSelling[_source] == true then
		PlayersSelling[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~vendre')
		PlayersSelling[_source]=true
	end

end)

RegisterServerEvent('esx_slaughtererjob:getStockItem')
AddEventHandler('esx_slaughtererjob:getStockItem', function(itemName, count)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_slaughterer', function(inventory)

		local item = inventory.getItem(itemName)

		if item.count >= count then
			inventory.removeItem(itemName, count)
			xPlayer.addInventoryItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn') .. count .. ' ' .. item.label)

	end)

end)

ESX.RegisterServerCallback('esx_slaughtererjob:getStockItems', function(source, cb)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_slaughterer', function(inventory)
		cb(inventory.items)
	end)

end)

RegisterServerEvent('esx_slaughtererjob:putStockItems')
AddEventHandler('esx_slaughtererjob:putStockItems', function(itemName, count)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_slaughterer', function(inventory)

		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('added') .. count .. ' ' .. item.label)

	end)
end)

ESX.RegisterServerCallback('esx_slaughtererjob:getPlayerInventory', function(source, cb)

	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({
		items      = items
	})

end)
