ESX = nil
local PlayersTransforming  = {}
local PlayersSelling       = {}
local PlayersHarvesting = {}
local clothe = 1
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'tailer', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'tailer', _U('tailer_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'tailer', 'Tailleur', 'society_tailer', 'society_tailer', 'society_tailer', {type = 'private'})
local function Harvest(source, zone)
	if PlayersHarvesting[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "WoolFarm" then
			local itemQuantity = xPlayer.getInventoryItem('wool').count
			if itemQuantity >= 50 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_place'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.addInventoryItem('wool', 1)
					xPlayer.removeMoney(2)
					Harvest(source, zone)
					TriggerClientEvent('esx:tailerNotif', source)
				end)
				--TriggerClientEvent('esx:showNotification', source, ('La Laine n\'est pas gratuite mais coûte ~g~$2 pièce'))
				--ex ports.pNotify:SendNotification({text = "Achats Laine éffectué", type = "success", timeout = 2000})
			end
		end
	end
end


RegisterServerEvent('esx_tailerjob:startHarvest')
AddEventHandler('esx_tailerjob:startHarvest', function(zone)
	local _source = source
  	
	if PlayersHarvesting[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersHarvesting[_source]=false
	else
		PlayersHarvesting[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('wool_taken'))  
		Harvest(_source,zone)
	end
end)


RegisterServerEvent('esx_tailerjob:stopHarvest')
AddEventHandler('esx_tailerjob:stopHarvest', function()
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
		if zone == "TraitementClothe" then
			local itemQuantity = xPlayer.getInventoryItem('tissu').count
			
			if itemQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_tissu'))
				return
			else
				local rand = math.random(0,100)
				if (rand >= 98) then
					SetTimeout(1800, function()
						xPlayer.removeInventoryItem('tissu', 1)
						xPlayer.addInventoryItem('clothe', 1)
						TriggerClientEvent('esx:showNotification', source, _U('not_enough_tissu'))
						Transform(source, zone)
					end)
				else
					SetTimeout(1800, function()
						xPlayer.removeInventoryItem('tissu', 1)
						xPlayer.addInventoryItem('clothe', 1)
				
						Transform(source, zone)
					end)
				end
			end
		elseif zone == "TraitementTissu" then
			local itemQuantity = xPlayer.getInventoryItem('wool').count
			if itemQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_wool'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.removeInventoryItem('wool', 1)
					xPlayer.addInventoryItem('tissu', 1)
		  
					Transform(source, zone)	  
				end)
			end
		end
	end	
end	

RegisterServerEvent('esx_tailerjob:startTransform')
AddEventHandler('esx_tailerjob:startTransform', function(zone)
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

RegisterServerEvent('esx_tailerjob:stopTransform')
AddEventHandler('esx_tailerjob:stopTransform', function()

	local _source = source
	
	if PlayersTransforming[_source] == true then
		PlayersTransforming[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~continuer ~s~votre activité')
		PlayersTransforming[_source]=true
		
	end
end)

local function Sell(source, zone)

	if PlayersSelling[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)
		local nombreVetement = xPlayer.getInventoryItem('clothe').count
		
		if zone == 'SellFarm' then
			if xPlayer.getInventoryItem('clothe').count <= 0 then
				clothe = 0
			else
				clothe = 1
			end
			
		
			if clothe == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_product_sale'))
				return
			elseif xPlayer.getInventoryItem('clothe').count <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_clothe_sale'))
				clothe = 0
				return
			else
				if (clothe == 1) then
					SetTimeout(1100, function()
						local argent = math.random(15,17)
						local argentTotal = argent * nombreVetement
						local money = math.random(15,17)
						local moneyTotal = money * nombreVetement
						xPlayer.removeInventoryItem('clothe', nombreVetement)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_tailer', function(account)
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

RegisterServerEvent('esx_tailerjob:startSell')
AddEventHandler('esx_tailerjob:startSell', function(zone)

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

RegisterServerEvent('esx_tailerjob:stopSell')
AddEventHandler('esx_tailerjob:stopSell', function()

	local _source = source
	
	if PlayersSelling[_source] == true then
		PlayersSelling[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~vendre')
		PlayersSelling[_source]=true
	end

end)

RegisterServerEvent('esx_tailerjob:getStockItem')
AddEventHandler('esx_tailerjob:getStockItem', function(itemName, count)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tailer', function(inventory)

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

ESX.RegisterServerCallback('esx_tailerjob:getStockItems', function(source, cb)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tailer', function(inventory)
		cb(inventory.items)
	end)

end)

RegisterServerEvent('esx_tailerjob:putStockItems')
AddEventHandler('esx_tailerjob:putStockItems', function(itemName, count)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tailer', function(inventory)

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

ESX.RegisterServerCallback('esx_tailerjob:getPlayerInventory', function(source, cb)

	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({
		items      = items
	})

end)
