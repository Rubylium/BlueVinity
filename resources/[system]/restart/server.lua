
local text1 = "Le serveur reboot automatique dans 15 minutes !"
local text2 = "Le serveur reboot automatique dans 10 minutes !"
local text3 = "Le serveur reboot automatique dans 5 minutes  ! \n Pensez à sauvegarder votre position, inventaire et vous déconnecter !"
local test4 = "test pour avertir"

RegisterServerEvent("restart:checkreboot")

AddEventHandler('restart:checkreboot', function()
	date_local1 = os.date('%H:%M:%S', os.time())
	local date_local = date_local1
	if date_local == '05:45:00' then
		TriggerClientEvent('chatMessage', -1, "REBOOT - SERVEUR", {0, 0, 0}, text1)
	elseif date_local == '05:50:00' then
		TriggerClientEvent('chatMessage', -1, "REBOOT - SERVEUR", {0, 0, 0}, text2)
	elseif date_local == '05:55:00' then
		TriggerClientEvent('chatMessage', -1, "REBOOT - SERVEUR", {0, 0, 0}, text3)
	elseif date_local == '06:00:00' then
		TriggerEvent("kickAllPlayer2")
	elseif date_local == '11:50:00' then
		TriggerClientEvent('chatMessage', -1, "REBOOT - SERVEUR", {0, 0, 0}, text2)
	elseif date_local == '11:55:00' then
		TriggerClientEvent('chatMessage', -1, "REBOOT - SERVEUR", {0, 0, 0}, text3)
	elseif date_local == '12:00:00' then
		TriggerEvent("kickAllPlayer2")
	elseif date_local == '17:50:00' then
		TriggerClientEvent('chatMessage', -1, "REBOOT - SERVEUR", {0, 0, 0}, text2)
	elseif date_local == '17:55:00' then
		TriggerClientEvent('chatMessage', -1, "REBOOT - SERVEUR", {0, 0, 0}, text3)
	elseif date_local == '18:00:00' then
		TriggerEvent("kickAllPlayer2")
	elseif date_local == '23:50:00' then
		TriggerClientEvent('chatMessage', -1, "REBOOT - SERVEUR", {0, 0, 0}, text2)
	elseif date_local == '23:55:00' then
		TriggerClientEvent('chatMessage', -1, "REBOOT - SERVEUR", {0, 0, 0}, text3)
	elseif date_local == '00:00:00' then
		TriggerEvent("kickAllPlayer2")
	end
end)

function restart_server()
	SetTimeout(1000, function()
		TriggerEvent('restart:checkreboot')
		restart_server()
	end)
end
restart_server()
