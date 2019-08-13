--[[

  ESX RP Chat

--]]

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height'],
			group = identity['group']
		}
	else
		return nil
	end
end

AddEventHandler('chatMessage', function(source, name, message)
	if string.sub(message, 1, string.len("/")) ~= "/" then
          local name = getIdentity(source)
		--TriggerClientEvent("sendProximityMessageMe", -1, source, name.firstname, message)
		TriggerClientEvent('esx:ShowAdvancedNotification', source, 'Anti Message', '~b~Anti Message HRP', 'Désolé, si tu veux parler en HRP c\'est /ooc. ', 'CHAR_BLOCKED', 8)
	end
	CancelEvent()
end)

TriggerEvent('es:addCommand', 'me', function(source, args, user)
	local name = getIdentity(source)
	table.remove(args, 2)
	TriggerClientEvent('esx-qalle-chat:me', -1, source, name.firstname, table.concat(args, " "))
end)


RegisterCommand('ooc', function(source, args, rawCommand)
	local playerName = GetPlayerName(source)
	local msg = rawCommand:sub(5)
	local name = getIdentity(source)
	local admin = getIdentity(source)

	if admin.group == 'admin' or admin.group == 'superadmin' or admin.group == 'mod' then
		TriggerClientEvent('chat:addMessage', -1, {
			template = '<div style="padding: 0.2vw; margin: 0.2vw; background-color: rgba(41, 41, 41, 0.0); border-radius: 3px;"><i class="fas fa-globe"></i> {0}:<br> {1}</div>',
			args = { "^0[^1STAFF^0] ^3- ^0"..playerName, "^3"..msg }
		})
	else
		TriggerClientEvent('chat:addMessage', -1, {
			template = '<div style="padding: 0.2vw; margin: 0.2vw; background-color: rgba(41, 41, 41, 0.0); border-radius: 3px;"><i class="fas fa-globe"></i> {0}:<br> {1}</div>',
			args = { "^4ID: "..source.." ^3- ^0"..playerName, "^2"..msg }
		})
	end
end, false)


function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end
