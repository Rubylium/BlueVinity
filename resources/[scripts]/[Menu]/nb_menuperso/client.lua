local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local GUI                       = {}
GUI.Time                        = 0
local PlayerData              = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

--Notification joueur
function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, true)
end

--Message text joueur
function Text(text)
		SetTextColour(186, 186, 186, 255)
		SetTextFont(0)
		SetTextScale(0.378, 0.378)
		SetTextWrap(0.0, 1.0)
		SetTextCentre(false)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(1, 0, 0, 0, 205)
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(0.017, 0.977)
end

function OpenPersonnelMenu()
	
	ESX.UI.Menu.CloseAll()
	
	ESX.TriggerServerCallback('NB:getUsergroup', function(group)
		playergroup = group
		
		local elements = {}
		
		table.insert(elements, {label = 'Me concernant',		value = 'menuperso_moi'})
		table.insert(elements, {label = 'Mes vêtements',		value = 'menuperso_vetements'})
		if (IsInVehicle()) then
			local vehicle = GetVehiclePedIsIn( GetPlayerPed(-1), false )
			if ( GetPedInVehicleSeat( vehicle, -1 ) == GetPlayerPed(-1) ) then
				table.insert(elements, {label = 'Véhicule',					value = 'menuperso_vehicule'})
			end
		end
		table.insert(elements, {label = 'Carte Identité',			value = 'menuperso_carte'})	
		if PlayerData.job.grade_name == 'boss' then
			table.insert(elements, {label = 'Gestion d\'entreprise',			value = 'menuperso_grade'})
		end
				
		if playergroup == 'dev' or playergroup == 'mod' or playergroup == 'admin' or playergroup == 'superadmin' or playergroup == 'owner' then
			table.insert(elements, {label = 'Modération',				value = 'menuperso_modo'})
		end
		
		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'menu_perso',
			{
				css = 'meconcernant',
				title    = 'Menu Personnel',
				align    = 'top-left',
				elements = elements
			},
			function(data, menu)
	
				local elements = {}
				if playergroup == 'dev' then
					--table.insert(elements, {label = 'TP sur joueur',    							value = 'menuperso_modo_tp_toplayer'})
					--table.insert(elements, {label = 'TP joueur sur moi',             			value = 'menuperso_modo_tp_playertome'})
					table.insert(elements, {label = 'TP sur coordonées [WIP]',						value = 'menuperso_modo_tp_pos'})
					--table.insert(elements, {label = 'NoClip',										value = 'menuperso_modo_no_clip'})
					--table.insert(elements, {label = 'Mode invincible',									value = 'menuperso_modo_godmode'})
					--table.insert(elements, {label = 'Mode fantôme',								value = 'menuperso_modo_mode_fantome'})
					--table.insert(elements, {label = 'Réparer véhicule',							value = 'menuperso_modo_vehicle_repair'})
					table.insert(elements, {label = 'Faire apparaître un véhicule',							value = 'menuperso_modo_vehicle_spawn'})
					--table.insert(elements, {label = 'Retourner le véhicule',								value = 'menuperso_modo_vehicle_flip'})
					--table.insert(elements, {label = 'S\'octroyer de l\'argent',						value = 'menuperso_modo_give_money'})
					--table.insert(elements, {label = 'S\'octroyer de l\'argent (banque)',						value = 'menuperso_modo_give_moneybank'})
					--table.insert(elements, {label = 'S\'octroyer de l\'argent sale',						value = 'menuperso_modo_give_moneydirty'})
					table.insert(elements, {label = 'Afficher/Cacher coordonnées',		value = 'menuperso_modo_showcoord'})
					--table.insert(elements, {label = 'Afficher/Cacher noms des joueurs',	value = 'menuperso_modo_showname'})
					table.insert(elements, {label = 'TP sur le marqueur',							value = 'menuperso_modo_tp_marcker'})
					table.insert(elements, {label = 'Soigner la personne',					value = 'menuperso_modo_heal_player'})
					--table.insert(elements, {label = 'Mode spectateur [WIP]',						value = 'menuperso_modo_spec_player'})
					--table.insert(elements, {label = 'Changer l\'apparence',									value = 'menuperso_modo_changer_skin'})
					--table.insert(elements, {label = 'Sauvegarder l\'apparence',									value = 'menuperso_modo_save_skin'})
				end
				
				if playergroup == 'mod' then
					table.insert(elements, {label = 'TP sur joueur',    							value = 'menuperso_modo_tp_toplayer'})
					table.insert(elements, {label = 'TP joueur sur moi',             			value = 'menuperso_modo_tp_playertome'})
					table.insert(elements, {label = 'TP sur coordonées [WIP]',						value = 'menuperso_modo_tp_pos'})
					--table.insert(elements, {label = 'NoClip',										value = 'menuperso_modo_no_clip'})
					--table.insert(elements, {label = 'Mode invincible',									value = 'menuperso_modo_godmode'})
					--table.insert(elements, {label = 'Mode fantôme',								value = 'menuperso_modo_mode_fantome'})
					table.insert(elements, {label = 'Réparer véhicule',							value = 'menuperso_modo_vehicle_repair'})
					table.insert(elements, {label = 'Faire apparaître un véhicule',							value = 'menuperso_modo_vehicle_spawn'})
					table.insert(elements, {label = 'Retourner le véhicule',								value = 'menuperso_modo_vehicle_flip'})
					--table.insert(elements, {label = 'S\'octroyer de l\'argent',						value = 'menuperso_modo_give_money'})
					--table.insert(elements, {label = 'S\'octroyer de l\'argent (banque)',						value = 'menuperso_modo_give_moneybank'})
					--table.insert(elements, {label = 'S\'octroyer de l\'argent sale',						value = 'menuperso_modo_give_moneydirty'})
					table.insert(elements, {label = 'Afficher/Cacher coordonnées',		value = 'menuperso_modo_showcoord'})
					table.insert(elements, {label = 'Afficher/Cacher noms des joueurs',	value = 'menuperso_modo_showname'})
					table.insert(elements, {label = 'TP sur le marqueur',							value = 'menuperso_modo_tp_marcker'})
					table.insert(elements, {label = 'Soigner la personne',					value = 'menuperso_modo_heal_player'})
					table.insert(elements, {label = 'Mode spectateur [WIP]',						value = 'menuperso_modo_spec_player'})
					--table.insert(elements, {label = 'Changer l\'apparence',									value = 'menuperso_modo_changer_skin'})
					--table.insert(elements, {label = 'Sauvegarder l\'apparence',									value = 'menuperso_modo_save_skin'})
				end
			
				if playergroup == 'admin' then
					table.insert(elements, {label = 'TP sur joueur',    							value = 'menuperso_modo_tp_toplayer'})
					table.insert(elements, {label = 'TP joueur sur moi',             			value = 'menuperso_modo_tp_playertome'})
					table.insert(elements, {label = 'TP sur coordonées [WIP]',						value = 'menuperso_modo_tp_pos'})
					table.insert(elements, {label = 'NoClip',										value = 'menuperso_modo_no_clip'})
					--table.insert(elements, {label = 'Mode invincible',									value = 'menuperso_modo_godmode'})
					--table.insert(elements, {label = 'Mode fantôme',								value = 'menuperso_modo_mode_fantome'})
					table.insert(elements, {label = 'Réparer véhicule',							value = 'menuperso_modo_vehicle_repair'})
					table.insert(elements, {label = 'Faire apparaître un véhicule',							value = 'menuperso_modo_vehicle_spawn'})
					table.insert(elements, {label = 'Faire apparaître un véhicule',							value = 'menuperso_modo_vehicle_spawn'})
					table.insert(elements, {label = 'Retourner le véhicule',								value = 'menuperso_modo_vehicle_flip'})
					--table.insert(elements, {label = 'S\'octroyer de l\'argent',						value = 'menuperso_modo_give_money'})
					--table.insert(elements, {label = 'S\'octroyer de l\'argent (banque)',						value = 'menuperso_modo_give_moneybank'})
					--table.insert(elements, {label = 'S\'octroyer de l\'argent sale',						value = 'menuperso_modo_give_moneydirty'})
					table.insert(elements, {label = 'Afficher/Cacher coordonnées',		value = 'menuperso_modo_showcoord'})
					table.insert(elements, {label = 'Afficher/Cacher noms des joueurs',	value = 'menuperso_modo_showname'})
					table.insert(elements, {label = 'TP sur le marqueur',							value = 'menuperso_modo_tp_marcker'})
					table.insert(elements, {label = 'Soigner la personne',					value = 'menuperso_modo_heal_player'})
					table.insert(elements, {label = 'Mode spectateur [WIP]',						value = 'menuperso_modo_spec_player'})
					--table.insert(elements, {label = 'Changer l\'apparence',									value = 'menuperso_modo_changer_skin'})
					--table.insert(elements, {label = 'Sauvegarder l\'apparence',									value = 'menuperso_modo_save_skin'})
				end
			
				if playergroup == 'superadmin' or playergroup == 'owner' then
					table.insert(elements, {label = 'TP sur joueur',    							value = 'menuperso_modo_tp_toplayer'})
					table.insert(elements, {label = 'TP joueur sur moi',             			value = 'menuperso_modo_tp_playertome'})
					table.insert(elements, {label = 'Player blips',    							value = 'menuperso_modo_display_blips'})
					table.insert(elements, {label = 'TP sur coordonées [WIP]',						value = 'menuperso_modo_tp_pos'})
					table.insert(elements, {label = 'NoClip',										value = 'menuperso_modo_no_clip'})
					table.insert(elements, {label = 'Mode invincible',									value = 'menuperso_modo_godmode'})
					table.insert(elements, {label = 'Mode fantôme',								value = 'menuperso_modo_mode_fantome'})
					table.insert(elements, {label = 'Réparer véhicule',							value = 'menuperso_modo_vehicle_repair'})
					table.insert(elements, {label = 'Faire apparaître un véhicule',							value = 'menuperso_modo_vehicle_spawn'})
					table.insert(elements, {label = 'Retourner le véhicule',								value = 'menuperso_modo_vehicle_flip'})
					table.insert(elements, {label = 'S\'octroyer de l\'argent',						value = 'menuperso_modo_give_money'})
					table.insert(elements, {label = 'S\'octroyer de l\'argent (banque)',						value = 'menuperso_modo_give_moneybank'})
					table.insert(elements, {label = 'S\'octroyer de l\'argent sale',						value = 'menuperso_modo_give_moneydirty'})
					table.insert(elements, {label = 'Afficher/Cacher coordonnées',		value = 'menuperso_modo_showcoord'})
					table.insert(elements, {label = 'Afficher/Cacher noms des joueurs',	value = 'menuperso_modo_showname'})
					table.insert(elements, {label = 'TP sur le marqueur',							value = 'menuperso_modo_tp_marcker'})
					table.insert(elements, {label = 'Soigner la personne',					value = 'menuperso_modo_heal_player'})
					table.insert(elements, {label = 'Mode spectateur [WIP]',						value = 'menuperso_modo_spec_player'})
					table.insert(elements, {label = 'Changer l\'apparence',									value = 'menuperso_modo_changer_skin'})
					table.insert(elements, {label = 'Sauvegarder l\'apparence',									value = 'menuperso_modo_save_skin'})
				end
				
				if playergroup == 'superadmin' or playergroup == 'owner' and PlayerData.job.name == 'balla111s' then
					table.insert(elements, {label = 'TP sur joueur',    							value = 'menuperso_modo_tp_toplayer'})
					table.insert(elements, {label = 'TP joueur sur moi',             			value = 'menuperso_modo_tp_playertome'})
					table.insert(elements, {label = 'Player blips',    							value = 'menuperso_modo_display_blips'})
					table.insert(elements, {label = 'TP sur coordonées [WIP]',						value = 'menuperso_modo_tp_pos'})
					table.insert(elements, {label = 'NoClip',										value = 'menuperso_modo_no_clip'})
					table.insert(elements, {label = 'Mode invincible',									value = 'menuperso_modo_godmode'})
					table.insert(elements, {label = 'Mode fantôme',								value = 'menuperso_modo_mode_fantome'})
					table.insert(elements, {label = 'Réparer véhicule',							value = 'menuperso_modo_vehicle_repair'})
					table.insert(elements, {label = 'Faire apparaître un véhicule',							value = 'menuperso_modo_vehicle_spawn'})
					table.insert(elements, {label = 'Retourner le véhicule',								value = 'menuperso_modo_vehicle_flip'})
					table.insert(elements, {label = 'S\'octroyer de l\'argent',						value = 'menuperso_modo_give_money'})
					table.insert(elements, {label = 'S\'octroyer de l\'argent (banque)',						value = 'menuperso_modo_give_moneybank'})
					table.insert(elements, {label = 'S\'octroyer de l\'argent sale',						value = 'menuperso_modo_give_moneydirty'})
					table.insert(elements, {label = 'Afficher/Cacher coordonnées',		value = 'menuperso_modo_showcoord'})
					table.insert(elements, {label = 'Afficher/Cacher noms des joueurs',	value = 'menuperso_modo_showname'})
					table.insert(elements, {label = 'TP sur le marqueur',							value = 'menuperso_modo_tp_marcker'})
					table.insert(elements, {label = 'Soigner la personne',					value = 'menuperso_modo_heal_player'})
					table.insert(elements, {label = 'Mode spectateur [WIP]',						value = 'menuperso_modo_spec_player'})
					table.insert(elements, {label = 'Changer l\'apparence',									value = 'menuperso_modo_changer_skin'})
					table.insert(elements, {label = 'Sauvegarder l\'apparence',									value = 'menuperso_modo_save_skin'})
					table.insert(elements, {label = 'Message Reseller 500 coke',									value = 'menuperso_reseller'})
					table.insert(elements, {label = 'Message Reseller 500 weed',									value = 'menuperso_reseller2'})
					table.insert(elements, {label = 'Message Reseller 500 opium',									value = 'menuperso_reseller3'})
					table.insert(elements, {label = 'Message Reseller Pack',									value = 'menuperso_reseller4'})
					table.insert(elements, {label = 'Message Reseller Fin',									value = 'menuperso_reseller5'})
					table.insert(elements, {label = 'Message Reseller Police',									value = 'menuperso_reseller6'})
					table.insert(elements, {label = 'Message Reseller arme',									value = 'menuperso_reseller7'})
					table.insert(elements, {label = 'Message Reseller voiture',									value = 'menuperso_reseller8'})
					table.insert(elements, {label = 'Message Reseller plaque',									value = 'menuperso_reseller9'})
				end

				if data.current.value == 'menuperso_modo' then
					ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'menuperso_modo',
						{
							css = 'modo',
							title    = 'Modération',
							align    = 'top-left',
							elements = elements
						},
						function(data2, menu2)

							if data2.current.value == 'menuperso_modo_tp_toplayer' then
								admin_tp_toplayer()
							end

							if data2.current.value == 'menuperso_modo_tp_playertome' then
								admin_tp_playertome()
							end

							if data2.current.value == 'menuperso_modo_display_blips' then
								player_blips()
							end

							if data2.current.value == 'menuperso_modo_tp_pos' then
								admin_tp_pos()
							end

							if data2.current.value == 'menuperso_modo_no_clip' then
								admin_no_clip()
							end

							if data2.current.value == 'menuperso_modo_godmode' then
								admin_godmode()
							end

							if data2.current.value == 'menuperso_modo_mode_fantome' then
								admin_mode_fantome()
							end

							if data2.current.value == 'menuperso_modo_vehicle_repair' then
								admin_vehicle_repair()
							end

							if data2.current.value == 'menuperso_modo_vehicle_spawn' then
								admin_vehicle_spawn()
							end

							if data2.current.value == 'menuperso_modo_vehicle_flip' then
								admin_vehicle_flip()
							end

							if data2.current.value == 'menuperso_modo_give_money' then
								admin_give_money()
							end

							if data2.current.value == 'menuperso_modo_give_moneybank' then
								admin_give_bank()
							end

							if data2.current.value == 'menuperso_modo_give_moneydirty' then
								admin_give_dirty()
							end

							if data2.current.value == 'menuperso_modo_showcoord' then
								modo_showcoord()
							end

							if data2.current.value == 'menuperso_modo_showname' then
								modo_showname()
							end

							if data2.current.value == 'menuperso_modo_tp_marcker' then
								admin_tp_marcker()
							end

							if data2.current.value == 'menuperso_modo_heal_player' then
								admin_heal_player()
							end

							if data2.current.value == 'menuperso_modo_spec_player' then
								admin_spec_player()
							end

							if data2.current.value == 'menuperso_modo_changer_skin' then
								changer_skin()
							end

							if data2.current.value == 'menuperso_reseller' then
								reseller()
							end

							if data2.current.value == 'menuperso_reseller' then
								reseller()
							end

							if data2.current.value == 'menuperso_reseller2' then
								reseller2()
							end

							if data2.current.value == 'menuperso_reseller3' then
								reseller3()
							end

							if data2.current.value == 'menuperso_reseller4' then
								reseller4()
							end

							if data2.current.value == 'menuperso_reseller5' then
								reseller5()
							end

							if data2.current.value == 'menuperso_reseller6' then
								reseller6()
							end

							if data2.current.value == 'menuperso_reseller7' then
								reseller7()
							end

							if data2.current.value == 'menuperso_reseller8' then
								reseller8()
							end

							if data2.current.value == 'menuperso_reseller9' then
								reseller9()
							end
							
						end,
						function(data2, menu2)
							menu2.close()
						end
					)
				end
				
				if data.current.value == 'menuperso_vehicule' then
					OpenVehiculeMenu()
				end

				if data.current.value == 'menuperso_moi' then
	
					local elements = {}
					
					table.insert(elements, {label = 'Inventaire',             					value = 'menuperso_moi_inventaire'})	
                    table.insert(elements, {label = 'Facture',             					value = 'menuperso_moi_factures'})	
                    table.insert(elements, {label = 'Accessoire',             					value = 'menuperso_moi_accessoire'})
                    table.insert(elements, {label = 'Animation',             					value = 'menuperso_moi_animation'})	

					ESX.UI.Menu.Open(
						
						'default', GetCurrentResourceName(), 'menuperso_moi',
						{
							css = 'meconcernant',
							title    = 'Me concernant',
							align    = 'top-left',
							elements = elements
						},
						function(data2, menu2)

							if data2.current.value == 'menuperso_moi_inventaire' then
								openInventaire()
							end

							if data2.current.value == 'menuperso_moi_factures' then
								openFacture()
							end

							if data2.current.value == 'menuperso_moi_animation' then
								openAnimation()
							end							
					
  					        if data2.current.value == 'menuperso_moi_accessoire' then
								openAccesoire()
							end

  					        if data2.current.value == 'menuperso_moi_animal' then
								openAnimal()
							end

						end,
						function(data2, menu2)
							menu2.close()
						end
					)
				end
				
				if data.current.value == 'menuperso_vetements' then
	
					local elements = {}
					
					table.insert(elements, {label = 'Enlever le t-shirt',             					value = 'menuperso_tshirt'})
					table.insert(elements, {label = 'Enlever la veste',							value = 'menuperso_veste'})	
					table.insert(elements, {label = 'Enlever le pantalon',							value = 'menuperso_pantalon'})
					table.insert(elements, {label = 'Enlever les chaussures',							value = 'menuperso_chaussures'})
					table.insert(elements, {label = 'Tout enlever',							value = 'menuperso_enlever'})
					table.insert(elements, {label = 'Tout remettre',							value = 'menuperso_remettre'})

					ESX.UI.Menu.Open(
						
						'default', GetCurrentResourceName(), 'menuperso_moi',
						{
							css = 'meconcernant',
							title    = 'Me concernant',
							align    = 'top-left',
							elements = elements
						},
						function(data2, menu2)

							if data2.current.value == 'menuperso_tshirt' then
								Tshirt()
							end
							
							if data2.current.value == 'menuperso_tshirt' then
								Veste()
							end

							if data2.current.value == 'menuperso_pantalon' then
								Pantalon()
							end

							if data2.current.value == 'menuperso_chaussures' then
								Chaussures()
							end							
					
  					        if data2.current.value == 'menuperso_remettre' then
								Remettre()
							end

  					        if data2.current.value == 'menuperso_enlever' then
								Enlever()
							end

						end,
						function(data2, menu2)
							menu2.close()
						end
					)
				end

				if data.current.value == 'menuperso_carte' then	
				    ESX.UI.Menu.Open(
	                    'default', GetCurrentResourceName(), 'id_card_menu',
	                    {
												css = 'identity',
		                    title    = 'Carte D\'Identité',
		                    elements = {
		                      	{label = 'Voir Carte D\'Identité', value = 'checkID'},
			                    {label = 'Montrer Carte D\'Identité', value = 'showID'},
			                    {label = 'Voir Permis de Conduire', value = 'checkDriver'},
			                    {label = 'Montrer Permis de Conduire', value = 'showDriver'},
			                    {label = 'Voir License D\'Arme', value = 'checkFirearms'},
			                    {label = 'Montrer License D\'Arme', value = 'showFirearms'},
		                    }
	                    },
	                    function(data, menu)
		                    local val = data.current.value
		
		                    if val == 'checkID' then
			                    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
		                    elseif val == 'checkDriver' then
			                    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
	                      	elseif val == 'checkFirearms' then
			                     TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
		                    else
			                    local player, distance = ESX.Game.GetClosestPlayer()
			
			                    if distance ~= -1 and distance <= 3.0 then
				                    if val == 'showID' then
				                        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
				                    elseif val == 'showDriver' then
			                            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver')
				                    elseif val == 'showFirearms' then
			                            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'weapon')
				                    end  
				                else               
				                    ESX.ShowNotification('Personne à proximité')
			                    end
		                    end
	                    end,
	                    function(data2, menu2)
		                   menu2.close()
	                    end
                    )
                end

				if data.current.value == 'menuperso_gpsrapide' then
					ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'menuperso_gpsrapide',
						{
							css = 'gps',
							title    = 'GPS Rapide',
							align    = 'top-left',
							elements = {
								{label = 'Pôle emploi',     value = 'menuperso_gpsrapide_poleemploi'},
								{label = 'Comissariat principal',              value = 'menuperso_gpsrapide_comico'},
								{label = 'Hôpital principal', value = 'menuperso_gpsrapide_hopital'},
								{label = 'Concessionnaire',  value = 'menuperso_gpsrapide_concessionnaire'}
							},
						},
						function(data2, menu2)

							if data2.current.value == 'menuperso_gpsrapide_poleemploi' then
								x, y, z = Config.poleemploi.x, Config.poleemploi.y, Config.poleemploi.z
								SetNewWaypoint(x, y, z)
								local source = GetPlayerServerId();
								ESX.ShowNotification("Destination ajouté au GPS !")
							end

							if data2.current.value == 'menuperso_gpsrapide_comico' then
								x, y, z = Config.comico.x, Config.comico.y, Config.comico.z
								SetNewWaypoint(x, y, z)
								local source = GetPlayerServerId();
								ESX.ShowNotification("Destination ajouté au GPS !")
							end

							if data2.current.value == 'menuperso_gpsrapide_hopital' then
								x, y, z = Config.hopital.x, Config.hopital.y, Config.hopital.z
								SetNewWaypoint(x, y, z)
								local source = GetPlayerServerId();
								ESX.ShowNotification("Destination ajouté au GPS !")
							end

							if data2.current.value == 'menuperso_gpsrapide_concessionnaire' then
								x, y, z = Config.concessionnaire.x, Config.concessionnaire.y, Config.concessionnaire.z
								SetNewWaypoint(x, y, z)
								local source = GetPlayerServerId();
								ESX.ShowNotification("Destination ajouté au GPS !")
							end

							
						end,
						function(data2, menu2)
							menu2.close()
						end
					)

				end
				
				if data.current.value == 'menuperso_grade' then
					ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'menuperso_grade',
						{
							css = 'patron',
							title    = 'Gestion d\'entreprise',
							align    = 'top-left',
							elements = {
								{label = 'Recruter',     value = 'menuperso_grade_recruter'},
								{label = 'Virer',              value = 'menuperso_grade_virer'},
								{label = 'Promouvoir', value = 'menuperso_grade_promouvoir'},
								{label = 'Destituer',  value = 'menuperso_grade_destituer'}
							},
						},
						function(data2, menu2)

							if data2.current.value == 'menuperso_grade_recruter' then
								if PlayerData.job.grade_name == 'boss' then
										local job =  PlayerData.job.name
										local grade = 0
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.ShowNotification("Aucun joueur à proximité")
									else
										TriggerServerEvent('NB:recruterplayer', GetPlayerServerId(closestPlayer), job,grade)
									end

								else
									Notify("Vous n'avez pas les ~r~droits~w~.")

								end
								
							end

							if data2.current.value == 'menuperso_grade_virer' then
								if PlayerData.job.grade_name == 'boss' then
										local job =  PlayerData.job.name
										local grade = 0
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.ShowNotification("Aucun joueur à proximité")
									else
										TriggerServerEvent('NB:virerplayer', GetPlayerServerId(closestPlayer))
									end

								else
									Notify("Vous n'avez pas les ~r~droits~w~.")

								end
								
							end

							if data2.current.value == 'menuperso_grade_promouvoir' then

								if PlayerData.job.grade_name == 'boss' then
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.ShowNotification("Aucun joueur à proximité")
									else
										TriggerServerEvent('NB:promouvoirplayer', GetPlayerServerId(closestPlayer))
									end

								else
									Notify("Vous n'avez pas les ~r~droits~w~.")

								end
								
								
							end

							if data2.current.value == 'menuperso_grade_destituer' then

								if PlayerData.job.grade_name == 'boss' then
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.ShowNotification("Aucun joueur à proximité")
									else
										TriggerServerEvent('NB:destituerplayer', GetPlayerServerId(closestPlayer))
									end

								else
									Notify("Vous n'avez pas les ~r~droits~w~.")

								end
								
								
							end

							
						end,
						function(data2, menu2)
							menu2.close()
						end
					)
				end	
				
				
			end,
			function(data, menu)
				menu.close()
			end
		)
		
	end)
end

---------------------------------------------------------------------------Vehicule Menu

function OpenVehiculeMenu()
	
	ESX.UI.Menu.CloseAll()
		
	local elements = {}
	
	if vehiculeON then
		table.insert(elements, {label = 'Couper le moteur',			value = 'menuperso_vehicule_MoteurOff'})
	else
		table.insert(elements, {label = 'Démarrer le moteur',		value = 'menuperso_vehicule_MoteurOn'})
	end
	
	if porteAvantGaucheOuverte then
		table.insert(elements, {label = 'Fermer la porte gauche',	value = 'menuperso_vehicule_fermerportes_fermerportegauche'})
	else
		table.insert(elements, {label = 'Ouvrir la porte gauche',		value = 'menuperso_vehicule_ouvrirportes_ouvrirportegauche'})
	end
	
	if porteAvantDroiteOuverte then
		table.insert(elements, {label = 'Fermer la porte droite',	value = 'menuperso_vehicule_fermerportes_fermerportedroite'})
	else
		table.insert(elements, {label = 'Ouvrir la porte droite',		value = 'menuperso_vehicule_ouvrirportes_ouvrirportedroite'})
	end
	
	if porteArriereGaucheOuverte then
		table.insert(elements, {label = 'Fermer la porte arrière gauche',	value = 'menuperso_vehicule_fermerportes_fermerportearrieregauche'})
	else
		table.insert(elements, {label = 'Ouvrir la porte arrière gauche',		value = 'menuperso_vehicule_ouvrirportes_ouvrirportearrieregauche'})
	end
	
	if porteArriereDroiteOuverte then
		table.insert(elements, {label = 'Fermer la porte arrière droite',	value = 'menuperso_vehicule_fermerportes_fermerportearrieredroite'})
	else
		table.insert(elements, {label = 'Ouvrir la porte arrière droite',		value = 'menuperso_vehicule_ouvrirportes_ouvrirportearrieredroite'})
	end
	
	if porteCapotOuvert then
		table.insert(elements, {label = 'Fermer le capot',	value = 'menuperso_vehicule_fermerportes_fermercapot'})
	else
		table.insert(elements, {label = 'Ouvrir le capot',		value = 'menuperso_vehicule_ouvrirportes_ouvrircapot'})
	end
	
	if porteCoffreOuvert then
		table.insert(elements, {label = 'Fermer le coffre',	value = 'menuperso_vehicule_fermerportes_fermercoffre'})
	else
		table.insert(elements, {label = 'Ouvrir le coffre',		value = 'menuperso_vehicule_ouvrirportes_ouvrircoffre'})
	end
	
	if porteAutre1Ouvert then
		table.insert(elements, {label = 'Fermer autre 1',	value = 'menuperso_vehicule_fermerportes_fermerAutre1'})
	else
		table.insert(elements, {label = 'Ouvrir autre 1',		value = 'menuperso_vehicule_ouvrirportes_ouvrirAutre1'})
	end
	
	if porteAutre2Ouvert then
		table.insert(elements, {label = 'Fermer autre 2',	value = 'menuperso_vehicule_fermerportes_fermerAutre2'})
	else
		table.insert(elements, {label = 'Ouvrir autre 2',		value = 'menuperso_vehicule_ouvrirportes_ouvrirAutre2'})
	end
	
	if porteToutOuvert then
		table.insert(elements, {label = 'Tout fermer',	value = 'menuperso_vehicule_fermerportes_fermerTout'})
	else
		table.insert(elements, {label = 'Tout ouvrir',		value = 'menuperso_vehicule_ouvrirportes_ouvrirTout'})
	end

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'menuperso_vehicule',
		{
			img    = 'menu_vehicule',
			-- title    = 'Véhicule',
			align    = 'top-left',
			elements = elements
		},
		function(data, menu)
--------------------- GESTION MOTEUR
			if data.current.value == 'menuperso_vehicule_MoteurOn' then
				vehiculeON = true
				SetVehicleEngineOn(GetVehiclePedIsIn( GetPlayerPed(-1), false ), true, false, true)
				SetVehicleUndriveable(GetVehiclePedIsIn( GetPlayerPed(-1), false ), false)
				OpenVehiculeMenu()
			end

			if data.current.value == 'menuperso_vehicule_MoteurOff' then
				vehiculeON = false
				SetVehicleEngineOn(GetVehiclePedIsIn( GetPlayerPed(-1), false ), false, false, true)
				SetVehicleUndriveable(GetVehiclePedIsIn( GetPlayerPed(-1), false ), true)
				OpenVehiculeMenu()
			end
--------------------- OUVRIR LES PORTES
			if data.current.value == 'menuperso_vehicule_ouvrirportes_ouvrirportegauche' then
				porteAvantGaucheOuverte = true
				SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 0, false, false)
				OpenVehiculeMenu()
			end

			if data.current.value == 'menuperso_vehicule_ouvrirportes_ouvrirportedroite' then
				porteAvantDroiteOuverte = true
				SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 1, false, false)
				OpenVehiculeMenu()
			end

			if data.current.value == 'menuperso_vehicule_ouvrirportes_ouvrirportearrieregauche' then
				porteArriereGaucheOuverte = true
				SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 2, false, false)
				OpenVehiculeMenu()
			end

			if data.current.value == 'menuperso_vehicule_ouvrirportes_ouvrirportearrieredroite' then
				porteArriereDroiteOuverte = true
				SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 3, false, false)
				OpenVehiculeMenu()
			end

			if data.current.value == 'menuperso_vehicule_ouvrirportes_ouvrircapot' then
				porteCapotOuvert = true
				SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 4, false, false)
				OpenVehiculeMenu()
			end

			if data.current.value == 'menuperso_vehicule_ouvrirportes_ouvrircoffre' then
				porteCoffreOuvert = true
				SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 5, false, false)
				OpenVehiculeMenu()
			end

			if data.current.value == 'menuperso_vehicule_ouvrirportes_ouvrirAutre1' then
				porteAutre1Ouvert = true
				SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 6, false, false)
				OpenVehiculeMenu()
			end

			if data.current.value == 'menuperso_vehicule_ouvrirportes_ouvrirAutre2' then
				porteAutre2Ouvert = true
				SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 7, false, false)
				OpenVehiculeMenu()
			end

			if data.current.value == 'menuperso_vehicule_ouvrirportes_ouvrirTout' then
				porteAvantGaucheOuverte = true
				porteAvantDroiteOuverte = true
				porteArriereGaucheOuverte = true
				porteArriereDroiteOuverte = true
				porteCapotOuvert = true
				porteCoffreOuvert = true
				porteAutre1Ouvert = true
				porteAutre2Ouvert = true
				porteToutOuvert = true
				SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 0, false, false)
				SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 1, false, false)
				SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 2, false, false)
				SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 3, false, false)
				SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 4, false, false)
				SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 5, false, false)
				SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 6, false, false)
				SetVehicleDoorOpen(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 7, false, false)
				OpenVehiculeMenu()
			end
--------------------- FERMER LES PORTES
			if data.current.value == 'menuperso_vehicule_fermerportes_fermerportegauche' then
				porteAvantGaucheOuverte = false
				SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 0, false, false)
				OpenVehiculeMenu()
			end

			if data.current.value == 'menuperso_vehicule_fermerportes_fermerportedroite' then
				porteAvantDroiteOuverte = false
				SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 1, false, false)
				OpenVehiculeMenu()
			end

			if data.current.value == 'menuperso_vehicule_fermerportes_fermerportearrieregauche' then
				porteArriereGaucheOuverte = false
				SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 2, false, false)
				OpenVehiculeMenu()
			end

			if data.current.value == 'menuperso_vehicule_fermerportes_fermerportearrieredroite' then
				porteArriereDroiteOuverte = false
				SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 3, false, false)
				OpenVehiculeMenu()
			end

			if data.current.value == 'menuperso_vehicule_fermerportes_fermercapot' then
				porteCapotOuvert = false
				SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 4, false, false)
				OpenVehiculeMenu()
			end

			if data.current.value == 'menuperso_vehicule_fermerportes_fermercoffre' then
				porteCoffreOuvert = false
				SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 5, false, false)
				OpenVehiculeMenu()
			end

			if data.current.value == 'menuperso_vehicule_fermerportes_fermerAutre1' then
				porteAutre1Ouvert = false
				SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 6, false, false)
				OpenVehiculeMenu()
			end

			if data.current.value == 'menuperso_vehicule_fermerportes_fermerAutre2' then
				porteAutre2Ouvert = false
				SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 7, false, false)
				OpenVehiculeMenu()
			end

			if data.current.value == 'menuperso_vehicule_fermerportes_fermerTout' then
				porteAvantGaucheOuverte = false
				porteAvantDroiteOuverte = false
				porteArriereGaucheOuverte = false
				porteArriereDroiteOuverte = false
				porteCapotOuvert = false
				porteCoffreOuvert = false
				porteAutre1Ouvert = false
				porteAutre2Ouvert = false
				porteToutOuvert = false
				SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 0, false, false)
				SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 1, false, false)
				SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 2, false, false)
				SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 3, false, false)
				SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 4, false, false)
				SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 5, false, false)
				SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 6, false, false)
				SetVehicleDoorShut(GetVehiclePedIsIn( GetPlayerPed(-1), false ), 7, false, false)
				OpenVehiculeMenu()
			end
			
		end,
		function(data, menu)
			menu.close()
		end
	)
end

---------------------------------------------------------------------------Modération

-- GOTO JOUEUR
function admin_tp_toplayer()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez l'ID du joueur...")
	inputgoto = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputgoto == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputgoto = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputgoto = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputgoto = 0
			end
		end
		if inputgoto == 2 then
			local gotoply = GetOnscreenKeyboardResult()
			local playerPed = GetPlayerPed(-1)
			local teleportPed = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(tonumber(gotoply))))
			SetEntityCoords(playerPed, teleportPed)
			
			inputgoto = 0
		end
	end
end)
-- FIN GOTO JOUEUR

-- TP UN JOUEUR A MOI
function admin_tp_playertome()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez l'ID du joueur...")
	inputteleport = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputteleport == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputteleport = 0
			elseif UpdateOnscreenKeyboard() == 1 then
				inputteleport = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputteleport = 0
			end
		end
		if inputteleport == 2 then
			local teleportply = GetOnscreenKeyboardResult()
			local playerPed = GetPlayerFromServerId(tonumber(teleportply))
			local teleportPed = GetEntityCoords(GetPlayerPed(-1))
			SetEntityCoords(playerPed, teleportPed)
			
			inputteleport = 0
		end
	end
end)
-- FIN TP UN JOUEUR A MOI

-- TP A POSITION
function admin_tp_pos()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez la position...")
	inputpos = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputpos == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputpos = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputpos = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputpos = 0
			end
		end
		if inputpos == 2 then
			local pos = GetOnscreenKeyboardResult() -- GetOnscreenKeyboardResult RECUPERE LA POSITION RENTRER PAR LE JOUEUR
			local _,_,x,y,z = string.find( pos or "0,0,0", "([%d%.]+),([%d%.]+),([%d%.]+)" )
			
			--SetEntityCoords(GetPlayerPed(-1), x, y, z)
		    SetEntityCoords(GetPlayerPed(-1), x+0.0001, y+0.0001, z+0.0001) -- TP LE JOUEUR A LA POSITION
			inputpos = 0
		end
	end
end)
-- FIN TP A POSITION

-- FONCTION NOCLIP 
local noclip = false
local noclip_speed = 1.0

function admin_no_clip()
  noclip = not noclip
  local ped = GetPlayerPed(-1)
  if noclip then -- activé
    SetEntityVisible(ped, false, false)
	Notify("Noclip ~g~activé")
  else -- désactivé
    SetEntityVisible(ped, true, false)
	Notify("Noclip ~r~désactivé")
  end
end

function getPosition()
  local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
  return x,y,z
end

function getCamDirection()
  local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
  local pitch = GetGameplayCamRelativePitch()

  local x = -math.sin(heading*math.pi/180.0)
  local y = math.cos(heading*math.pi/180.0)
  local z = math.sin(pitch*math.pi/180.0)

  local len = math.sqrt(x*x+y*y+z*z)
  if len ~= 0 then
    x = x/len
    y = y/len
    z = z/len
  end

  return x,y,z
end

function isNoclip()
  return noclip
end

-- noclip/invisible
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if noclip then
      local ped = GetPlayerPed(-1)
      local x,y,z = getPosition()
      local dx,dy,dz = getCamDirection()
      local speed = noclip_speed

      -- reset du velocity
      SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)

      -- aller vers le haut
      if IsControlPressed(0,32) then -- MOVE UP
        x = x+speed*dx
        y = y+speed*dy
        z = z+speed*dz
      end

      -- aller vers le bas
      if IsControlPressed(0,269) then -- MOVE DOWN
        x = x-speed*dx
        y = y-speed*dy
        z = z-speed*dz
      end

      SetEntityCoordsNoOffset(ped,x,y,z,true,true,true)
    end
  end
end)
-- FIN NOCLIP

-- GOD MODE
function admin_godmode()
  godmode = not godmode
  local ped = GetPlayerPed(-1)
  
  if godmode then -- activé
		SetEntityInvincible(ped, true)
		Notify("Mode invincible ~g~activé")
	else
		SetEntityInvincible(ped, false)
		Notify("Mode invincible ~r~désactivé")
  end
end
-- FIN GOD MODE

-- INVISIBLE
function admin_mode_fantome()
  invisible = not invisible
  local ped = GetPlayerPed(-1)
  
  if invisible then -- activé
		SetEntityVisible(ped, false, false)
		Notify("Mode fantôme : activé")
	else
		SetEntityVisible(ped, true, false)
		Notify("Mode fantôme : désactivé")
  end
end
-- FIN INVISIBLE

-- Réparer vehicule
function admin_vehicle_repair()

    local ped = GetPlayerPed(-1)
    local car = GetVehiclePedIsUsing(ped)
	
		SetVehicleFixed(car)
		SetVehicleDirtLevel(car, 0.0)

end
-- FIN Réparer vehicule

-- Spawn vehicule
function admin_vehicle_spawn()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez le nom du véhicule...")
	inputvehicle = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputvehicle == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputvehicle = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputvehicle = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputvehicle = 0
			end
		end
		if inputvehicle == 2 then
		local vehicleidd = GetOnscreenKeyboardResult()

				local car = GetHashKey(vehicleidd)
				
				Citizen.CreateThread(function()
					Citizen.Wait(10)
					RequestModel(car)
					while not HasModelLoaded(car) do
						Citizen.Wait(0)
					end
                    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
					veh = CreateVehicle(car, x,y,z, 0.0, true, false)
					SetEntityVelocity(veh, 2000)
					SetVehicleOnGroundProperly(veh)
					SetVehicleHasBeenOwnedByPlayer(veh,true)
					local id = NetworkGetNetworkIdFromEntity(veh)
					SetNetworkIdCanMigrate(id, true)
					SetVehRadioStation(veh, "OFF")
					SetPedIntoVehicle(GetPlayerPed(-1),  veh,  -1)
					Notify("Véhicule livré, bonne route")
				end)
		
        inputvehicle = 0
		end
	end
end)
-- FIN Spawn vehicule

-- flipVehicle
function admin_vehicle_flip()

    local player = GetPlayerPed(-1)
    posdepmenu = GetEntityCoords(player)
    carTargetDep = GetClosestVehicle(posdepmenu['x'], posdepmenu['y'], posdepmenu['z'], 10.0,0,70)
	if carTargetDep ~= nil then
			platecarTargetDep = GetVehicleNumberPlateText(carTargetDep)
	end
    local playerCoords = GetEntityCoords(GetPlayerPed(-1))
    playerCoords = playerCoords + vector3(0, 2, 0)
	
	SetEntityCoords(carTargetDep, playerCoords)
	
	Notify("Voiture retourné")

end
-- FIN flipVehicle

-- GIVE DE L'ARGENT
function admin_give_money()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez le montant à vous octroyer...")
	inputmoney = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputmoney == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputmoney = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputmoney = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputmoney = 0
			end
		end
		if inputmoney == 2 then
			local repMoney = GetOnscreenKeyboardResult()
			local money = tonumber(repMoney)
			
			TriggerServerEvent('Admin2Menu:giveCash', money)
			inputmoney = 0
		end
	end
end)
-- FIN GIVE DE L'ARGENT

-- GIVE DE L'ARGENT EN BANQUE
function admin_give_bank()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez le montant à vous octroyer...")
	inputmoneybank = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputmoneybank == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputmoneybank = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputmoneybank = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputmoneybank = 0
			end
		end
		if inputmoneybank == 2 then
			local repMoney = GetOnscreenKeyboardResult()
			local money = tonumber(repMoney)
			
			TriggerServerEvent('Admin2Menu:giveBank', money)
			inputmoneybank = 0
		end
	end
end)
-- FIN GIVE DE L'ARGENT EN BANQUE

-- GIVE DE L'ARGENT SALE
function admin_give_dirty()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez le montant à vous octroyer...")
	inputmoneydirty = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputmoneydirty == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputmoneydirty = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputmoneydirty = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputmoneydirty = 0
			end
		end
		if inputmoneydirty == 2 then
			local repMoney = GetOnscreenKeyboardResult()
			local money = tonumber(repMoney)
			
			TriggerServerEvent('Admin2Menu:giveDirtyMoney', money)
			inputmoneydirty = 0
		end
	end
end)
-- FIN GIVE DE L'ARGENT SALE

-- Message reseller
function reseller()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez le message reseller...")
	inputmoneydirty1 = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputmoneydirty1 == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputmoneydirty1 = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputmoneydirty1 = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputmoneydirty1 = 0
			end
		end
		if inputmoneydirty1 == 2 then
			local repMoney = GetOnscreenKeyboardResult()
			local money = tonumber(repMoney)
			local ped = GetPlayerPed(PlayerId())
			local coords = GetEntityCoords(ped, false)
			local name = GetPlayerName(PlayerId())
			local x, y, z = table.unpack(GetEntityCoords(ped, true))
			
			TriggerServerEvent('Admin2Menu:MessageResellerCoke', money, x, y, z)
			inputmoneydirty1 = 0
		end
	end
end)

RegisterNetEvent('Admin2Menu:MessageResellerCoke2')
AddEventHandler('Admin2Menu:MessageResellerCoke2', function(message, x, y, z)
	local message = message
	PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	ESX.ShowAdvancedNotification('RESELLER', 'EVENEMENT RESELLER', 'Petit cadeau de ma part, une voiture avec 500 de coke. Premier arriver premier servis. Bonne chasse.', 'CHAR_LESTER_DEATHWISH', 1)

	local alpha = 5000
	local blipsRenfort = AddBlipForCoord(x, y, z)
	local blipsRenfort2 = AddBlipForCoord(x, y, z)
	SetBlipSprite(blipsRenfort2, 514)
	SetBlipScale(blipsRenfort2, 0.85) -- set scale
	SetBlipColour(blipsRenfort2, 1)
	SetBlipAlpha(blipsRenfort2, alpha)
	PulseBlip(blipsRenfort2)

	SetBlipSprite(blipsRenfort, 161)
	SetBlipScale(blipsRenfort, 2.0) -- set scale
	SetBlipColour(blipsRenfort, 1)
	SetBlipAlpha(blipsRenfort, alpha)
	PulseBlip(blipsRenfort)
	
	while alpha ~= 0 do
		Citizen.Wait(10)
		alpha = alpha - 1
		SetBlipAlpha(blipsRenfort, alpha)
		SetBlipAlpha(blipsRenfort2, alpha)

		if alpha == 0 then
			RemoveBlip(blipsRenfort)
			RemoveBlip(blipsRenfort2)
			PlaySoundFrontend(-1, "HACKING_SUCCESS", 0, 1)
			return
		end
	end
end)

RegisterNetEvent('Admin2Menu:MessageResellerCoke2Police')
AddEventHandler('Admin2Menu:MessageResellerCoke2Police', function(message, x, y, z)
	Citizen.Wait(5*1000)
	local message = message
	PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	ESX.ShowAdvancedNotification('INDIC RESELLER', 'RESELLER EN VILLE !', 'Le reselleur vient de passer une annonce, 500 de coke à récupérer, intervention demander.', 'CHAR_BLOCKED', 1)

	local alpha = 5000
	local blipsRenfort = AddBlipForCoord(x, y, z)
	local blipsRenfort2 = AddBlipForCoord(x, y, z)
	SetBlipSprite(blipsRenfort2, 514)
	SetBlipScale(blipsRenfort2, 0.85) -- set scale
	SetBlipColour(blipsRenfort2, 1)
	SetBlipAlpha(blipsRenfort2, alpha)
	PulseBlip(blipsRenfort2)

	SetBlipSprite(blipsRenfort, 161)
	SetBlipScale(blipsRenfort, 2.0) -- set scale
	SetBlipColour(blipsRenfort, 1)
	SetBlipAlpha(blipsRenfort, alpha)
	PulseBlip(blipsRenfort)
	
	while alpha ~= 0 do
		Citizen.Wait(10)
		alpha = alpha - 1
		SetBlipAlpha(blipsRenfort, alpha)
		SetBlipAlpha(blipsRenfort2, alpha)

		if alpha == 0 then
			RemoveBlip(blipsRenfort)
			RemoveBlip(blipsRenfort2)
			PlaySoundFrontend(-1, "HACKING_SUCCESS", 0, 1)
			return
		end
	end
end)

function reseller2()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez le message reseller...")
	inputmoneydirty2 = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputmoneydirty2 == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputmoneydirty2 = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputmoneydirty2 = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputmoneydirty2 = 0
			end
		end
		if inputmoneydirty2 == 2 then
			local repMoney = GetOnscreenKeyboardResult()
			local money = tonumber(repMoney)
			local ped = GetPlayerPed(PlayerId())
			local coords = GetEntityCoords(ped, false)
			local name = GetPlayerName(PlayerId())
			local x, y, z = table.unpack(GetEntityCoords(ped, true))
			
			TriggerServerEvent('Admin2Menu:MessageResellerWeed', money, x, y, z)
			inputmoneydirty2 = 0
		end
	end
end)

RegisterNetEvent('Admin2Menu:MessageResellerWeed2')
AddEventHandler('Admin2Menu:MessageResellerWeed2', function(message, x, y, z)
	local message = message
	PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	ESX.ShowAdvancedNotification('RESELLER', 'EVENEMENT RESELLER', 'Petit cadeau de ma part, une voiture avec 500 de weed. Premier arriver premier servis. Bonne chasse.', 'CHAR_LESTER_DEATHWISH', 1)

	local alpha = 5000
	local blipsRenfort = AddBlipForCoord(x, y, z)
	local blipsRenfort2 = AddBlipForCoord(x, y, z)
	SetBlipSprite(blipsRenfort2, 496)
	SetBlipScale(blipsRenfort2, 0.85) -- set scale
	SetBlipColour(blipsRenfort2, 1)
	SetBlipAlpha(blipsRenfort2, alpha)
	PulseBlip(blipsRenfort2)

	SetBlipSprite(blipsRenfort, 161)
	SetBlipScale(blipsRenfort, 2.0) -- set scale
	SetBlipColour(blipsRenfort, 1)
	SetBlipAlpha(blipsRenfort, alpha)
	PulseBlip(blipsRenfort)
	
	while alpha ~= 0 do
		Citizen.Wait(10)
		alpha = alpha - 1
		SetBlipAlpha(blipsRenfort, alpha)
		SetBlipAlpha(blipsRenfort2, alpha)

		if alpha == 0 then
			RemoveBlip(blipsRenfort)
			RemoveBlip(blipsRenfort2)
			PlaySoundFrontend(-1, "HACKING_SUCCESS", 0, 1)
			return
		end
	end
end)

RegisterNetEvent('Admin2Menu:MessageResellerWeed2Police')
AddEventHandler('Admin2Menu:MessageResellerWeed2Police', function(message, x, y, z)
	Citizen.Wait(5*1000)
	local message = message
	PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	ESX.ShowAdvancedNotification('INDIC RESELLER', 'RESELLER EN VILLE !', 'Le reselleur vient de passer une annonce, 500 de weed à récupérer, intervention demander.', 'CHAR_BLOCKED', 1)

	local alpha = 5000
	local blipsRenfort = AddBlipForCoord(x, y, z)
	local blipsRenfort2 = AddBlipForCoord(x, y, z)
	SetBlipSprite(blipsRenfort2, 496)
	SetBlipScale(blipsRenfort2, 0.85) -- set scale
	SetBlipColour(blipsRenfort2, 1)
	SetBlipAlpha(blipsRenfort2, alpha)
	PulseBlip(blipsRenfort2)

	SetBlipSprite(blipsRenfort, 161)
	SetBlipScale(blipsRenfort, 2.0) -- set scale
	SetBlipColour(blipsRenfort, 1)
	SetBlipAlpha(blipsRenfort, alpha)
	PulseBlip(blipsRenfort)
	
	while alpha ~= 0 do
		Citizen.Wait(10)
		alpha = alpha - 1
		SetBlipAlpha(blipsRenfort, alpha)
		SetBlipAlpha(blipsRenfort2, alpha)

		if alpha == 0 then
			RemoveBlip(blipsRenfort)
			RemoveBlip(blipsRenfort2)
			PlaySoundFrontend(-1, "HACKING_SUCCESS", 0, 1)
			return
		end
	end
end)

function reseller3()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez le message reseller...")
	inputmoneydirty3 = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputmoneydirty3 == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputmoneydirty3 = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputmoneydirty3 = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputmoneydirty3 = 0
			end
		end
		if inputmoneydirty3 == 2 then
			local repMoney = GetOnscreenKeyboardResult()
			local money = tonumber(repMoney)
			local ped = GetPlayerPed(PlayerId())
			local coords = GetEntityCoords(ped, false)
			local name = GetPlayerName(PlayerId())
			local x, y, z = table.unpack(GetEntityCoords(ped, true))
			
			TriggerServerEvent('Admin2Menu:MessageResellerOpium', money, x, y, z)
			inputmoneydirty3 = 0
		end
	end
end)

RegisterNetEvent('Admin2Menu:MessageResellerOpium2')
AddEventHandler('Admin2Menu:MessageResellerOpium2', function(message, x, y, z)
	local message = message
	PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	ESX.ShowAdvancedNotification('RESELLER', 'EVENEMENT RESELLER', 'Petit cadeau de ma part, une voiture avec 500 d\'opium. Premier arriver premier servis. Bonne chasse.', 'CHAR_LESTER_DEATHWISH', 1)

	local alpha = 5000
	local blipsRenfort = AddBlipForCoord(x, y, z)
	local blipsRenfort2 = AddBlipForCoord(x, y, z)
	SetBlipSprite(blipsRenfort2, 403)
	SetBlipScale(blipsRenfort2, 0.85) -- set scale
	SetBlipColour(blipsRenfort2, 1)
	SetBlipAlpha(blipsRenfort2, alpha)
	PulseBlip(blipsRenfort2)

	SetBlipSprite(blipsRenfort, 161)
	SetBlipScale(blipsRenfort, 2.0) -- set scale
	SetBlipColour(blipsRenfort, 1)
	SetBlipAlpha(blipsRenfort, alpha)
	PulseBlip(blipsRenfort)
	
	while alpha ~= 0 do
		Citizen.Wait(10)
		alpha = alpha - 1
		SetBlipAlpha(blipsRenfort, alpha)
		SetBlipAlpha(blipsRenfort2, alpha)

		if alpha == 0 then
			RemoveBlip(blipsRenfort)
			RemoveBlip(blipsRenfort2)
			PlaySoundFrontend(-1, "HACKING_SUCCESS", 0, 1)
			return
		end
	end
end)

RegisterNetEvent('Admin2Menu:MessageResellerOpium2Police')
AddEventHandler('Admin2Menu:MessageResellerOpium2Police', function(message, x, y, z)
	Citizen.Wait(5*1000)
	local message = message
	PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	ESX.ShowAdvancedNotification('INDIC RESELLER', 'RESELLER EN VILLE !', 'Le reselleur vient de passer une annonce, 500 d\'opium à récupérer, intervention demander.', 'CHAR_BLOCKED', 1)

	local alpha = 5000
	local blipsRenfort = AddBlipForCoord(x, y, z)
	local blipsRenfort2 = AddBlipForCoord(x, y, z)
	SetBlipSprite(blipsRenfort2, 403)
	SetBlipScale(blipsRenfort2, 0.85) -- set scale
	SetBlipColour(blipsRenfort2, 1)
	SetBlipAlpha(blipsRenfort2, alpha)
	PulseBlip(blipsRenfort2)

	SetBlipSprite(blipsRenfort, 161)
	SetBlipScale(blipsRenfort, 2.0) -- set scale
	SetBlipColour(blipsRenfort, 1)
	SetBlipAlpha(blipsRenfort, alpha)
	PulseBlip(blipsRenfort)
	
	while alpha ~= 0 do
		Citizen.Wait(10)
		alpha = alpha - 1
		SetBlipAlpha(blipsRenfort, alpha)
		SetBlipAlpha(blipsRenfort2, alpha)

		if alpha == 0 then
			RemoveBlip(blipsRenfort)
			RemoveBlip(blipsRenfort2)
			PlaySoundFrontend(-1, "HACKING_SUCCESS", 0, 1)
			return
		end
	end
end)

function reseller4()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez le message reseller...")
	inputmoneydirty4 = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputmoneydirty4 == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputmoneydirty4 = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputmoneydirty4 = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputmoneydirty4 = 0
			end
		end
		if inputmoneydirty4 == 2 then
			local repMoney = GetOnscreenKeyboardResult()
			local money = tonumber(repMoney)
			local ped = GetPlayerPed(PlayerId())
			local coords = GetEntityCoords(ped, false)
			local name = GetPlayerName(PlayerId())
			local x, y, z = table.unpack(GetEntityCoords(ped, true))
			
			TriggerServerEvent('Admin2Menu:MessageResellerPack', money, x, y, z)
			inputmoneydirty4 = 0
		end
	end
end)

RegisterNetEvent('Admin2Menu:MessageResellerPack2')
AddEventHandler('Admin2Menu:MessageResellerPack2', function(message, x, y, z)
	local message = message
	PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	ESX.ShowAdvancedNotification('RESELLER', 'EVENEMENT RESELLER', 'Petit cadeau de ma part, une livraison ne sait pas bien déroulé, tout est à vous. Bonne chasse.', 'CHAR_LESTER_DEATHWISH', 1)

	local alpha = 5000
	local blipsRenfort = AddBlipForCoord(x, y, z)
	local blipsRenfort2 = AddBlipForCoord(x, y, z)
	SetBlipSprite(blipsRenfort2, 478)
	SetBlipScale(blipsRenfort2, 0.85) -- set scale
	SetBlipColour(blipsRenfort2, 1)
	SetBlipAlpha(blipsRenfort2, alpha)
	PulseBlip(blipsRenfort2)

	SetBlipSprite(blipsRenfort, 161)
	SetBlipScale(blipsRenfort, 2.0) -- set scale
	SetBlipColour(blipsRenfort, 1)
	SetBlipAlpha(blipsRenfort, alpha)
	PulseBlip(blipsRenfort)
	
	while alpha ~= 0 do
		Citizen.Wait(10)
		alpha = alpha - 1
		SetBlipAlpha(blipsRenfort, alpha)
		SetBlipAlpha(blipsRenfort2, alpha)

		if alpha == 0 then
			RemoveBlip(blipsRenfort)
			RemoveBlip(blipsRenfort2)
			PlaySoundFrontend(-1, "HACKING_SUCCESS", 0, 1)
			return
		end
	end
end)

RegisterNetEvent('Admin2Menu:MessageResellerPack2Police')
AddEventHandler('Admin2Menu:MessageResellerPack2Police', function(message, x, y, z)
	Citizen.Wait(5*1000)
	local message = message
	PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	ESX.ShowAdvancedNotification('INDIC RESELLER', 'RESELLER EN VILLE !', 'Le reselleur vient de passer une annonce, une cargaison à récupérer, intervention demander.', 'CHAR_BLOCKED', 1)

	local alpha = 5000
	local blipsRenfort = AddBlipForCoord(x, y, z)
	local blipsRenfort2 = AddBlipForCoord(x, y, z)
	SetBlipSprite(blipsRenfort2, 478)
	SetBlipScale(blipsRenfort2, 0.85) -- set scale
	SetBlipColour(blipsRenfort2, 1)
	SetBlipAlpha(blipsRenfort2, alpha)
	PulseBlip(blipsRenfort2)

	SetBlipSprite(blipsRenfort, 161)
	SetBlipScale(blipsRenfort, 2.0) -- set scale
	SetBlipColour(blipsRenfort, 1)
	SetBlipAlpha(blipsRenfort, alpha)
	PulseBlip(blipsRenfort)
	
	while alpha ~= 0 do
		Citizen.Wait(10)
		alpha = alpha - 1
		SetBlipAlpha(blipsRenfort, alpha)
		SetBlipAlpha(blipsRenfort2, alpha)

		if alpha == 0 then
			RemoveBlip(blipsRenfort)
			RemoveBlip(blipsRenfort2)
			PlaySoundFrontend(-1, "HACKING_SUCCESS", 0, 1)
			return
		end
	end
end)

function reseller5()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez le message reseller...")
	inputmoneydirty5 = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputmoneydirty5 == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputmoneydirty5 = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputmoneydirty5 = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputmoneydirty5 = 0
			end
		end
		if inputmoneydirty5 == 2 then
			local repMoney = GetOnscreenKeyboardResult()
			local money = tonumber(repMoney)
			local ped = GetPlayerPed(PlayerId())
			local coords = GetEntityCoords(ped, false)
			local name = GetPlayerName(PlayerId())
			local x, y, z = table.unpack(GetEntityCoords(ped, true))
			
			TriggerServerEvent('Admin2Menu:MessageResellerFin', money, x, y, z)
			inputmoneydirty5 = 0
		end
	end
end)

RegisterNetEvent('Admin2Menu:MessageResellerFin2')
AddEventHandler('Admin2Menu:MessageResellerFin2', function(message, x, y, z)
	local message = message
	PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	ESX.ShowAdvancedNotification('RESELLER', 'EVENEMENT RESELLER', 'Mmh, mission terminé, la cargaison à été récupéré. Rester attentif pour la prochaine missions.', 'CHAR_LESTER_DEATHWISH', 1)
end)

function reseller6()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez le message reseller...")
	inputmoneydirty6 = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputmoneydirty6 == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputmoneydirty6 = 0
			elseif UpdateOnscreenKeyboard() == 1 then
				inputmoneydirty6 = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputmoneydirty6 = 0
			end
		end
		if inputmoneydirty6 == 2 then
			local repMoney = GetOnscreenKeyboardResult()
			local money = tonumber(repMoney)
			local ped = GetPlayerPed(PlayerId())
			local coords = GetEntityCoords(ped, false)
			local name = GetPlayerName(PlayerId())
			local x, y, z = table.unpack(GetEntityCoords(ped, true))
			
			TriggerServerEvent('Admin2Menu:MessageResellerPolice', money, x, y, z)
			inputmoneydirty6 = 0
		end
	end
end)

RegisterNetEvent('Admin2Menu:MessageResellerpolice2')
AddEventHandler('Admin2Menu:MessageResellerpolice2', function(message, x, y, z)
	local message = message
	PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	ESX.ShowAdvancedNotification('RESELLER', 'EVENEMENT RESELLER', 'Mmh, la police à été repéré sur les lieux, préparer vos armes à feu. Bonne chasse.', 'CHAR_LESTER_DEATHWISH', 1)
end)

function reseller7()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez le message reseller...")
	inputmoneydirty7 = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputmoneydirty7 == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputmoneydirty7 = 0
			elseif UpdateOnscreenKeyboard() == 1 then
				inputmoneydirty7 = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputmoneydirty7 = 0
			end
		end
		if inputmoneydirty7 == 2 then
			local repMoney = GetOnscreenKeyboardResult()
			local money = tonumber(repMoney)
			local ped = GetPlayerPed(PlayerId())
			local coords = GetEntityCoords(ped, false)
			local name = GetPlayerName(PlayerId())
			local x, y, z = table.unpack(GetEntityCoords(ped, true))
			
			TriggerServerEvent('Admin2Menu:MessageResellerArme', money, x, y, z)
			inputmoneydirty7 = 0
		end
	end
end)

RegisterNetEvent('Admin2Menu:MessageResellerArme2')
AddEventHandler('Admin2Menu:MessageResellerArme2', function(message, x, y, z)
	local message = message
	PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	ESX.ShowAdvancedNotification('RESELLER', 'EVENEMENT RESELLER', 'Livraison d\'arme, préparez vous ça vas tirer! Tout est à vous. Bonne chasse.', 'CHAR_LESTER_DEATHWISH', 1)

	local alpha = 5000
	local blipsRenfort = AddBlipForCoord(x, y, z)
	local blipsRenfort2 = AddBlipForCoord(x, y, z)
	SetBlipSprite(blipsRenfort2, 150)
	SetBlipScale(blipsRenfort2, 0.85) -- set scale
	SetBlipColour(blipsRenfort2, 1)
	SetBlipAlpha(blipsRenfort2, alpha)
	PulseBlip(blipsRenfort2)

	SetBlipSprite(blipsRenfort, 161)
	SetBlipScale(blipsRenfort, 2.0) -- set scale
	SetBlipColour(blipsRenfort, 1)
	SetBlipAlpha(blipsRenfort, alpha)
	PulseBlip(blipsRenfort)
	
	while alpha ~= 0 do
		Citizen.Wait(10)
		alpha = alpha - 1
		SetBlipAlpha(blipsRenfort, alpha)
		SetBlipAlpha(blipsRenfort2, alpha)

		if alpha == 0 then
			RemoveBlip(blipsRenfort)
			RemoveBlip(blipsRenfort2)
			PlaySoundFrontend(-1, "HACKING_SUCCESS", 0, 1)
			return
		end
	end
end)

RegisterNetEvent('Admin2Menu:MessageResellerArme2Police')
AddEventHandler('Admin2Menu:MessageResellerArme2Police', function(message, x, y, z)
	Citizen.Wait(5*1000)
	local message = message
	PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	ESX.ShowAdvancedNotification('INDIC RESELLER', 'RESELLER EN VILLE !', 'Le reselleur vient de passer une annonce, une cargaison d\'arme à récupérer, intervention demander.', 'CHAR_BLOCKED', 1)

	local alpha = 5000
	local blipsRenfort = AddBlipForCoord(x, y, z)
	local blipsRenfort2 = AddBlipForCoord(x, y, z)
	SetBlipSprite(blipsRenfort2, 150)
	SetBlipScale(blipsRenfort2, 0.85) -- set scale
	SetBlipColour(blipsRenfort2, 1)
	SetBlipAlpha(blipsRenfort2, alpha)
	PulseBlip(blipsRenfort2)

	SetBlipSprite(blipsRenfort, 161)
	SetBlipScale(blipsRenfort, 2.0) -- set scale
	SetBlipColour(blipsRenfort, 1)
	SetBlipAlpha(blipsRenfort, alpha)
	PulseBlip(blipsRenfort)
	
	while alpha ~= 0 do
		Citizen.Wait(10)
		alpha = alpha - 1
		SetBlipAlpha(blipsRenfort, alpha)
		SetBlipAlpha(blipsRenfort2, alpha)

		if alpha == 0 then
			RemoveBlip(blipsRenfort)
			RemoveBlip(blipsRenfort2)
			PlaySoundFrontend(-1, "HACKING_SUCCESS", 0, 1)
			return
		end
	end
end)


function reseller8()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez le message reseller...")
	inputmoneydirty8 = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputmoneydirty8 == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputmoneydirty8 = 0
			elseif UpdateOnscreenKeyboard() == 1 then
				inputmoneydirty8 = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputmoneydirty8 = 0
			end
		end
		if inputmoneydirty8 == 2 then
			local repMoney = GetOnscreenKeyboardResult()
			local money = tonumber(repMoney)
			local ped = GetPlayerPed(PlayerId())
			local coords = GetEntityCoords(ped, false)
			local name = GetPlayerName(PlayerId())
			local x, y, z = table.unpack(GetEntityCoords(ped, true))
			
			TriggerServerEvent('Admin2Menu:MessageResellerVoiture', money, x, y, z)
			inputmoneydirty8 = 0
		end
	end
end)

RegisterNetEvent('Admin2Menu:MessageResellerVoiture2')
AddEventHandler('Admin2Menu:MessageResellerVoiture2', function(message, x, y, z)
	local message = message
	PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	ESX.ShowAdvancedNotification('RESELLER', 'EVENEMENT RESELLER', 'Une voiture Super Sportive sa te tente ? Vient la chercher. Bonne chasse.', 'CHAR_LESTER_DEATHWISH', 1)

	local alpha = 5000
	local blipsRenfort = AddBlipForCoord(x, y, z)
	local blipsRenfort2 = AddBlipForCoord(x, y, z)
	SetBlipSprite(blipsRenfort2, 225)
	SetBlipScale(blipsRenfort2, 0.85) -- set scale
	SetBlipColour(blipsRenfort2, 1)
	SetBlipAlpha(blipsRenfort2, alpha)
	PulseBlip(blipsRenfort2)

	SetBlipSprite(blipsRenfort, 161)
	SetBlipScale(blipsRenfort, 2.0) -- set scale
	SetBlipColour(blipsRenfort, 1)
	SetBlipAlpha(blipsRenfort, alpha)
	PulseBlip(blipsRenfort)
	-- revente des véhicules
	
	local blipsRenfort3 = AddBlipForCoord(-522.87, -1713.99, 18.33)
	SetBlipSprite(blipsRenfort3, 225)
	SetBlipColour(blipsRenfort3, 1)
	SetBlipScale(blipsRenfort3, 0.8)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Revente véhicule Reseller')
	EndTextCommandSetBlipName(blipsRenfort3)

	local blipsRenfort4 = AddBlipForCoord(-522.87, -1713.99, 18.33)
	SetBlipSprite(blipsRenfort4, 161)
	SetBlipScale(blipsRenfort4, 2.0) -- set scale
	SetBlipColour(blipsRenfort4, 1)
	SetBlipAlpha(blipsRenfort4, alpha)
	PulseBlip(blipsRenfort4)

	while alpha ~= 0 do
		Citizen.Wait(10)
		alpha = alpha - 1
		SetBlipAlpha(blipsRenfort, alpha)
		SetBlipAlpha(blipsRenfort2, alpha)

		if alpha == 0 then
			RemoveBlip(blipsRenfort)
			RemoveBlip(blipsRenfort2)
			RemoveBlip(blipsRenfort3)
			RemoveBlip(blipsRenfort4)
			PlaySoundFrontend(-1, "HACKING_SUCCESS", 0, 1)
			return
		end
	end
end)

RegisterNetEvent('Admin2Menu:MessageResellerVoiture2Police')
AddEventHandler('Admin2Menu:MessageResellerVoiture2Police', function(message, x, y, z)
	Citizen.Wait(5*1000)
	local message = message
	PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	ESX.ShowAdvancedNotification('INDIC RESELLER', 'RESELLER EN VILLE !', 'Le reselleur vient de passer une annonce, une voiture à récupérer, intervention demander.', 'CHAR_BLOCKED', 1)

	local alpha = 5000
	local blipsRenfort = AddBlipForCoord(x, y, z)
	local blipsRenfort2 = AddBlipForCoord(x, y, z)
	SetBlipSprite(blipsRenfort2, 225)
	SetBlipScale(blipsRenfort2, 0.85) -- set scale
	SetBlipColour(blipsRenfort2, 1)
	SetBlipAlpha(blipsRenfort2, alpha)
	PulseBlip(blipsRenfort2)

	SetBlipSprite(blipsRenfort, 161)
	SetBlipScale(blipsRenfort, 2.0) -- set scale
	SetBlipColour(blipsRenfort, 1)
	SetBlipAlpha(blipsRenfort, alpha)
	PulseBlip(blipsRenfort)

	-- revente des véhicules
	
	local blipsRenfort3 = AddBlipForCoord(-522.87, -1713.99, 18.33)
	SetBlipSprite(blipsRenfort3, 225)
	SetBlipColour(blipsRenfort3, 1)
	SetBlipScale(blipsRenfort3, 0.8)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Revente véhicule Reseller')
	EndTextCommandSetBlipName(blipsRenfort3)

	local blipsRenfort4 = AddBlipForCoord(-522.87, -1713.99, 18.33)
	SetBlipSprite(blipsRenfort4, 161)
	SetBlipScale(blipsRenfort4, 2.0) -- set scale
	SetBlipColour(blipsRenfort4, 1)
	SetBlipAlpha(blipsRenfort4, alpha)
	PulseBlip(blipsRenfort4)

	while alpha ~= 0 do
		Citizen.Wait(10)
		alpha = alpha - 1
		SetBlipAlpha(blipsRenfort, alpha)
		SetBlipAlpha(blipsRenfort2, alpha)

		if alpha == 0 then
			RemoveBlip(blipsRenfort)
			RemoveBlip(blipsRenfort2)
			RemoveBlip(blipsRenfort3)
			RemoveBlip(blipsRenfort4)
			PlaySoundFrontend(-1, "HACKING_SUCCESS", 0, 1)
			return
		end
	end
end)

function reseller9()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez la plaque...")
	plaque = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if plaque == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				plaque = 0
			elseif UpdateOnscreenKeyboard() == 1 then
				plaque = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				plaque = 0
			end
		end
		if plaque == 2 then
			local playerPed = GetPlayerPed(-1)
			local playerVeh = GetVehiclePedIsIn(playerPed, true)
			local repMoney = GetOnscreenKeyboardResult()	
			SetVehicleNumberPlateText(playerVeh, repMoney)
			plaque = 0
		end
	end
end)

-- Afficher Coord
function modo_showcoord()
	if showcoord then
		showcoord = false
	else
		showcoord = true
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		
		if showcoord then
			local playerPos = GetEntityCoords(GetPlayerPed(-1))
			local playerHeading = GetEntityHeading(GetPlayerPed(-1))
			Text("~r~X~s~: " ..playerPos.x.." ~b~Y~s~: " ..playerPos.y.." ~g~Z~s~: " ..playerPos.z.." ~y~Angle~s~: " ..playerHeading.."")
		end
		
	end
end)
-- FIN Afficher Coord


function player_blips()
	if blips then
		blips = false
	else
		blips = true
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if blips then
			for player = 0, 256 do
				if player ~= currentPlayer and NetworkIsPlayerActive(player) then
					local playerPed = GetPlayerPed(player)
					local playerName = GetPlayerName(player)
					RemoveBlip(blips[player])
					local new_blip = AddBlipForEntity(playerPed)
					ped = GetPlayerPed( id )
					blip = GetBlipFromEntity( ped )
					SetBlipSprite(new_blip, 1 )
					-- Enable text on blip
					SetBlipCategory(new_blip, 2)
					-- Add player name to blip
					SetBlipNameToPlayerName(new_blip, player)
					--SetBlipNameToPlayerName( blip, id ) -- update blip name
					SetBlipRotation( blip, math.ceil( GetEntityHeading( veh ) ) ) -- update rotation
					-- Shrink player blips slightly
					SetBlipScale(new_blip, 0.85)
					-- Add nametags above head
					Citizen.InvokeNative(0xBFEFE3321A3F5015, playerPed, playerName, false, false, '', false)
					-- Record blip so we don't keep recreating it
					blips[player] = new_blip
				end
				if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= GetPlayerPed(-1) then
					ped = GetPlayerPed(id)
					blip = GetBlipFromEntity(ped)

					if not DoesBlipExist(blip) then
						blip = AddBlipForEntity(ped)
						SetBlipSprite(blip, 1)
						ShowHeadingIndicatorOnBlip(blip, true)
					else
						veh = GetVehiclePedIsIn(ped, false)
						blipSprite = GetBlipSprite(blip)
						if not GetEntityHealth(ped) then
							if blipSprite ~= 274 then
								SetBlipSprite(blip, 274)
								ShowHeadingIndicatorOnBlip(blip, false)
							end
						elseif veh then
							vehClass = GetVehicleClass(veh)
							vehModel = GetEntityModel(veh)
							if vehClass == 15 then
								if blipSprite ~= 422 then
									SetBlipSprite(blip, 422)
									ShowHeadingIndicatorOnBlip(blip, false)
								end
							elseif vehClass == 8 then
								if blipSprite ~= 226 then
									SetBlipSprite(blip, 226)
									ShowHeadingIndicatorOnBlip(blip, false)
								end
							elseif vehClass == 16 then
								if vehModel == GetHashKey("besra") or vehModel == GetHashKey("hydra") or vehModel == GetHashKey("lazer") then
									if blipSprite ~= 424 then
										SetBlipSprite(blip, 424)
										ShowHeadingIndicatorOnBlip(blip, false)
									end
								elseif blipSprite ~= 423 then
									SetBlipSprite(blip, 423)
									ShowHeadingIndicatorOnBlip(blip, false)
								end
							elseif vehClass == 14 then
								if blipSprite ~= 427 then
									SetBlipSprite(blip, 427)
									ShowHeadingIndicatorOnBlip(blip, false)
								end
							elseif vehModel == GetHashKey("insurgent") or vehModel == GetHashKey("insurgent2") or vehModel == GetHashKey("insurgent3") then
								if blipSprite ~= 426 then
									SetBlipSprite(blip, 426)
									ShowHeadingIndicatorOnBlip(blip, false)
								end
							elseif vehModel == GetHashKey("limo2") then
								if blipSprite ~= 460 then
									SetBlipSprite(blip, 460)
									ShowHeadingIndicatorOnBlip(blip, false)
								end
							elseif vehModel == GetHashKey("rhino") then
								if blipSprite ~= 421 then
									SetBlipSprite(blip, 421)
									ShowHeadingIndicatorOnBlip(blip, false)
								end
							elseif vehModel == GetHashKey("trash") or vehModel == GetHashKey("trash2") then
								if blipSprite ~= 318 then
									SetBlipSprite(blip, 318)
									ShowHeadingIndicatorOnBlip(blip, false)
								end
							elseif vehModel == GetHashKey("pbus") then
								if blipSprite ~= 513 then
									SetBlipSprite(blip, 513)
									ShowHeadingIndicatorOnBlip(blip, false)
								end
							elseif vehModel == GetHashKey("seashark") or vehModel == GetHashKey("seashark2") or vehModel == GetHashKey("seashark3") then
								if blipSprite ~= 471 then
									SetBlipSprite(blip, 471)
									ShowHeadingIndicatorOnBlip(blip, false)
								end
							elseif vehModel == GetHashKey("cargobob") or vehModel == GetHashKey("cargobob2") or vehModel == GetHashKey("cargobob3") or vehModel == GetHashKey("cargobob4") then
								if blipSprite ~= 481 then
									SetBlipSprite(blip, 481)
									ShowHeadingIndicatorOnBlip(blip, false)
								end
							elseif vehModel == GetHashKey("technical") or vehModel == GetHashKey("technical2") or vehModel == GetHashKey("technical3") then
								if blipSprite ~= 426 then
									SetBlipSprite(blip, 426)
									ShowHeadingIndicatorOnBlip(blip, false)
								end
							elseif vehModel == GetHashKey("taxi") then
								if blipSprite ~= 198 then
									SetBlipSprite(blip, 198)
									ShowHeadingIndicatorOnBlip(blip, false)
								end
							elseif vehModel == GetHashKey("fbi") or vehModel == GetHashKey("fbi2") or vehModel == GetHashKey("police2") or vehModel == GetHashKey("police3")
								or vehModel == GetHashKey("police") or vehModel == GetHashKey("sheriff2") or vehModel == GetHashKey("sheriff")
								or vehModel == GetHashKey("policeold2") or vehModel == GetHashKey("policeold1") then
								if blipSprite ~= 56 then
									SetBlipSprite(blip, 56)
									ShowHeadingIndicatorOnBlip(blip, false)
								end
							elseif blipSprite ~= 1 then 
								SetBlipSprite(blip, 1)
								ShowHeadingIndicatorOnBlip(blip, true)
							end
							passengers = GetVehicleNumberOfPassengers(veh)
							if passengers then
								if not IsVehicleSeatFree(veh, -1) then
									passengers = passengers + 1
								end
								ShowNumberOnBlip(blip, passengers)
							else
								HideNumberOnBlip(blip)
							end
						else
							HideNumberOnBlip(blip)
							if blipSprite ~= 1 then
								SetBlipSprite(blip, 1)
								ShowHeadingIndicatorOnBlip(blip, true)
							end
						end
						
						SetBlipRotation(blip, math.ceil(GetEntityHeading(veh)))
						SetBlipNameToPlayerName(blip, id)
						SetBlipScale(blip,  0.85)
						if IsPauseMenuActive() then
							SetBlipAlpha( blip, 255 )
						else
							x1, y1 = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
							x2, y2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
							distance = (math.floor(math.abs(math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))) / -1)) + 900

							if distance < 0 then
								distance = 0
							elseif distance > 255 then
								distance = 255
							end
							SetBlipAlpha(blip, distance)
						end
					end
				end
			end
		end
	end
end)

-- Afficher Nom
function modo_showname()
	if showname then
		showname = false
	else
		Notify("Ouvrir/Fermer le menu pause pour afficher les noms")
		showname = true
	end
end

Citizen.CreateThread(function()
	while true do
		Wait( 1 )
		if showname then
			for id = 0, 200 do
				if NetworkIsPlayerActive( id ) and GetPlayerPed( id ) ~= GetPlayerPed( -1 ) then
					ped = GetPlayerPed( id )
					blip = GetBlipFromEntity( ped )
					headId = Citizen.InvokeNative( 0xBFEFE3321A3F5015, ped, (GetPlayerServerId( id )..' - '..GetPlayerName( id )), false, false, "", false )
				end
			end
		else
			for id = 0, 200 do
				if NetworkIsPlayerActive( id ) and GetPlayerPed( id ) ~= GetPlayerPed( -1 ) then
					ped = GetPlayerPed( id )
					blip = GetBlipFromEntity( ped )
					headId = Citizen.InvokeNative( 0xBFEFE3321A3F5015, ped, (' '), false, false, "", false )
				end
			end
		end
	end
end)
-- FIN Afficher Nom

-- TP MARCKER
function admin_tp_marcker()
	
	ESX.TriggerServerCallback('NB:getUsergroup', function(group)
		playergroup = group
		
		if playergroup == 'admin' or playergroup == 'superadmin' or playergroup == 'owner' then
			local playerPed = GetPlayerPed(-1)
			local WaypointHandle = GetFirstBlipInfoId(8)
			if DoesBlipExist(WaypointHandle) then
				local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, WaypointHandle, Citizen.ResultAsVector())
				--SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, coord.z, false, false, false, true)
				SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, -199.5, false, false, false, true)
				Notify("Téléporté sur le marqueur !")
			else
				Notify("Pas de marqueur sur la carte !")
			end
		end
		
	end)
end
-- FIN TP MARCKER

-- HEAL JOUEUR
function admin_heal_player()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez l'ID du joueur...")
	inputheal = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputheal == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputheal = 0
			elseif UpdateOnscreenKeyboard() == 1 then
				inputheal = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputheal = 0
			end
		end
		if inputheal == 2 then
		local healply = GetOnscreenKeyboardResult()
		TriggerServerEvent('esx_ambulancejob:revive', healply)
		
        inputheal = 0
		end
	end
end)
-- FIN HEAL JOUEUR

-- SPEC JOUEUR
function admin_spec_player()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	Notify("~b~Entrez l'ID du joueur...")
	inputspec = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputspec == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputspec = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputspec = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputspec = 0
			end
		end
		if inputspec == 2 then
		local target = GetOnscreenKeyboardResult()
		
		TriggerEvent('es_camera:spectate', source, target)
		
        inputspec = 0
		end
	end
end)
-- FIN SPEC JOUEUR

---------------------------------------------------------------------------Me concernant

function openInventaire()
	TriggerEvent('NB:closeAllSubMenu')
	TriggerEvent('NB:closeAllMenu')
	TriggerEvent('NB:closeMenuKey')
	
	ESX.ShowInventory()
end

function openFacture()
	TriggerEvent('NB:closeAllSubMenu')
	TriggerEvent('NB:closeAllMenu')
	TriggerEvent('NB:closeMenuKey')
	
	TriggerEvent('NB:openMenuFactures')
end

function openAnimation()
	TriggerEvent('NB:closeAllSubMenu')
	TriggerEvent('NB:closeAllMenu')
	TriggerEvent('NB:closeMenuKey')
	
	OpenAnimationsMenu()
end

function openAccesoire()
	TriggerEvent('NB:closeAllSubMenu')
	TriggerEvent('NB:closeAllMenu')
	TriggerEvent('NB:closeMenuKey')
	
	TriggerEvent('NB:OpenAccessoryMenu')
end

function openAnimal()
	TriggerEvent('NB:closeAllSubMenu')
	TriggerEvent('NB:closeAllMenu')
	TriggerEvent('NB:closeMenuKey')
	
	TriggerEvent('NB:OpenPetMenu')
end

---------------------------------------------------------------------------Actions

local playAnim = false
local dataAnim = {}

function animsAction(animObj)
	if (IsInVehicle()) then
		local source = GetPlayerServerId();
		ESX.ShowNotification("Sortez de votre véhicule pour faire cela !")
	else
		Citizen.CreateThread(function()
			if not playAnim then
				local playerPed = GetPlayerPed(-1);
				if DoesEntityExist(playerPed) then -- Ckeck if ped exist
					dataAnim = animObj

					-- Play Animation
					RequestAnimDict(dataAnim.lib)
					while not HasAnimDictLoaded(dataAnim.lib) do
						Citizen.Wait(0)
					end
					if HasAnimDictLoaded(dataAnim.lib) then
						local flag = 0
						if dataAnim.loop ~= nil and dataAnim.loop then
							flag = 1
						elseif dataAnim.move ~= nil and dataAnim.move then
							flag = 49
						end

						TaskPlayAnim(playerPed, dataAnim.lib, dataAnim.anim, 8.0, -8.0, -1, flag, 0, 0, 0, 0)
						playAnimation = true
					end

					-- Wait end annimation
					while true do
						Citizen.Wait(0)
						if not IsEntityPlayingAnim(playerPed, dataAnim.lib, dataAnim.anim, 3) then
							playAnim = false
							TriggerEvent('ft_animation:ClFinish')
							break
						end
					end
				end -- end ped exist
			end
		end)
	end
end
	

function animsActionScenario(animObj)
	if (IsInVehicle()) then
		local source = GetPlayerServerId();
		ESX.ShowNotification("Sortez de votre véhicule pour faire cela !")
	else
		Citizen.CreateThread(function()
			if not playAnim then
				local playerPed = GetPlayerPed(-1);
				if DoesEntityExist(playerPed) then
					dataAnim = animObj
					TaskStartScenarioInPlace(playerPed, dataAnim.anim, 0, false)
					playAnimation = true
				end
			end
		end)
	end
end

-- Verifie si le joueurs est dans un vehicule ou pas
function IsInVehicle()
	local ply = GetPlayerPed(-1)
	if IsPedSittingInAnyVehicle(ply) then
		return true
	else
		return false
	end
end

function changer_skin()
	TriggerEvent('esx_skin:openSaveableMenu', source)
end

function save_skin()
	TriggerEvent('esx_skin:requestSaveSkin', source)
end

---------------------------------------------------------------------------------------------------------
--NB : gestion des menu
---------------------------------------------------------------------------------------------------------

RegisterNetEvent('NB:goTpMarcker')
AddEventHandler('NB:goTpMarcker', function()
	admin_tp_marcker()
end)

RegisterNetEvent('NB:openMenuPersonnel')
AddEventHandler('NB:openMenuPersonnel', function()
	OpenPersonnelMenu()
end)


--VETEMENTS

function Tshirt()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jailSkin)
		if skin.sex == 0 then
			SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 0)--Gants
			SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 0)--GiletJaune
		elseif skin.sex == 1 then
			SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 0)--Gants
			SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 0)--GiletJaune
		else
			TriggerEvent('skinchanger:loadClothes', skin, jailSkin.skin_female)
		end
		
	end)
end

function Pantalon()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jailSkin)
		if skin.sex == 0 then
			SetPedComponentVariation(GetPlayerPed(-1), 4, 14, 3, 0)--Jean
		elseif skin.sex == 1 then
            SetPedComponentVariation(GetPlayerPed(-1), 4, 15, 3, 0)--Jean
		else
			TriggerEvent('skinchanger:loadClothes', skin, jailSkin.skin_female)
		end
		
	end)
end

function Chaussures()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jailSkin)
		if skin.sex == 0 then
			SetPedComponentVariation(GetPlayerPed(-1), 6, 34, 0, 0)--Chaussure
		elseif skin.sex == 1 then
            SetPedComponentVariation(GetPlayerPed(-1), 6, 34, 0, 0)--Chaussure
		else
			TriggerEvent('skinchanger:loadClothes', skin, jailSkin.skin_female)
		end
		
	end)
end

function Veste()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jailSkin)
		if skin.sex == 0 then
			SetPedComponentVariation(GetPlayerPed(-1), 11, 15, 0, 0)--Veste
		elseif skin.sex == 1 then
            SetPedComponentVariation(GetPlayerPed(-1), 11, 15, 0, 0)--Veste
		else
			TriggerEvent('skinchanger:loadClothes', skin, jailSkin.skin_female)
		end
		
	end)
end

function Remettre()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jailSkin)
	TriggerEvent('skinchanger:loadSkin', skin)
	end)
end

function Enlever()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jailSkin)
		if skin.sex == 0 then
			SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 0)--Gants
			SetPedComponentVariation(GetPlayerPed(-1), 4, 14, 3, 0)--Jean
			SetPedComponentVariation(GetPlayerPed(-1), 6, 34, 0, 0)--Chaussure
			SetPedComponentVariation(GetPlayerPed(-1), 11, 15, 0, 0)--Veste
			SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 0)--GiletJaune
		elseif skin.sex == 1 then
            SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 0)--Gants
            SetPedComponentVariation(GetPlayerPed(-1), 4, 15, 3, 0)--Jean
            SetPedComponentVariation(GetPlayerPed(-1), 6, 34, 0, 0)--Chaussure
            SetPedComponentVariation(GetPlayerPed(-1), 11, 15, 0, 0)--Veste
            SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 0)--GiletJaune
		else
			TriggerEvent('skinchanger:loadClothes', skin, jailSkin.skin_female)
		end
					
	end)
end