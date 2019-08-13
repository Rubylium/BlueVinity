ESX = nil
local PlayersTransforming  = {}
local PlayersSelling       = {}
local PlayersHarvesting = {}
local copper = 1
local iron = 1
local gold = 1 
local diamond = 1

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'miner', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'miner', _U('miner_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'miner', 'Mineur', 'society_miner', 'society_miner', 'society_miner', {type = 'private'})
local function Harvest(source, zone)
	if PlayersHarvesting[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "MineFarm" or zone == "MineFarm2" or zone == "MineFarm3" or zone == "MineFarm4" or zone == "MineFarm5" or zone == "MineFarm6" or zone == "MineFarm7 "then
			local itemQuantity = xPlayer.getInventoryItem('stone').count
			if itemQuantity >= 50 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_place'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.addInventoryItem('stone', 1)
					Harvest(source, zone)
				end)
			end
		end
	end
end

RegisterServerEvent('esx_minerjob:startHarvest')
AddEventHandler('esx_minerjob:startHarvest', function(zone)
	local _source = source
  	
	if PlayersHarvesting[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersHarvesting[_source]=false
	else
		PlayersHarvesting[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('stone_taken'))  
		Harvest(_source,zone)
	end
end)


RegisterServerEvent('esx_minerjob:stopHarvest')
AddEventHandler('esx_minerjob:stopHarvest', function()
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
		if zone == "TraitementFoundry" then
			local itemQuantity = xPlayer.getInventoryItem('washed_stone').count
			
			if itemQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_stonew'))
				return
			else
				local rand = math.random(0,100)
				if (rand <= 15) then
					SetTimeout(1800, function()
						xPlayer.removeInventoryItem('washed_stone', 1)
						xPlayer.addInventoryItem('diamond', 1)
						--TriggerClientEvent('esx:showNotification', source, _U('not_enough_stonew'))
						Transform(source, zone)
					end)
				elseif (rand <= 20) then
					SetTimeout(1800, function()
						xPlayer.removeInventoryItem('washed_stone', 1)
						xPlayer.addInventoryItem('gold', 1)
				
						Transform(source, zone)
					end)
				elseif (rand <= 25) then
					SetTimeout(1800, function()
						xPlayer.removeInventoryItem('washed_stone', 1)
						xPlayer.addInventoryItem('iron', 2)
				
						Transform(source, zone)
					end)
				elseif (rand <= 100) then
					SetTimeout(1800, function()
						xPlayer.removeInventoryItem('washed_stone', 1)
						xPlayer.addInventoryItem('copper', 3)
				
						Transform(source, zone)
					end)
				end
			end
		elseif zone == "TraitementStoneW" then
			local itemQuantity = xPlayer.getInventoryItem('stone').count
			if itemQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_stone'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.removeInventoryItem('stone', 1)
					xPlayer.addInventoryItem('washed_stone', 1)
					Transform(source, zone)	  
				end)
			end
		end
	end	
end	

RegisterServerEvent('esx_minerjob:startTransform')
AddEventHandler('esx_minerjob:startTransform', function(zone)
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

RegisterServerEvent('esx_minerjob:stopTransform')
AddEventHandler('esx_minerjob:stopTransform', function()

	local _source = source
	
	if PlayersTransforming[_source] == true then
		PlayersTransforming[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~transformer votre petrol')
		PlayersTransforming[_source]=true
		
	end
end)

local function SellC(source, zone)

	if PlayersSelling[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)
		local NombreDeCoppter = xPlayer.getInventoryItem('copper').count
		
		if zone == 'SellCopper' then
			if xPlayer.getInventoryItem('copper').count <= 0 then
				copper = 0
			else
				copper = 1
			end
			
		
			if copper == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_product_sale'))
				return
			elseif xPlayer.getInventoryItem('copper').count <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_ore_sale'))
				copper = 0
				return
			else
				if (copper == 1) then
					SetTimeout(1100, function()
						local argent = math.random(6,8)
						local argentTotal = argent * NombreDeCoppter
						local money = math.random(10,15)
						local moneyTotal = money * NombreDeCoppter
						xPlayer.removeInventoryItem('copper', NombreDeCoppter)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_miner', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
						
							xPlayer.addMoney(argentTotal)
							societyAccount.addMoney(moneyTotal)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_earned') .. argentTotal)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. moneyTotal)
						end
						SellC(source,zone)
					end)
				end
				
			end
		end
	end
end

local function SellI(source, zone)

	if PlayersSelling[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)
		local NombreDeIron = xPlayer.getInventoryItem('iron').count

		if zone == 'SellIron' then
			if xPlayer.getInventoryItem('iron').count <= 0 then
				iron = 0
			else
				iron = 1
			end
			
		
			if iron == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_product_sale'))
				return
			elseif xPlayer.getInventoryItem('iron').count <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_ore_sale'))
				iron = 0
				return
			else
				if (iron == 1) then
					SetTimeout(1100, function()
						local argent = math.random(5,7)
						local argentTotal = argent * NombreDeIron
						local money = math.random(11,16)
						local moneyTotal = money * NombreDeIron
						xPlayer.removeInventoryItem('iron', NombreDeIron)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_miner', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
						
							xPlayer.addMoney(argentTotal)
							societyAccount.addMoney(moneyTotal)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_earned') .. argentTotal)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. moneyTotal)
						end
						SellI(source,zone)
					end)
				end
				
			end
		end
	end
end

local function SellG(source, zone)

	if PlayersSelling[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)
		local NombreDeGold = xPlayer.getInventoryItem('gold').count
		
		if zone == 'SellGold' then
			if xPlayer.getInventoryItem('gold').count <= 0 then
				gold = 0
			else
				gold = 1
			end
			
		
			if gold == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_product_sale'))
				return
			elseif xPlayer.getInventoryItem('gold').count <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_ore_sale'))
				gold = 0
				return
			else
				if (gold == 1) then
					SetTimeout(1100, function()
						local argent = math.random(10,13)
						local argentTotal = argent * NombreDeGold
						local money = math.random(16,20)
						local moneyTotal = money * NombreDeGold
						xPlayer.removeInventoryItem('gold', NombreDeGold)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_miner', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
						
							xPlayer.addMoney(argentTotal)
							societyAccount.addMoney(moneyTotal)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_earned') .. argentTotal)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. moneyTotal)
						end
						SellG(source,zone)
					end)
				end
				
			end
		end
	end
end

local function SellD(source, zone)

	if PlayersSelling[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)
		local NombreDeDiamond = xPlayer.getInventoryItem('diamond').count
		
		if zone == 'SellDiamond' then
			if xPlayer.getInventoryItem('diamond').count <= 0 then
				diamond = 0
			else
				diamond = 1
			end
			
		
			if diamond == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_product_sale'))
				return
			elseif xPlayer.getInventoryItem('diamond').count <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_ore_sale'))
				diamond = 0
				return
			else
				if (diamond == 1) then
					SetTimeout(1100, function()
						local argent = math.random(12,14)
						local argentTotal = argent * NombreDeDiamond
						local money = math.random(20,25)
						local moneyTotal = money * NombreDeDiamond
						xPlayer.removeInventoryItem('diamond', NombreDeDiamond)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_miner', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
						
							xPlayer.addMoney(argentTotal)
							societyAccount.addMoney(moneyTotal)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_earned') .. argentTotal)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. moneyTotal)
						end
						SellD(source,zone)
					end)
				end
				
			end
		end
	end
end

RegisterServerEvent('esx_minerjob:startSell')
AddEventHandler('esx_minerjob:startSell', function(zone)

	local _source = source
	
	if PlayersSelling[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersSelling[_source]=false
	else
		PlayersSelling[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))
		SellC(_source, zone)
	end

end)

AddEventHandler('esx_minerjob:startSell', function(zone)

	local _source = source
	
	if PlayersSelling[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersSelling[_source]=false
	else
		PlayersSelling[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))
		SellI(_source, zone)
	end

end)

AddEventHandler('esx_minerjob:startSell', function(zone)

	local _source = source
	
	if PlayersSelling[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersSelling[_source]=false
	else
		PlayersSelling[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))
		SellG(_source, zone)
	end

end)

AddEventHandler('esx_minerjob:startSell', function(zone)

	local _source = source
	
	if PlayersSelling[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersSelling[_source]=false
	else
		PlayersSelling[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))
		SellD(_source, zone)
	end

end)

RegisterServerEvent('esx_minerjob:stopSell')
AddEventHandler('esx_minerjob:stopSell', function()

	local _source = source
	
	if PlayersSelling[_source] == true then
		PlayersSelling[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~vendre')
		PlayersSelling[_source]=true
	end

end)

RegisterServerEvent('esx_minerjob:getStockItem')
AddEventHandler('esx_minerjob:getStockItem', function(itemName, count)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_miner', function(inventory)

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

ESX.RegisterServerCallback('esx_minerjob:getStockItems', function(source, cb)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_miner', function(inventory)
		cb(inventory.items)
	end)

end)

RegisterServerEvent('esx_minerjob:putStockItems')
AddEventHandler('esx_minerjob:putStockItems', function(itemName, count)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_miner', function(inventory)

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

ESX.RegisterServerCallback('esx_minerjob:getPlayerInventory', function(source, cb)

	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({
		items      = items
	})

end)
