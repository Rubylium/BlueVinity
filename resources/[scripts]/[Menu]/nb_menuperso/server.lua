ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('NB:getUsergroup', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  local group = xPlayer.getGroup()
  cb(group)
end)

function getMaximumGrade(jobname)
    local result = MySQL.Sync.fetchAll("SELECT * FROM job_grades WHERE job_name=@jobname  ORDER BY `grade` DESC ;", {
        ['@jobname'] = jobname
    })
    if result[1] ~= nil then
        return result[1].grade
    end
    return nil
end

-------------------------------------------------------------------------------Admin Menu

RegisterServerEvent("Admin2Menu:giveCash")
AddEventHandler("Admin2Menu:giveCash", function(money)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total = money
	
	xPlayer.addMoney((total))
	local item = ' $ d\'argent !'
	local message = 'Tu t\'est GIVE '
	TriggerClientEvent('esx:showNotification', _source, message.." "..total.." "..item)

end)

RegisterServerEvent("Admin2Menu:giveBank")
AddEventHandler("Admin2Menu:giveBank", function(money)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total = money
	
	xPlayer.addAccountMoney('bank', total)
	local item = ' $ en banque.'
	local message = 'Tu t\'es octroyé '
	TriggerClientEvent('esx:showNotification', _source, message.." "..total.." "..item)

end)

RegisterServerEvent("Admin2Menu:giveDirtyMoney")
AddEventHandler("Admin2Menu:giveDirtyMoney", function(money)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total = money
	
	xPlayer.addAccountMoney('black_money', total)
	local item = ' $ d\'argent sale.'
	local message = 'Tu t\'es octroyé '
	TriggerClientEvent('esx:showNotification', _source, message.." "..total.." "..item)

end)

RegisterServerEvent("Admin2Menu:MessageResellerCoke")
AddEventHandler("Admin2Menu:MessageResellerCoke", function(money, x, y, z)

	local message = money
	print(message)
	local xPlayers	= ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('Admin2Menu:MessageResellerCoke2Police', xPlayers[i], message, x, y, z)
		else
			TriggerClientEvent('Admin2Menu:MessageResellerCoke2', xPlayers[i], message, x, y, z)
		end
	end
	

end)

RegisterServerEvent("Admin2Menu:MessageResellerWeed")
AddEventHandler("Admin2Menu:MessageResellerWeed", function(money, x, y, z)

	local message = money
	print(message)
	local xPlayers	= ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('Admin2Menu:MessageResellerWeed2Police', xPlayers[i], message, x, y, z)
		else
			TriggerClientEvent('Admin2Menu:MessageResellerWeed2', xPlayers[i], message, x, y, z)
		end
	end
	

end)

RegisterServerEvent("Admin2Menu:MessageResellerOpium")
AddEventHandler("Admin2Menu:MessageResellerOpium", function(money, x, y, z)

	local message = money
	print(message)
	local xPlayers	= ESX.GetPlayers()
	

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('Admin2Menu:MessageResellerOpium2Police', xPlayers[i], message, x, y, z)
		else
			TriggerClientEvent('Admin2Menu:MessageResellerOpium2', xPlayers[i], message, x, y, z)
		end
	end
	

end)

RegisterServerEvent("Admin2Menu:MessageResellerPack")
AddEventHandler("Admin2Menu:MessageResellerPack", function(money, x, y, z)

	local message = money
	print(message)
	local xPlayers	= ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('Admin2Menu:MessageResellerPack2Police', xPlayers[i], message, x, y, z)
		else
			TriggerClientEvent('Admin2Menu:MessageResellerPack2', xPlayers[i], message, x, y, z)
		end
	end
	

end)

RegisterServerEvent("Admin2Menu:MessageResellerFin")
AddEventHandler("Admin2Menu:MessageResellerFin", function(money, x, y, z)

	local message = money
	print(message)
	local xPlayers	= ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		TriggerClientEvent('Admin2Menu:MessageResellerFin2', xPlayers[i], message, x, y, z)
	end
	

end)

RegisterServerEvent("Admin2Menu:MessageResellerPolice")
AddEventHandler("Admin2Menu:MessageResellerPolice", function(money, x, y, z)

	local message = money
	print(message)
	local xPlayers	= ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		TriggerClientEvent('Admin2Menu:MessageResellerpolice2', xPlayers[i], message, x, y, z)
	end
	

end)

RegisterServerEvent("Admin2Menu:MessageResellerArme")
AddEventHandler("Admin2Menu:MessageResellerArme", function(money, x, y, z)

	local message = money
	print(message)
	local xPlayers	= ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('Admin2Menu:MessageResellerArme2Police', xPlayers[i], message, x, y, z)
		else
			TriggerClientEvent('Admin2Menu:MessageResellerArme2', xPlayers[i], message, x, y, z)
		end
	end
	

end)

RegisterServerEvent("Admin2Menu:MessageResellerVoiture")
AddEventHandler("Admin2Menu:MessageResellerVoiture", function(money, x, y, z)

	local message = money
	print(message)
	local xPlayers	= ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('Admin2Menu:MessageResellerVoiture2Police', xPlayers[i], message, x, y, z)
		else
			TriggerClientEvent('Admin2Menu:MessageResellerVoiture2', xPlayers[i], message, x, y, z)
		end
	end
	

end)

-------------------------------------------------------------------------------Grade Menu
RegisterServerEvent('NB:promouvoirplayer')
AddEventHandler('NB:promouvoirplayer', function(target)

	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local maximumgrade = tonumber(getMaximumGrade(sourceXPlayer.job.name)) -1 

	if(targetXPlayer.job.grade == maximumgrade)then
		TriggerClientEvent('esx:showNotification', _source, "Vous devez demander une autorisation du ~r~Gouvernement~w~.")
	else
		if(sourceXPlayer.job.name == targetXPlayer.job.name)then

			local grade = tonumber(targetXPlayer.job.grade) + 1 
			local job = targetXPlayer.job.name

			targetXPlayer.setJob(job, grade)

			TriggerClientEvent('esx:showNotification', _source, "Vous avez ~g~promu "..targetXPlayer.name.."~w~.")
			TriggerClientEvent('esx:showNotification', target,  "Vous avez été ~g~promu par ".. sourceXPlayer.name.."~w~.")		

		else
			TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")

		end

	end 
		
end)

RegisterServerEvent('NB:destituerplayer')
AddEventHandler('NB:destituerplayer', function(target)

	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if(targetXPlayer.job.grade == 0)then
		TriggerClientEvent('esx:showNotification', _source, "Vous ne pouvez pas plus ~r~rétrograder~w~ davantage.")
	else
		if(sourceXPlayer.job.name == targetXPlayer.job.name)then

			local grade = tonumber(targetXPlayer.job.grade) - 1 
			local job = targetXPlayer.job.name

			targetXPlayer.setJob(job, grade)

			TriggerClientEvent('esx:showNotification', _source, "Vous avez ~r~rétrogradé "..targetXPlayer.name.."~w~.")
			TriggerClientEvent('esx:showNotification', target,  "Vous avez été ~r~rétrogradé par ".. sourceXPlayer.name.."~w~.")		

		else
			TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")

		end

	end 
		
end)

RegisterServerEvent('NB:recruterplayer')
AddEventHandler('NB:recruterplayer', function(target, job, grade)

	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	
		targetXPlayer.setJob(job, grade)

		TriggerClientEvent('esx:showNotification', _source, "Vous avez ~g~recruté "..targetXPlayer.name.."~w~.")
		TriggerClientEvent('esx:showNotification', target,  "Vous avez été ~g~embauché par ".. sourceXPlayer.name.."~w~.")		

end)

RegisterServerEvent('NB:virerplayer')
AddEventHandler('NB:virerplayer', function(target)

	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local job = "unemployed"
	local grade = "0"

	if(sourceXPlayer.job.name == targetXPlayer.job.name)then
		targetXPlayer.setJob(job, grade)

		TriggerClientEvent('esx:showNotification', _source, "Vous avez ~r~viré "..targetXPlayer.name.."~w~.")
		TriggerClientEvent('esx:showNotification', target,  "Vous avez été ~g~viré par ".. sourceXPlayer.name.."~w~.")	
	else

		TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")

	end

end)