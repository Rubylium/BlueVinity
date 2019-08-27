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

local PlayerData              = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local Blips                   = {}

local isInMarker              = false
local isInPublicMarker        = false
local hintIsShowed            = false
local hintToDisplay           = "no hint to display"

ESX                           = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

-- Create blips
Citizen.CreateThread(function()

    local blipMarker = Config.Blip
    local blipCoord = AddBlipForCoord(blipMarker.Pos.x, blipMarker.Pos.y, blipMarker.Pos.z)

    SetBlipSprite (blipCoord, blipMarker.Sprite)
    SetBlipDisplay(blipCoord, blipMarker.Display)
    SetBlipScale  (blipCoord, blipMarker.Scale)
    SetBlipColour (blipCoord, blipMarker.Colour)
    SetBlipAsShortRange(blipCoord, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('map_blip'))
    EndTextCommandSetBlipName(blipCoord)


end)

function SetVehicleMaxMods(vehicle)

  local props = {
    modEngine       = 0,
    modBrakes       = 0,
    modTransmission = 0,
    modSuspension   = 0,
    modTurbo        = false,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end

function IsJobTrue()
    if PlayerData ~= nil then
        local IsJobTrue = false
        if PlayerData.job ~= nil and PlayerData.job.name == 'journaliste' then
            IsJobTrue = true
        end
        return IsJobTrue
    end
end

function IsGradeBoss()
    if PlayerData ~= nil then
        local IsGradeBoss = false
        if PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'viceboss' then
            IsGradeBoss = true
        end
        return IsGradeBoss
    end
end

function cleanPlayer(playerPed)
  ClearPedBloodDamage(playerPed)
  ResetPedVisibleDamage(playerPed)
  ClearPedLastWeaponDamage(playerPed)
  ResetPedMovementClipset(playerPed, 0)
end

function setClipset(playerPed, clip)
  RequestAnimSet(clip)
  while not HasAnimSetLoaded(clip) do
    Citizen.Wait(0)
  end
  SetPedMovementClipset(playerPed, clip, true)
end

function setUniform(job, playerPed)
  TriggerEvent('skinchanger:getSkin', function(skin)

    if skin.sex == 0 then
      if Config.Uniforms[job].male ~= nil then
        TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
      else
        ESX.ShowNotification(_U('no_outfit'))
      end
      if job ~= 'citizen_wear' and job ~= 'journaliste_outfit' then
        setClipset(playerPed, "MOVE_M@POSH@")
      end
    else
      if Config.Uniforms[job].female ~= nil then
        TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
      else
        ESX.ShowNotification(_U('no_outfit'))
      end
      if job ~= 'citizen_wear' and job ~= 'journaliste_outfit' then
        setClipset(playerPed, "MOVE_F@POSH@")
      end
    end

  end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function OpenCloakroomMenu()

  local playerPed = GetPlayerPed(-1)

  local elements = {
    { label = _U('citizen_wear'),     value = 'citizen_wear'},
    { label = _U('journaliste_outfit'),    value = 'journaliste_outfit'},
    { label = _U('journaliste_outfit_1'),  value = 'journaliste_outfit_1'},
    { label = _U('journaliste_outfit_2'),  value = 'journaliste_outfit_2'},
    { label = _U('journaliste_outfit_3'),  value = 'journaliste_outfit_3'},
  }
	
	ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cloakroom',
    {
      title    = _U('cloakroom'),
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)

      isBarman = false
      cleanPlayer(playerPed)

      if data.current.value == 'citizen_wear' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
          TriggerEvent('skinchanger:loadSkin', skin)
        end)
      end

      if
        data.current.value == 'journaliste_outfit' or
        data.current.value == 'journaliste_outfit_1' and PlayerData.job.grade_name == 'reporter' or PlayerData.job.grade_name == 'investigator' or IsGradeBoss() or
        data.current.value == 'journaliste_outfit_2' and PlayerData.job.grade_name == 'investigator' or IsGradeBoss() or
        data.current.value == 'journaliste_outfit_3' and IsGradeBoss()
      then
        setUniform(data.current.value, playerPed)
      end

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}

    end,
    function(data, menu)
      menu.close()
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end
  )
end

function OpenBillingMenu(player)

  ESX.UI.Menu.Open(
    'dialog', GetCurrentResourceName(), 'billing',
    {
      title = _U('billing_amount')
    },
    function(data, menu)
    
      local amount = tonumber(data.value)
      local player, distance = ESX.Game.GetClosestPlayer()

      if player ~= -1 and distance <= 3.0 then

        menu.close()
        if amount == nil then
            ESX.ShowNotification(_U('amount_invalid'))
        else
            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_journaliste', _U('billing'), amount)
        end

      else
        ESX.ShowNotification(_U('no_players_nearby'))
      end

    end,
    function(data, menu)
        menu.close()
    end
  )
end

function OpenVaultMenu()

  if Config.EnableVaultManagement then

    local elements = {
      {label = _U('get_weapon'), value = 'get_weapon'},
      {label = _U('put_weapon'), value = 'put_weapon'},
      {label = _U('get_object'), value = 'get_stock'},
      {label = _U('put_object'), value = 'put_stock'}
    }
    

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vault',
      {
        title    = _U('vault'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        if data.current.value == 'get_weapon' then
          OpenGetWeaponMenu()
        end

        if data.current.value == 'put_weapon' then
          OpenPutWeaponMenu()
        end

        if data.current.value == 'put_stock' then
           OpenPutStocksMenu()
        end

        if data.current.value == 'get_stock' then
           OpenGetStocksMenu()
        end

      end,
      
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vault'
        CurrentActionMsg  = _U('open_vault')
        CurrentActionData = {}
      end
    )

  end

end

function OpenGetStocksMenu()

  ESX.TriggerServerCallback('esx_journaliste:getStockItems', function(items)

    print(json.encode(items))

    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = 'Journaliste Stock',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              OpenGetStocksMenu()

              TriggerServerEvent('esx_journaliste:getStockItem', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutStocksMenu()

  ESX.TriggerServerCallback('esx_journaliste:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('inventory'),
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              OpenPutStocksMenu()

              TriggerServerEvent('esx_journaliste:putStockItems', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)


end

function OpenGetWeaponMenu()

  ESX.TriggerServerCallback('esx_journaliste:getVaultWeapons', function(weapons)

    local elements = {}

    for i=1, #weapons, 1 do
      if weapons[i].count > 0 then
        table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name})
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vault_get_weapon',
      {
        title    = _U('get_weapon_menu'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        ESX.TriggerServerCallback('esx_journaliste:removeVaultWeapon', function()
          OpenGetWeaponMenu()
        end, data.current.value)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutWeaponMenu()

  local elements   = {}
  local playerPed  = GetPlayerPed(-1)
  local weaponList = ESX.GetWeaponList()

  for i=1, #weaponList, 1 do

    local weaponHash = GetHashKey(weaponList[i].name)

    if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
      local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
      table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
    end

  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'vault_put_weapon',
    {
      title    = _U('put_weapon_menu'),
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      ESX.TriggerServerCallback('esx_journaliste:addVaultWeapon', function()
        OpenPutWeaponMenu()
      end, data.current.value)

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function OpenVehicleSpawnerMenu()

  local vehicles = Config.Zones.Vehicles

  ESX.UI.Menu.CloseAll()

  if Config.EnableSocietyOwnedVehicles then

    local elements = {}

    ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)

      for i=1, #garageVehicles, 1 do
        table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles[i].model) .. ' [' .. garageVehicles[i].plate .. ']', value = garageVehicles[i]})
      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vehicle_spawner',
        {
          title    = _U('vehicle_menu'),
          align    = 'top-left',
          elements = elements,
        },
        function(data, menu)

          menu.close()

          local vehicleProps = data.current.value
          ESX.Game.SpawnVehicle(vehicleProps.model, vehicles.SpawnPoint, vehicles.Heading, function(vehicle)
              ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
              local playerPed = GetPlayerPed(-1)
              --TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)  -- teleport into vehicle
          end)            

          TriggerServerEvent('esx_society:removeVehicleFromGarage', 'journaliste', vehicleProps)

        end,
        function(data, menu)

          menu.close()

          CurrentAction     = 'menu_vehicle_spawner'
          CurrentActionMsg  = _U('vehicle_spawner')
          CurrentActionData = {}

        end
      )

    end, 'journaliste')

  else

    local elements = {}

    for i=1, #Config.AuthorizedVehicles, 1 do
      local vehicle = Config.AuthorizedVehicles[i]
      table.insert(elements, {label = vehicle.label, value = vehicle.name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_spawner',
      {
        title    = _U('vehicle_menu'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        local model = data.current.value

        local vehicle = GetClosestVehicle(vehicles.SpawnPoint.x,  vehicles.SpawnPoint.y,  vehicles.SpawnPoint.z,  3.0,  0,  71)

        if not DoesEntityExist(vehicle) then

          local playerPed = GetPlayerPed(-1)

          if Config.MaxInService == -1 then

            ESX.Game.SpawnVehicle(model, {
              x = vehicles.SpawnPoint.x,
              y = vehicles.SpawnPoint.y,
              z = vehicles.SpawnPoint.z
            }, vehicles.Heading, function(vehicle)
              --TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1) -- teleport into vehicle
              SetVehicleMaxMods(vehicle)
              SetVehicleDirtLevel(vehicle, 0)
            end)

          else

            ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)

              if canTakeService then

                ESX.Game.SpawnVehicle(model, {
                  x = vehicles[partNum].SpawnPoint.x,
                  y = vehicles[partNum].SpawnPoint.y,
                  z = vehicles[partNum].SpawnPoint.z
                }, vehicles[partNum].Heading, function(vehicle)
                  --TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)  -- teleport into vehicle
                  SetVehicleMaxMods(vehicle)
                  SetVehicleDirtLevel(vehicle, 0)
                end)

              else
                ESX.ShowNotification(_U('service_max') .. inServiceCount .. '/' .. maxInService)
              end

            end, 'etat')

          end

        else
          ESX.ShowNotification(_U('vehicle_out'))
        end

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = _U('vehicle_spawner')
        CurrentActionData = {}

      end
    )

  end

end

AddEventHandler('esx_journaliste:hasEnteredMarker', function(zone)
 
    if zone == 'BossActions' and IsGradeBoss() then
      CurrentAction     = 'menu_boss_actions'
      CurrentActionMsg  = _U('open_bossmenu')
      CurrentActionData = {}
    end
	
    if zone == 'Cloakrooms' then
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end	

    if zone == 'Vehicles' then
        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = _U('vehicle_spawner')
        CurrentActionData = {}
    end	
	
    if Config.EnableVaultManagement then
      if zone == 'Vaults' then
        CurrentAction     = 'menu_vault'
        CurrentActionMsg  = _U('open_vault')
        CurrentActionData = {}
      end
    end	

    if zone == 'VehicleDeleters' then

      local playerPed = GetPlayerPed(-1)

      if IsPedInAnyVehicle(playerPed,  false) then

        local vehicle = GetVehiclePedIsIn(playerPed,  false)

        CurrentAction     = 'delete_vehicle'
        CurrentActionMsg  = _U('store_vehicle')
        CurrentActionData = {vehicle = vehicle}
      end

    end
	
end)

AddEventHandler('esx_journaliste:hasExitedMarker', function(zone)

    CurrentAction = nil
    ESX.UI.Menu.CloseAll()

end)

-- Display markers
Citizen.CreateThread(function()
    while true do

        Wait(0)
        if IsJobTrue() then

            local coords = GetEntityCoords(GetPlayerPed(-1))

            for k,v in pairs(Config.Zones) do
                if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
                    DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z+1.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, false, false, false, false)
                end
            end

        end

    end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
    while true do

        Wait(0)
        if IsJobTrue() then

            local coords      = GetEntityCoords(GetPlayerPed(-1))
            local isInMarker  = false
            local currentZone = nil

            for k,v in pairs(Config.Zones) do
                if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
                    isInMarker  = true
                    currentZone = k
                end
            end

            if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
                HasAlreadyEnteredMarker = true
                LastZone                = currentZone
                TriggerEvent('esx_journaliste:hasEnteredMarker', currentZone)
            end

            if not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                TriggerEvent('esx_journaliste:hasExitedMarker', LastZone)
            end

        end

    end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do

    Citizen.Wait(0)

    if CurrentAction ~= nil then

      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlJustReleased(0,  Keys['E']) and IsJobTrue() then

        if CurrentAction == 'menu_cloakroom' then
            OpenCloakroomMenu()
        end

        if CurrentAction == 'menu_vault' then
            OpenVaultMenu()
        end
		
        if CurrentAction == 'menu_vehicle_spawner' then
            OpenVehicleSpawnerMenu()
        end

        if CurrentAction == 'delete_vehicle' then

          if Config.EnableSocietyOwnedVehicles then

            local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
            TriggerServerEvent('esx_society:putVehicleInGarage', 'journaliste', vehicleProps)

          else

            if
              GetEntityModel(vehicle) == GetHashKey('rumpo')
            then
              TriggerServerEvent('esx_service:disableService', 'journaliste')
            end

          end

          ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
        end
		
        if CurrentAction == 'menu_boss_actions' and IsGradeBoss() then

          local options = {
            wash      = Config.EnableMoneyWash,
          }

          ESX.UI.Menu.CloseAll()

          TriggerEvent('esx_society:openBossMenu', 'journaliste', function(data, menu)

            menu.close()
            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = _U('open_bossmenu')
            CurrentActionData = {}

          end,options)

        end

        
        CurrentAction = nil

      end

    end

    if IsControlJustReleased(0,  Keys['F6']) and IsJobTrue()then
        OpenBillingMenu()
    end


  end
end)


RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = 'Journaliste',
		number     = 'journaliste',
		base64Icon = 'data:image/png;base64,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qwv9+ib0ttfR61aj9+4xx/OmV40Mjf2df8N+5D7U/EtQCxehzj0fNfUsOGsmelSHud+lT3t1X3W+CdSjC+zPixiZKMDmp5gTRGuzsdHhQ7HPrgbzAgdS8h1LkNF9FP3QvdgvrgBnyfxA+v396HVryOUE2fsG9ve/gRrVUUmjbSScMxtaW9G2beJue3uD5Y67lwIy/zF96EBlbw6/yavIJdOPPUR/9zGzydH2181Wkwf2o0+cCL6UOdOrSqY17NyOvXM7PHwfavQYOPVU1KQzYNYc1IUXo19eW1Ec1ebr63aqzRuwf/LD9LotUabXrqooP1+DX6UTRBiCeL9y75kjrgZ+imZ84Ij2ndnSgpo9F8afkpig3rEN/frm2Fa2Wpn/GAS7Jo0gqyh138C+yPLLXOvMO0ajyO5v23HyneRjKvAQ4gRpRLqA24FHwwcKRYLo/j54+UXnTLebV4kSCT5Izhc1MBm60p3MEwkyGDJvMB9FKREZw0pWsQC9v9BYMqFpKRQJ4ik6n3KMk7kpRi25amTJUR8NI/MsGZEVlQUiQSA2ImOwZNINbn6KR4K4rXeKLK4LW7VMqUgRGk3m3XtJERnDSuaj1p76gcqE5qPQcljaOdNPsqzyd6AyryUubfmqsmWOBYzIGmo5rIHKhKan0HJYyvtH+86OynC6w4FHaCAyXMuwMoFVZM0hC09NUaq2y2EVkQnNT6FIEHcEzPWSJcmg0qAOVOYaoKY3rhwLosFkTn2VHpExLGTG2nKfN3OscWRCcyNOkDJk2mkAtMiKysQJIgwmvmkw6ijotSjVCYB2JriYeCVHZL4rKgovTuZag24LOhAZyihgb76zqijrhpHhWr+OBSGy3DLzrfIMoSvnDrZMw2by0wtsBdoLXCPUh4PA0bgDXhPXe2ZrO5pJKNMtDs7uM6e6qlBXnt1YGTH/r1ZWUbSg3Llk0HAyt6xexYosp0xFnhtz3uDLQHe37ejbQz5aMZOh23KeL9QPG9gJdA92QQRBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBEARBaCT+P2JC7PF0UY7ZAAAAAElFTkSuQmCC'
	}
	

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)

end)