ESX = nil
local PlayersTransforming  = {}
local PlayersSelling       = {}
local PlayersHarvesting = {}
local packaged_plank = 1
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'lumberjack', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'lumberjack', _U('lumberjack_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'lumberjack', 'Bucherons', 'society_lumberjack', 'society_lumberjack', 'society_lumberjack', {type = 'private'})
local function Harvest(source, zone)
	if PlayersHarvesting[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "WoodFarm" or zone == "WoodFarm2" or zone == "WoodFarm3" or zone == "WoodFarm4" then
			local itemQuantity = xPlayer.getInventoryItem('wood').count
			if itemQuantity >= 50 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_place'))
				return
			else
				SetTimeout(1500, function()
					xPlayer.addInventoryItem('wood', 1)
					Harvest(source, zone)
				end)
			end
		end
	end
end

RegisterServerEvent('lumberjack:startHarvest')
AddEventHandler('lumberjack:startHarvest', function(zone)
	local _source = source
  	
	if PlayersHarvesting[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersHarvesting[_source]=false
	else
		PlayersHarvesting[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('wood_taken'))  
		Harvest(_source,zone)
	end
end)


RegisterServerEvent('lumberjack:stopHarvest')
AddEventHandler('lumberjack:stopHarvest', function()
	local _source = source
	
	if PlayersHarvesting[_source] == true then
		PlayersHarvesting[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~récolter')
		PlayersHarvesting[_source]=true
	end
end)

local function Transform(source, zone)

	if PlayersTransforming[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "TraitementPlank" then
			local itemQuantity = xPlayer.getInventoryItem('cutted_wood').count
			local itemQuantity2 = xPlayer.getInventoryItem('packaged_plank').count
			
			if itemQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_woodd'))
				return
			else
				local rand = math.random(0,100)
				if (rand >= 98) then
					SetTimeout(1800, function()
						if itemQuantity2 >= 50 then
							TriggerClientEvent('esx:showNotification', source, 'Mmh, c\'est trop lourd.')
							return
						else
							xPlayer.removeInventoryItem('cutted_wood', 1)
							xPlayer.addInventoryItem('packaged_plank', 1)
							TriggerClientEvent('esx:showNotification', source, _U('not_enough_woodd'))
							Transform(source, zone)
						end
					end)
				else
					SetTimeout(1800, function()
						if itemQuantity2 >= 50 then
							TriggerClientEvent('esx:showNotification', source, 'Mmh, c\'est trop lourd.')
							return
						else
							xPlayer.removeInventoryItem('cutted_wood', 1)
							xPlayer.addInventoryItem('packaged_plank', 1)
							Transform(source, zone)
						end
					end)
				end
			end
		elseif zone == "TraitementWood" then
			local itemQuantity = xPlayer.getInventoryItem('wood').count
			local itemQuantity2 = xPlayer.getInventoryItem('cutted_wood').count
			if itemQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_wood'))
				return
			else
				SetTimeout(1500, function()
					if itemQuantity2 >= 50 then
						TriggerClientEvent('esx:showNotification', source, 'Mmh, c\'est trop lourd.')
						return
					else
						xPlayer.removeInventoryItem('wood', 1)
						xPlayer.addInventoryItem('cutted_wood', 1)
						Transform(source, zone)	  
					end
				end)
			end
		end
	end	
end	

RegisterServerEvent('lumberjack:startTransform')
AddEventHandler('lumberjack:startTransform', function(zone)
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

RegisterServerEvent('lumberjack:stopTransform')
AddEventHandler('lumberjack:stopTransform', function()

	local _source = source
	
	if PlayersTransforming[_source] == true then
		PlayersTransforming[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~transformer votre petrol')
		PlayersTransforming[_source]=true
		
	end
end)

local function Sell(source, zone)

	if PlayersSelling[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)
		local nombrePlanche = xPlayer.getInventoryItem('packaged_plank').count
		
		if zone == 'SellFarm' then
			if xPlayer.getInventoryItem('packaged_plank').count <= 0 then
				packaged_plank = 0
			else
				packaged_plank = 1
			end
			
		
			if packaged_plank == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_product_sale'))
				return
			elseif xPlayer.getInventoryItem('packaged_plank').count <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_wood_sale'))
				packaged_plank = 0
				return
			else
				if (packaged_plank == 1) then
					SetTimeout(1100, function()
						local argent = math.random(12,13)
						local argentTotal = argent * nombrePlanche
						local money = math.random(14,16)
						local moneyTotal = money * nombrePlanche
						xPlayer.removeInventoryItem('packaged_plank', nombrePlanche)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_lumberjack', function(account)
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

RegisterServerEvent('lumberjack:startSell')
AddEventHandler('lumberjack:startSell', function(zone)

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

RegisterServerEvent('lumberjack:stopSell')
AddEventHandler('lumberjack:stopSell', function()

	local _source = source
	
	if PlayersSelling[_source] == true then
		PlayersSelling[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~vendre')
		PlayersSelling[_source]=true
	end

end)

RegisterServerEvent('lumberjack:getStockItem')
AddEventHandler('lumberjack:getStockItem', function(itemName, count)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_lumberjack', function(inventory)

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

ESX.RegisterServerCallback('lumberjack:getStockItems', function(source, cb)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_lumberjack', function(inventory)
		cb(inventory.items)
	end)

end)

RegisterServerEvent('lumberjack:putStockItems')
AddEventHandler('lumberjack:putStockItems', function(itemName, count)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_lumberjack', function(inventory)

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

ESX.RegisterServerCallback('lumberjack:getPlayerInventory', function(source, cb)

	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({
		items      = items
	})

end)
