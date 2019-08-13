resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

--client_script 'client.lua'
--server_script 'server.lua'


client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'client.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}

dependencies {
	'essentialmode',
	'async'
}
