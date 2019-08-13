ESX = nil
local PlayersTransforming  = {}
local PlayersSelling       = {}
local PlayersHarvesting = {}
local fishandchips = 1
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'fishing', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'fishing', _U('fishing_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'fishing', 'Poissonnerie', 'society_fishing', 'society_fishing', 'society_fishing', {type = 'private'})
local function Harvest(source, zone)

	local xPlayer  = ESX.GetPlayerFromId(source)
	if zone == "FishingFarm" then
		local itemQuantity = xPlayer.getInventoryItem('fish').count
		if itemQuantity >= 50 then
			TriggerClientEvent('esx:showNotification', source, _U('not_enough_place'))
			return
		else
			SetTimeout(1300, function()
				xPlayer.addInventoryItem('fish', 1)
				Harvest(source, zone)
			end)
		end
	end
end

RegisterServerEvent('esx_fishingjob:startHarvest')
AddEventHandler('esx_fishingjob:startHarvest', function(zone)
	local _source = source
	PlayersHarvesting[_source]=true
	TriggerClientEvent('esx:showNotification', _source, _U('fish_taken'))  
	Harvest(_source,zone)
end)


RegisterServerEvent('esx_fishingjob:stopHarvest')
AddEventHandler('esx_fishingjob:stopHarvest', function()
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
		if zone == "FishDead" then
			local itemQuantity = xPlayer.getInventoryItem('fishd').count
			
			if itemQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_fishd'))
				return
			else
				local rand = math.random(0,100)
				if (rand >= 98) then
					SetTimeout(1400, function()
						xPlayer.removeInventoryItem('fishd', 1)
						xPlayer.addInventoryItem('fishandchips', 1)
						TriggerClientEvent('esx:showNotification', source, _U('not_enough_fishd'))
						Transform(source, zone)
					end)
				else
					SetTimeout(1400, function()
						xPlayer.removeInventoryItem('fishd', 1)
						xPlayer.addInventoryItem('fishandchips', 1)
				
						Transform(source, zone)
					end)
				end
			end
		elseif zone == "FishChips" then
			local itemQuantity = xPlayer.getInventoryItem('fish').count
			if itemQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_fish'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.removeInventoryItem('fish', 1)
					xPlayer.addInventoryItem('fishd', 1)
		  
					Transform(source, zone)	  
				end)
			end
		end
	end	
end	

RegisterServerEvent('esx_fishingjob:startTransform')
AddEventHandler('esx_fishingjob:startTransform', function(zone)
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

RegisterServerEvent('esx_fishingjob:stopTransform')
AddEventHandler('esx_fishingjob:stopTransform', function()

	local _source = source
	
	if PlayersTransforming[_source] == true then
		PlayersTransforming[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~Abattre vos Poissons')
		PlayersTransforming[_source]=true
		
	end
end)

local function Sell(source, zone)

	if PlayersSelling[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)
		local NombreFish = xPlayer.getInventoryItem('fishandchips').count
		
		if zone == 'SellFishChips' then
			if xPlayer.getInventoryItem('fishandchips').count <= 0 then
				fishandchips = 0
			else
				fishandchips = 1
			end
			
		
			if fishandchips == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_product_sale'))
				return
			elseif xPlayer.getInventoryItem('fishandchips').count <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_fish_sale'))
				fishandchips = 0
				return
			else
				if (fishandchips == 1) then
					SetTimeout(1100, function()
						local argent = math.random(16,17)
						local argentTotal = argent * NombreFish
						local money = math.random(16,19)
						local moneyTotal = money * NombreFish
						xPlayer.removeInventoryItem('fishandchips', NombreFish)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_fishing', function(account)
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

RegisterServerEvent('esx_fishingjob:startSell')
AddEventHandler('esx_fishingjob:startSell', function(zone)

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

RegisterServerEvent('esx_fishingjob:stopSell')
AddEventHandler('esx_fishingjob:stopSell', function()

	local _source = source
	
	if PlayersSelling[_source] == true then
		PlayersSelling[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~vendre')
		PlayersSelling[_source]=true
	end

end)

RegisterServerEvent('esx_fishingjob:getStockItem')
AddEventHandler('esx_fishingjob:getStockItem', function(itemName, count)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_fishing', function(inventory)

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

ESX.RegisterServerCallback('esx_fishingjob:getStockItems', function(source, cb)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_fishing', function(inventory)
		cb(inventory.items)
	end)

end)

RegisterServerEvent('esx_fishingjob:putStockItems')
AddEventHandler('esx_fishingjob:putStockItems', function(itemName, count)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_fishing', function(inventory)

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

ESX.RegisterServerCallback('esx_fishingjob:getPlayerInventory', function(source, cb)

	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({
		items      = items
	})

end)
