ESX 						   = nil
--local CopsConnected       	   = 0
local PlayersHarvestingCoke    = {}
local PlayersTransformingCoke  = {}
local PlayersSellingCoke       = {}
local PlayersHarvestingMeth    = {}
local PlayersTransformingMeth  = {}
local PlayersSellingMeth       = {}
local PlayersHarvestingWeed    = {}
local PlayersTransformingWeed  = {}
local PlayersSellingWeed       = {}
local PlayersHarvestingOpium   = {}
local PlayersTransformingOpium = {}
local PlayersSellingOpium      = {}
local PlayersHarvestingLsd     = {}
local PlayersTransformingLsd   = {}
local PlayersSellingLsd        = {}
local temps = 4800
local WeedLevel = {}

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

--coke
local function HarvestCoke(source)
	--CountCops()
	--wait(50)

	if CopsConnected < Config.RequiredCopsCoke then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsCoke))
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingCoke[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local coke = xPlayer.getInventoryItem('coke')

			if coke.limit ~= -1 and coke.count >= coke.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_coke'))
			else
				xPlayer.addInventoryItem('coke', 1)
				HarvestCoke(source)
			end

		end
	end)
end

RegisterServerEvent('drogues:RecolteCoke')
AddEventHandler('drogues:RecolteCoke', function()

	local _source = source

	PlayersHarvestingCoke[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestCoke(_source)

end)

RegisterServerEvent('esx_drugs:stopHarvestCoke')
AddEventHandler('esx_drugs:stopHarvestCoke', function()

	local _source = source

	PlayersHarvestingCoke[_source] = false

end)

local function TransformCoke(source)

	if CopsConnected < Config.RequiredCopsCoke then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsCoke))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingCoke[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local cokeQuantity = xPlayer.getInventoryItem('coke').count
			local poochQuantity = xPlayer.getInventoryItem('coke_pooch').count

			if poochQuantity > 35 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif cokeQuantity < 5 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_coke'))
			else
				xPlayer.removeInventoryItem('coke', 5)
				xPlayer.addInventoryItem('coke_pooch', 1)
			
				TransformCoke(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startTransformCoke')
AddEventHandler('esx_drugs:startTransformCoke', function()

	local _source = source

	PlayersTransformingCoke[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformCoke(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformCoke')
AddEventHandler('esx_drugs:stopTransformCoke', function()

	local _source = source

	PlayersTransformingCoke[_source] = false

end)

--PrixCoke = math.random(55, 65)
--PrixPolicierCoke = CopsConnected * 13

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		PrixPolicierCoke = CopsConnected * 13
		local r = math.random(65, 75) + PrixPolicierCoke
		PrixCoke = r
	end
end)

local function SellCoke(source)
	--CountCops()
	if CopsConnected < Config.RequiredCopsCoke then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsCoke))
		return
	end

	SetTimeout(Config.TimeToSell, function()

		if PlayersSellingCoke[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local poochQuantity = xPlayer.getInventoryItem('coke_pooch').count
			local prixCokeFinal = PrixCoke * poochQuantity

			if poochQuantity == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_pouches_sale'))
			else
				xPlayer.removeInventoryItem('coke_pooch', poochQuantity)
				if CopsConnected == 0 then
					xPlayer.addAccountMoney('black_money', prixCokeFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' de coke~w~ pour '..prixCokeFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente coke : '..PrixCoke..'$^0')
				elseif CopsConnected == 1 then
					xPlayer.addAccountMoney('black_money', PrixprixCokeFinalCoke)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' de coke~w~ pour '..prixCokeFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente coke : '..PrixCoke..'$^0')
				elseif CopsConnected == 2 then
					xPlayer.addAccountMoney('black_money', prixCokeFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' de coke~w~ pour '..prixCokeFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente coke : '..PrixCoke..'$^0')
				elseif CopsConnected == 3 then
					xPlayer.addAccountMoney('black_money', prixCokeFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' de coke~w~ pour '..prixCokeFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente coke : '..PrixCoke..'$^0')
				elseif CopsConnected == 4 then
					xPlayer.addAccountMoney('black_money', prixCokeFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' de coke~w~ pour '..prixCokeFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente coke : '..PrixCoke..'$^0')
				elseif CopsConnected >= 5 then
					xPlayer.addAccountMoney('black_money', prixCokeFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' de coke~w~ pour '..prixCokeFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente coke : '..PrixCoke..'$^0')
				elseif CopsConnected >= 6 then
					xPlayer.addAccountMoney('black_money', prixCokeFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' de coke~w~ pour '..prixCokeFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente coke : '..PrixCoke..'$^0')
				elseif CopsConnected >= 7 then
					xPlayer.addAccountMoney('black_money', prixCokeFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' de coke~w~ pour '..prixCokeFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente coke : '..PrixCoke..'$^0')
				end
				
				SellCoke(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startSellCoke')
AddEventHandler('esx_drugs:startSellCoke', function()

	local _source = source

	PlayersSellingCoke[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))

	SellCoke(_source)

end)

RegisterServerEvent('esx_drugs:stopSellCoke')
AddEventHandler('esx_drugs:stopSellCoke', function()

	local _source = source

	PlayersSellingCoke[_source] = false

end)

--meth
local function HarvestMeth(source)

	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsMeth))
		return
	end
	
	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingMeth[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local meth = xPlayer.getInventoryItem('meth')

			if meth.limit ~= -1 and meth.count >= meth.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_meth'))
			else
				xPlayer.addInventoryItem('meth', 1)
				HarvestMeth(source)
			end

		end
	end)
end

RegisterServerEvent('drogues:RecolteMeth')
AddEventHandler('drogues:RecolteMeth', function()

	local _source = source

	PlayersHarvestingMeth[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestMeth(_source)

end)

RegisterServerEvent('esx_drugs:stopHarvestMeth')
AddEventHandler('esx_drugs:stopHarvestMeth', function()

	local _source = source

	PlayersHarvestingMeth[_source] = false

end)

local function TransformMeth(source)

	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsMeth))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingMeth[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local methQuantity = xPlayer.getInventoryItem('meth').count
			local poochQuantity = xPlayer.getInventoryItem('meth_pooch').count

			if poochQuantity > 35 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif methQuantity < 5 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_meth'))
			else
				xPlayer.removeInventoryItem('meth', 5)
				xPlayer.addInventoryItem('meth_pooch', 1)
				
				TransformMeth(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startTransformMeth')
AddEventHandler('esx_drugs:startTransformMeth', function()

	local _source = source

	PlayersTransformingMeth[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformMeth(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformMeth')
AddEventHandler('esx_drugs:stopTransformMeth', function()

	local _source = source

	PlayersTransformingMeth[_source] = false

end)

--PrixMeth = math.random(65, 75)
--PrixPolicierMeth = CopsConnected * 15

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		PrixPolicierMeth = CopsConnected * 15
		local r = math.random(85, 95) + PrixPolicierMeth
		PrixMeth = r
	end
end)

local function SellMeth(source)
	--CountCops()
	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsMeth))
		return
	end

	SetTimeout(Config.TimeToSell, function()

		if PlayersSellingMeth[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local poochQuantity = xPlayer.getInventoryItem('meth_pooch').count
			local prixMethFinal = PrixMeth * poochQuantity

			if poochQuantity == 0 then
				TriggerClientEvent('esx:showNotification', _source, _U('no_pouches_sale'))
			else
				xPlayer.removeInventoryItem('meth_pooch', poochQuantity)
				if CopsConnected >= 0 then
					xPlayer.addAccountMoney('black_money', prixMethFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' de meth~w~ pour '..prixMethFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente Meth : '..PrixMeth..'$^0')
				elseif CopsConnected >= 1 then
					xPlayer.addAccountMoney('black_money', prixMethFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' de meth~w~ pour '..prixMethFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente Meth : '..PrixMeth..'$^0')
				elseif CopsConnected >= 2 then
					xPlayer.addAccountMoney('black_money', prixMethFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' de meth~w~ pour '..prixMethFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente Meth : '..PrixMeth..'$^0')
				elseif CopsConnected >= 3 then
					xPlayer.addAccountMoney('black_money', prixMethFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' de meth~w~ pour '..prixMethFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente Meth : '..PrixMeth..'$^0')
				elseif CopsConnected >= 4 then
					xPlayer.addAccountMoney('black_money', prixMethFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' de meth~w~ pour '..prixMethFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente Meth : '..PrixMeth..'$^0')
				elseif CopsConnected >= 5 then
					xPlayer.addAccountMoney('black_money', prixMethFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' de meth~w~ pour '..prixMethFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente Meth : '..PrixMeth..'$^0')
				elseif CopsConnected >= 6 then
					xPlayer.addAccountMoney('black_money', prixMethFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' de meth~w~ pour '..prixMethFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente Meth : '..PrixMeth..'$^0')
				end
				
				SellMeth(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startSellMeth')
AddEventHandler('esx_drugs:startSellMeth', function()

	local _source = source

	PlayersSellingMeth[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))

	SellMeth(_source)

end)

RegisterServerEvent('esx_drugs:stopSellMeth')
AddEventHandler('esx_drugs:stopSellMeth', function()

	local _source = source

	PlayersSellingMeth[_source] = false

end)

--weed
local function HarvestWeed(source, niveau)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed))
		return
	end

	if niveau == 8 then
		temps = 1100
	elseif niveau == 7 then
		temps = 1400
	elseif niveau == 6 then
		temps = 1700
	elseif niveau == 5 then
		temps = 2100
	elseif niveau == 4 then
		temps = 2400
	elseif niveau == 3 then
		temps = 3400
	elseif niveau == 2 then
		temps = 3800
	elseif niveau == 1 then
		temps = 4400
	else
		temps = 4800
	end
	SetTimeout(temps, function()

		if PlayersHarvestingWeed[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local weed = xPlayer.getInventoryItem('weed')

			if weed.limit ~= -1 and weed.count >= weed.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_weed'))
			else
				xPlayer.addInventoryItem('weed', 1)
				HarvestWeed(source, WeedLevel[_source])
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startHarvestWeed')
AddEventHandler('esx_drugs:startHarvestWeed', function(niveau)

	local _source = source
	local _niveau = niveau
	WeedLevel[_source] = _niveau
	print(WeedLevel[_source])

	PlayersHarvestingWeed[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestWeed(_source, WeedLevel[_source])

end)

RegisterServerEvent('esx_drugs:stopHarvestWeed')
AddEventHandler('esx_drugs:stopHarvestWeed', function()

	local _source = source

	PlayersHarvestingWeed[_source] = false

end)

local function TransformWeed(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingWeed[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)
			local weedQuantity = xPlayer.getInventoryItem('weed').count
			local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

			if poochQuantity > 35 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif weedQuantity < 5 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_weed'))
			else
				xPlayer.removeInventoryItem('weed', 5)
				xPlayer.addInventoryItem('weed_pooch', 1)
				
				TransformWeed(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startTransformWeed')
AddEventHandler('esx_drugs:startTransformWeed', function()

	local _source = source

	PlayersTransformingWeed[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformWeed(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformWeed')
AddEventHandler('esx_drugs:stopTransformWeed', function()

	local _source = source

	PlayersTransformingWeed[_source] = false

end)

--PrixWeed = math.random(01, 20)
--PrixPolicierWeed = CopsConnected * 6

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		PrixPolicierWeed = CopsConnected * 16
		local r = math.random(49, 59) + PrixPolicierWeed
		PrixWeed = r
	end
end)

local function SellWeed(source)
	--CountCops()
	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed))
		return
	end

	SetTimeout(Config.TimeToSell, function()

		if PlayersSellingWeed[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)

			local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count
			local prixWeedFinal = PrixWeed * poochQuantity

			if poochQuantity == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_pouches_sale'))
			else
				xPlayer.removeInventoryItem('weed_pooch', poochQuantity)
				if CopsConnected >= 0 then
					xPlayer.addMoney(prixWeedFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' de weed~w~ pour '..prixWeedFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente Weed : '..PrixWeed..'$^0')
				elseif CopsConnected >= 1 then
					xPlayer.addMoney(prixWeedFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' de weed~w~ pour '..prixWeedFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente Weed : '..PrixWeed..'$^0')
				elseif CopsConnected >= 2 then
					xPlayer.addMoney(prixWeedFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' de weed~w~ pour '..prixWeedFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente Weed : '..PrixWeed..'$^0')
				elseif CopsConnected >= 3 then
					xPlayer.addMoney(prixWeedFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' de weed~w~ pour '..prixWeedFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente Weed : '..PrixWeed..'$^0')
				elseif CopsConnected >= 4 then
					xPlayer.addMoney(prixWeedFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' de weed~w~ pour '..prixWeedFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente Weed : '..PrixWeed..'$^0')
				elseif CopsConnected >= 5 then
					xPlayer.addMoney(prixWeedFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' de weed~w~ pour '..prixWeedFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente Weed : '..PrixWeed..'$^0')
				end
				
				SellWeed(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startSellWeed')
AddEventHandler('esx_drugs:startSellWeed', function()

	local _source = source

	PlayersSellingWeed[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))

	SellWeed(_source)

end)

RegisterServerEvent('esx_drugs:stopSellWeed')
AddEventHandler('esx_drugs:stopSellWeed', function()

	local _source = source

	PlayersSellingWeed[_source] = false

end)


--opium

local function HarvestOpium(source)

	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsOpium))
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingOpium[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local opium = xPlayer.getInventoryItem('opium')

			if opium.limit ~= -1 and opium.count >= opium.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_opium'))
			else
				xPlayer.addInventoryItem('opium', 1)
				HarvestOpium(source)
			end

		end
	end)
end

RegisterServerEvent('drogues:RecolteOpium')
AddEventHandler('drogues:RecolteOpium', function()

	local _source = source

	PlayersHarvestingOpium[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestOpium(_source)

end)

RegisterServerEvent('esx_drugs:stopHarvestOpium')
AddEventHandler('esx_drugs:stopHarvestOpium', function()

	local _source = source

	PlayersHarvestingOpium[_source] = false

end)

local function TransformOpium(source)
	--CountCops()
	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsOpium))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingOpium[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)

			local opiumQuantity = xPlayer.getInventoryItem('opium').count
			local poochQuantity = xPlayer.getInventoryItem('opium_pooch').count

			if poochQuantity > 35 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif opiumQuantity < 5 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_opium'))
			else
				xPlayer.removeInventoryItem('opium', 5)
				xPlayer.addInventoryItem('opium_pooch', 1)
			
				TransformOpium(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startTransformOpium')
AddEventHandler('esx_drugs:startTransformOpium', function()

	local _source = source

	PlayersTransformingOpium[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformOpium(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformOpium')
AddEventHandler('esx_drugs:stopTransformOpium', function()

	local _source = source

	PlayersTransformingOpium[_source] = false

end)

--PrixOpium = math.random(85, 95)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		PrixPolicierOpium = CopsConnected * 25
		local r = math.random(105, 115) + PrixPolicierOpium
		PrixOpium = r
	end
end)

local function SellOpium(source)

	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsOpium))
		return
	end

	SetTimeout(Config.TimeToSell, function()

		if PlayersSellingOpium[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)

			local poochQuantity = xPlayer.getInventoryItem('opium_pooch').count
			local prixOpiumFinal = PrixOpium * poochQuantity

			if poochQuantity == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_pouches_sale'))
			else
				xPlayer.removeInventoryItem('opium_pooch', poochQuantity)
				if CopsConnected >= 0 then
					xPlayer.addAccountMoney('black_money', prixOpiumFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' d\'opium~w~ pour '..prixOpiumFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente Opium : '..PrixOpium..'$^0')
				elseif CopsConnected >= 1 then
					xPlayer.addAccountMoney('black_money', prixOpiumFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' d\'opium~w~ pour '..prixOpiumFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente Opium : '..PrixOpium..'$^0')
				elseif CopsConnected >= 2 then
					xPlayer.addAccountMoney('black_money', prixOpiumFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' d\'opium~w~ pour '..prixOpiumFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente Opium : '..PrixOpium..'$^0')
				elseif CopsConnected >= 3 then
					xPlayer.addAccountMoney('black_money', prixOpiumFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' d\'opium~w~ pour '..prixOpiumFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente Opium : '..PrixOpium..'$^0')
				elseif CopsConnected >= 4 then
					xPlayer.addAccountMoney('black_money', prixOpiumFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' d\'opium~w~ pour '..prixOpiumFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente Opium : '..PrixOpium..'$^0')
				elseif CopsConnected >= 5 then
					xPlayer.addAccountMoney('black_money', prixOpiumFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' d\'opium~w~ pour '..prixOpiumFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente Opium : '..PrixOpium..'$^0')
				elseif CopsConnected >= 6 then
					xPlayer.addAccountMoney('black_money', prixOpiumFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' d\'opium~w~ pour '..prixOpiumFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente Opium : '..PrixOpium..'$^0')
				elseif CopsConnected >= 7 then
					xPlayer.addAccountMoney('black_money', prixOpiumFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' d\'opium~w~ pour '..prixOpiumFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente Opium : '..PrixOpium..'$^0')
				elseif CopsConnected >= 8 then
					xPlayer.addAccountMoney('black_money', prixOpiumFinal)
					TriggerClientEvent('esx:showNotification', source,'Tu à vendu ~g~'..poochQuantity..' d\'opium~w~ pour '..prixOpiumFinal..'$')
					--print('^0Nombre de policier : ^2'..CopsConnected..'^0 | Prix de de vente Opium : '..PrixOpium..'$^0')
				end
				
				SellOpium(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startSellOpium')
AddEventHandler('esx_drugs:startSellOpium', function()

	local _source = source

	PlayersSellingOpium[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))

	SellOpium(_source)

end)

RegisterServerEvent('esx_drugs:stopSellOpium')
AddEventHandler('esx_drugs:stopSellOpium', function()

	local _source = source

	PlayersSellingOpium[_source] = false

end)


-- lsd

local function HarvestLsd(source)

	if CopsConnected < Config.RequiredCopsLsd then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsLsd))
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingLsd[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local lsd = xPlayer.getInventoryItem('lsd')

			if lsd.limit ~= -1 and lsd.count >= lsd.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_lsd'))
			else
				xPlayer.addInventoryItem('lsd', 1)
				HarvestLsd(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startHarvestLsd')
AddEventHandler('esx_drugs:startHarvestLsd', function()

	local _source = source

	PlayersHarvestingLsd[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestLsd(_source)

end)

RegisterServerEvent('esx_drugs:stopHarvestLsd')
AddEventHandler('esx_drugs:stopHarvestLsd', function()

	local _source = source

	PlayersHarvestingLsd[_source] = false

end)

local function TransformLsd(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsLsd))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingLsd[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)
			local lsdQuantity = xPlayer.getInventoryItem('lsd').count
			local poochQuantity = xPlayer.getInventoryItem('lsd_pooch').count

			if poochQuantity > 35 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif lsdQuantity < 5 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_lsd'))
			else
				xPlayer.removeInventoryItem('lsd', 5)
				xPlayer.addInventoryItem('lsd_pooch', 1)
				
				TransformLsd(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startTransformLsd')
AddEventHandler('esx_drugs:startTransformLsd', function()

	local _source = source

	PlayersTransformingLsd[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformLsd(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformLsd')
AddEventHandler('esx_drugs:stopTransformLsd', function()

	local _source = source

	PlayersTransformingLsd[_source] = false

end)

local function SellLsd(source)

	if CopsConnected < Config.RequiredCopsLsd then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsLsd))
		return
	end

	SetTimeout(Config.TimeToSell, function()

		if PlayersSellingLsd[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)

			local poochQuantity = xPlayer.getInventoryItem('lsd_pooch').count

			if poochQuantity == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_pouches_sale'))
			else
				xPlayer.removeInventoryItem('lsd_pooch', 1)
				if CopsConnected == 0 then
					xPlayer.addAccountMoney('black_money', 10)
					TriggerClientEvent('esx:showNotification', source, _U('sold_one_lsd'))
				elseif CopsConnected == 1 then
					xPlayer.addAccountMoney('black_money', 0)
					TriggerClientEvent('esx:showNotification', source, _U('sold_one_lsd'))
				elseif CopsConnected == 2 then
					xPlayer.addAccountMoney('black_money', 0)
					TriggerClientEvent('esx:showNotification', source, _U('sold_one_lsd'))
				elseif CopsConnected == 3 then
					xPlayer.addAccountMoney('black_money', 0)
					TriggerClientEvent('esx:showNotification', source, _U('sold_one_lsd'))
				elseif CopsConnected >= 4 then
					xPlayer.addAccountMoney('black_money', 0)
					TriggerClientEvent('esx:showNotification', source, _U('sold_one_lsd'))
				elseif CopsConnected >= 5 then
					xPlayer.addAccountMoney('black_money', 112)
					TriggerClientEvent('esx:showNotification', source, _U('sold_one_lsd'))
				elseif CopsConnected == 6 then
					xPlayer.addAccountMoney('black_money', 119)
					TriggerClientEvent('esx:showNotification', source, _U('sold_one_lsd'))
				elseif CopsConnected == 7 then
					xPlayer.addAccountMoney('black_money', 126)
					TriggerClientEvent('esx:showNotification', source, _U('sold_one_lsd'))
				elseif CopsConnected == 8 then
					xPlayer.addAccountMoney('black_money', 133)
					TriggerClientEvent('esx:showNotification', source, _U('sold_one_lsd'))
				elseif CopsConnected >= 9 then
					xPlayer.addAccountMoney('black_money', 140)
					TriggerClientEvent('esx:showNotification', source, _U('sold_one_lsd'))
				elseif CopsConnected >= 10 then
					xPlayer.addAccountMoney('black_money', 147)
					TriggerClientEvent('esx:showNotification', source, _U('sold_one_lsd'))
				end
				
				SellLsd(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startSellLsd')
AddEventHandler('esx_drugs:startSellLsd', function()

	local _source = source

	PlayersSellingLsd[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))

	SellLsd(_source)

end)

RegisterServerEvent('esx_drugs:stopSellLsd')
AddEventHandler('esx_drugs:stopSellLsd', function()

	local _source = source

	PlayersSellingLsd[_source] = false

end)

RegisterServerEvent('esx_drugs:GetUserInventory')
AddEventHandler('esx_drugs:GetUserInventory', function(currentZone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('esx_drugs:ReturnInventory', 
		_source, 
		xPlayer.getInventoryItem('coke').count, 
		xPlayer.getInventoryItem('coke_pooch').count,
		xPlayer.getInventoryItem('meth').count, 
		xPlayer.getInventoryItem('meth_pooch').count, 
		xPlayer.getInventoryItem('weed').count, 
		xPlayer.getInventoryItem('weed_pooch').count, 
		xPlayer.getInventoryItem('opium').count, 
		xPlayer.getInventoryItem('opium_pooch').count,
		xPlayer.getInventoryItem('lsd').count, 
		xPlayer.getInventoryItem('lsd_pooch').count,
		xPlayer.job.name, 
		currentZone
	)
end)

ESX.RegisterUsableItem('weed', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('weed', 1)

	TriggerClientEvent('esx_drugs:onPot', _source)
	TriggerClientEvent('esx:showNotification', _source, _U('used_one_weed'))
end)


-- Amélioration weed


RegisterServerEvent('esx_drugs:AmeWeed1')
AddEventHandler('esx_drugs:AmeWeed1', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

	if poochQuantity < 36 then
		TriggerClientEvent('esx:showNotification', _source, '❌ Pas assez de pochon pour améliorer ( 36 pochon demandé )')
	else
		xPlayer.removeInventoryItem('weed_pooch', 36)
		TriggerClientEvent('esx:showNotification', _source, '✅ Amélioration éffectué, vous récoltez maintenant plus rapidement.')
		TriggerEvent('esx_license:addLicense', _source, 'AmeliorationWeed1', function()
			TriggerEvent('esx_license:getLicenses', _source, function(licenses)
				TriggerClientEvent('esx_drugs:loadLicenses', _source, licenses)
			end)
		end)
	end
end)

RegisterServerEvent('esx_drugs:AmeWeed2')
AddEventHandler('esx_drugs:AmeWeed2', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local argentJoueur = xPlayer.get("money")
	local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

	if poochQuantity < 36 then
		TriggerClientEvent('esx:showNotification', _source, "❌ Pas assez de pochon pour améliorer ( 36 pochon )")
	elseif argentJoueur < 10000 then
		TriggerClientEvent('esx:showNotification', _source, "❌ Pas assez d'argent pour améliorer ( 10 000$ )")
	else
		xPlayer.removeInventoryItem('weed_pooch', 36)
		xPlayer.removeMoney(10000)
		TriggerClientEvent('esx:showNotification', _source, '✅ Amélioration éffectué, vous récoltez maintenant plus rapidement.')
		TriggerEvent('esx_license:addLicense', _source, 'AmeliorationWeed2', function()
			TriggerEvent('esx_license:getLicenses', _source, function(licenses)
				TriggerClientEvent('esx_drugs:loadLicenses', _source, licenses)
			end)
		end)
	end
end)

RegisterServerEvent('esx_drugs:AmeWeed3')
AddEventHandler('esx_drugs:AmeWeed3', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local argentJoueur = xPlayer.get("money")
	local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

	if poochQuantity < 36 then
		TriggerClientEvent('esx:showNotification', _source, "❌ Pas assez de pochon pour améliorer ( 36 pochon )")
	elseif argentJoueur < 25000 then
		TriggerClientEvent('esx:showNotification', _source, "❌ Pas assez d'argent pour améliorer ( 25 000$ )")
	else
		xPlayer.removeInventoryItem('weed_pooch', 36)
		xPlayer.removeMoney(25000)
		TriggerClientEvent('esx:showNotification', _source, '✅ Amélioration éffectué, vous récoltez maintenant plus rapidement.')
		TriggerEvent('esx_license:addLicense', _source, 'AmeliorationWeed3', function()
			TriggerEvent('esx_license:getLicenses', _source, function(licenses)
				TriggerClientEvent('esx_drugs:loadLicenses', _source, licenses)
			end)
		end)
	end
end)

RegisterServerEvent('esx_drugs:AmeWeed4')
AddEventHandler('esx_drugs:AmeWeed4', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local argentJoueur = xPlayer.get("money")
	local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

	if poochQuantity < 36 then
		TriggerClientEvent('esx:showNotification', _source, "❌ Pas assez de pochon pour améliorer ( 36 pochon )")
	elseif argentJoueur < 40000 then
		TriggerClientEvent('esx:showNotification', _source, "❌ Pas assez d'argent pour améliorer ( 40 000$ )")
	else
		xPlayer.removeInventoryItem('weed_pooch', 36)
		xPlayer.removeMoney(40000)
		TriggerClientEvent('esx:showNotification', _source, '✅ Amélioration éffectué, vous récoltez maintenant plus rapidement.')
		TriggerEvent('esx_license:addLicense', _source, 'AmeliorationWeed4', function()
			TriggerEvent('esx_license:getLicenses', _source, function(licenses)
				TriggerClientEvent('esx_drugs:loadLicenses', _source, licenses)
			end)
		end)
	end
end)


RegisterServerEvent('esx_drugs:AmeWeed5')
AddEventHandler('esx_drugs:AmeWeed5', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local argentJoueur = xPlayer.get("money")
	local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

	if poochQuantity < 36 then
		TriggerClientEvent('esx:showNotification', _source, "❌ Pas assez de pochon pour améliorer ( 36 pochon )")
	elseif argentJoueur < 60000 then
		TriggerClientEvent('esx:showNotification', _source, "❌ Pas assez d'argent pour améliorer ( 60 000$ )")
	else
		xPlayer.removeInventoryItem('weed_pooch', 36)
		xPlayer.removeMoney(60000)
		TriggerClientEvent('esx:showNotification', _source, '✅ Amélioration éffectué, vous récoltez maintenant plus rapidement.')
		TriggerEvent('esx_license:addLicense', _source, 'AmeliorationWeed5', function()
			TriggerEvent('esx_license:getLicenses', _source, function(licenses)
				TriggerClientEvent('esx_drugs:loadLicenses', _source, licenses)
			end)
		end)
	end
end)


RegisterServerEvent('esx_drugs:AmeWeed6')
AddEventHandler('esx_drugs:AmeWeed6', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local argentJoueur = xPlayer.get("money")
	local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

	if poochQuantity < 36 then
		TriggerClientEvent('esx:showNotification', _source, "❌ Pas assez de pochon pour améliorer ( 36 pochon )")
	elseif argentJoueur < 80000 then
		TriggerClientEvent('esx:showNotification', _source, "❌ Pas assez d'argent pour améliorer ( 80 000$ )")
	else
		xPlayer.removeInventoryItem('weed_pooch', 36)
		xPlayer.removeMoney(80000)
		TriggerClientEvent('esx:showNotification', _source, '✅ Amélioration éffectué, vous récoltez maintenant plus rapidement.')
		TriggerEvent('esx_license:addLicense', _source, 'AmeliorationWeed6', function()
			TriggerEvent('esx_license:getLicenses', _source, function(licenses)
				TriggerClientEvent('esx_drugs:loadLicenses', _source, licenses)
			end)
		end)
	end
end)

RegisterServerEvent('esx_drugs:AmeWeed7')
AddEventHandler('esx_drugs:AmeWeed7', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local argentJoueur = xPlayer.get("money")
	local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

	if poochQuantity < 36 then
		TriggerClientEvent('esx:showNotification', _source, "❌ Pas assez de pochon pour améliorer ( 36 pochon )")
	elseif argentJoueur < 100000 then
		TriggerClientEvent('esx:showNotification', _source, "❌ Pas assez d'argent pour améliorer ( 100 000$ )")
	else
		xPlayer.removeInventoryItem('weed_pooch', 36)
		xPlayer.removeMoney(100000)
		TriggerClientEvent('esx:showNotification', _source, '✅ Amélioration éffectué, vous récoltez maintenant plus rapidement.')
		TriggerEvent('esx_license:addLicense', _source, 'AmeliorationWeed7', function()
			TriggerEvent('esx_license:getLicenses', _source, function(licenses)
				TriggerClientEvent('esx_drugs:loadLicenses', _source, licenses)
			end)
		end)
	end
end)

-- Achats du permis weed

RegisterServerEvent('esx_drugs:PermisWeed')
AddEventHandler('esx_drugs:PermisWeed', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local argentJoueur = xPlayer.get("money")

	if argentJoueur < 25000 then
		TriggerClientEvent('esx:showNotification', _source, "❌ Pas assez d'argent pour acheter le permis ( 25 000$ )")
	else
		xPlayer.removeMoney(10000)
		TriggerClientEvent('esx:showNotification', _source, '✅ Permis Weed acheter, vous récoltez maintenant récolter.')
		TriggerEvent('esx_license:addLicense', _source, 'PermisWeed', function()
			TriggerEvent('esx_license:getLicenses', _source, function(licenses)
				TriggerClientEvent('esx_drugs:loadLicenses', _source, licenses)
			end)
		end)
	end
end)




RegisterServerEvent('esx_drugs:ChargementLicenses')
AddEventHandler('esx_drugs:ChargementLicenses', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerEvent('esx_license:getLicenses', _source, function(licenses)
		TriggerClientEvent('esx_drugs:loadLicenses', _source, licenses)
	end)
end)