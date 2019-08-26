local CurrentAction = nil
local GUI = {}
GUI.Time = 0
local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
local times = 0
local this_Garage = {}

local vehicleHash = ''
-- Init ESX
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)

        Citizen.Wait(0)
    end
end)

--- Blips Management
RegisterNetEvent('esx:playerLoaded')

AddEventHandler('esx:playerLoaded', function(xPlayer)
    refreshBlips()
end)

function refreshBlips()
    local zones = {}
    local blipInfo = {}

    for zoneKey, zoneValues in pairs(Config.Garages) do
        local blip = AddBlipForCoord(zoneValues.Pos.x, zoneValues.Pos.y, zoneValues.Pos.z)
        SetBlipSprite(blip, 524)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.65)
        SetBlipColour(blip, 69)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('Garage Civil')
        EndTextCommandSetBlipName(blip)
            local blip = AddBlipForCoord(zoneValues.MunicipalPoundPoint.Pos.x, zoneValues.MunicipalPoundPoint.Pos.y, zoneValues.MunicipalPoundPoint.Pos.z)
            SetBlipSprite(blip, 643)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.85)
            SetBlipColour(blip, Config.BlipPound.Color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(_U('impound_yard'))
            EndTextCommandSetBlipName(blip)
    end
end

--Menu function
function OpenMenuGarage(PointType)
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local pedCoordsZ = pedCoords.z + 5.0
    local pedCoordsY = pedCoords.y + 5.0

    -- Cam 
    local camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(camera, pedCoords.x, pedCoordsY, pedCoordsZ)
    PointCamAtEntity(camera, ped, 0, 0, 0, 1)
    SetCamNearDof(camera, 10)
    RenderScriptCams(1, 1, 1500, 1, 1)

    -- Fin cam
    ESX.UI.Menu.CloseAll()
    local elements = {}

    if PointType == 'spawn' then
        table.insert(elements, {
            label = _U('list_vehicles'),
            value = 'list_vehicles'
        })
    end

    if PointType == 'delete' then
        table.insert(elements, {
            label = _U('stock_vehicle'),
            value = 'stock_vehicle'
        })
    end

    if PointType == 'pound' then
        table.insert(elements, {
            label = _U('return_vehicle', Config.Price),
            value = 'return_vehicle'
        })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garage_menu', {
        title = _U('garage'),
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        menu.close()

        if (data.current.value == 'list_vehicles') then
            ListVehiclesMenu()
        end

        if (data.current.value == 'stock_vehicle') then
            StockVehicleMenu()
        end

        if (data.current.value == 'return_vehicle') then
            ReturnVehicleMenu()
        end

        local playerPed = GetPlayerPed(-1)
        SpawnVehicle(data.current.value)
    end, function(data, menu)
        menu.close()
        RenderScriptCams(0, 1, 2000, 1, 1)
        DestroyCam(camera, true)
    end)
end

function previewVehicle()
    while #LastVehicles > 0 do
        local vehicle = LastVehicles[1]
        ESX.Game.DeleteVehicle(vehicle)
        table.remove(LastVehicles, 1)
    end
end

-- View Vehicle Listings
function ListVehiclesMenu()
    local elements = {}

    ESX.TriggerServerCallback('eden_garage:getVehicles', function(vehicles)
        for _, v in pairs(vehicles) do
            local hashVehicule = v.vehicle.model
            local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
            local labelvehicle

            if (v.state) then
                labelvehicle = vehicleName..'<font color="green">Dans le garage</font>'
            else
                labelvehicle = vehicleName..'<font color="red">En fourrière</font>'
            end

            table.insert(elements, {
                label = labelvehicle,
                value = v
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_vehicle', {
            title = _U('garage'),
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            if (data.current.value.state) then
                menu.close()
                SpawnVehicle(data.current.value.vehicle)
                RenderScriptCams(0, 1, 2000, 1, 1)
                DestroyCam(camera, true)
            else
                exports.pNotify:SendNotification({
                    text = _U('notif_car_impounded'),
                    queue = 'right',
                    timeout = 400,
                    layout = 'centerLeft'
                })
                RenderScriptCams(0, 1, 2000, 1, 1)
                DestroyCam(camera, true)
            end
        end, function(data, menu)
            menu.close()
            RenderScriptCams(0, 1, 2000, 1, 1)
            DestroyCam(camera, true)
        end)
    end)
    --CurrentAction = 'open_garage_action'
end



function reparation(prix, vehicle, vehicleProps)
    ESX.UI.Menu.CloseAll()

    local elements = {
        {
            label = _U('reparation_yes', prix),
            value = 'yes'
        },
        {
            label = _U('reparation_no', prix),
            value = 'no'
        }
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'delete_menu', {
        title = _U('reparation'),
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        menu.close()

        if (data.current.value == 'yes') then
            TriggerServerEvent('eden_garage:payhealth', prix)
            ranger(vehicle, vehicleProps)
            RenderScriptCams(0, 1, 2000, 1, 1)
            DestroyCam(camera, true)
        end

        if (data.current.value == 'no') then
            ESX.ShowNotification(_U('reparation_no_notif'))
            RenderScriptCams(0, 1, 2000, 1, 1)
            DestroyCam(camera, true)
        end
    end, function(data, menu)
        menu.close()
        RenderScriptCams(0, 1, 2000, 1, 1)
        DestroyCam(camera, true)
    end)
end

RegisterNetEvent('eden_garage:deletevehicle_cl')

AddEventHandler('eden_garage:deletevehicle_cl', function(plate)
    local _plate = plate:gsub('^%s*(.-)%s*$', '%1')
    local playerPed = GetPlayerPed(-1)

    if IsPedInAnyVehicle(playerPed, false) then
        local playerPed = GetPlayerPed(-1)
        local coords = GetEntityCoords(playerPed)
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
        local usedPlate = vehicleProps.plate:gsub('^%s*(.-)%s*$', '%1')

        if usedPlate == _plate then
            ESX.Game.DeleteVehicle(vehicle)
        end
    end
end)

function ranger(vehicle, vehicleProps)
    TriggerServerEvent('eden_garage:deletevehicle_sv', vehicleProps.plate)
    TriggerServerEvent('eden_garage:modifystate', vehicleProps, true)

    exports.pNotify:SendNotification({
        text = _U('ranger'),
        queue = 'right',
        timeout = 400,
        layout = 'centerLeft'
    })
    RenderScriptCams(0, 1, 2000, 1, 1)
    DestroyCam(camera, true)
end

-- Function that allows player to enter a vehicle
function StockVehicleMenu()
    local playerPed = GetPlayerPed(-1)

    if IsPedInAnyVehicle(playerPed, false) then
        local playerPed = GetPlayerPed(-1)
        local coords = GetEntityCoords(playerPed)
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
        local current = GetPlayersLastVehicle(GetPlayerPed(-1), true)
        local engineHealth = GetVehicleEngineHealth(current)

        ESX.TriggerServerCallback('eden_garage:stockv', function(valid)
            if (valid) then
                ESX.TriggerServerCallback('eden_garage:getVehicles', function(vehicules)
                    local plate = vehicleProps.plate:gsub('^%s*(.-)%s*$', '%1')
                    local owned = false

                    for _, v in pairs(vehicules) do
                        if plate == v.plate then
                            owned = true
                            TriggerServerEvent('eden_garage:debug', 'vehicle plate returned to the garage: ' .. vehicleProps.plate)
                            TriggerServerEvent('eden_garage:logging', 'vehicle returned to the garage: ' .. engineHealth)

                            if engineHealth < 1000 then
                                local fraisRep = math.floor((1000 - engineHealth) * Config.RepairMultiplier)
                                reparation(fraisRep, vehicle, vehicleProps)
                            else
                                ranger(vehicle, vehicleProps)
                                RenderScriptCams(0, 1, 2000, 1, 1)
                                DestroyCam(camera, true)
                            end
                        end
                    end

                    if owned == false then
                        exports.pNotify:SendNotification({
                            text = _U('stockv_not_owned'),
                            queue = 'right',
                            timeout = 400,
                            layout = 'centerLeft'
                        })
                        RenderScriptCams(0, 1, 2000, 1, 1)
                        DestroyCam(camera, true)
                    end
                end)
            else
                exports.pNotify:SendNotification({
                    text = _U('stockv_not_owned'),
                    queue = 'right',
                    timeout = 400,
                    layout = 'centerLeft'
                })
                RenderScriptCams(0, 1, 2000, 1, 1)
                DestroyCam(camera, true)
            end
        end, vehicleProps)
    else
        exports.pNotify:SendNotification({
            text = _U('stockv_not_in_veh'),
            queue = 'right',
            timeout = 400,
            layout = 'centerLeft'
        })
        RenderScriptCams(0, 1, 2000, 1, 1)
        DestroyCam(camera, true)
    end
end

--Function for spawning vehicle
function SpawnVehicle(vehicle)
    ESX.Game.SpawnVehicle(vehicle.model, {
        x = this_Garage.SpawnPoint.Pos.x,
        y = this_Garage.SpawnPoint.Pos.y,
        z = this_Garage.SpawnPoint.Pos.z + 1
    }, this_Garage.SpawnPoint.Heading, function(callback_vehicle)
        ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
        SetVehRadioStation(callback_vehicle, 'OFF')
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
        local plate = GetVehicleNumberPlateText(callback_vehicle)
        TriggerEvent("ls:newVehicle", carplate, nil, nil)
    end)

    TriggerServerEvent('eden_garage:modifystate', vehicle, false)
end


--Function for spawning vehicle
function SpawnPoundedVehicle(vehicle)
    ESX.Game.SpawnVehicle(vehicle.model, {
        x = this_Garage.SpawnMunicipalPoundPoint.Pos.x,
        y = this_Garage.SpawnMunicipalPoundPoint.Pos.y,
        z = this_Garage.SpawnMunicipalPoundPoint.Pos.z + 1
    }, 180, function(callback_vehicle)
        ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
        local plate = GetVehicleNumberPlateText(callback_vehicle)
        TriggerServerEvent('ls:mainCheck', plate, callback_vehicle, true)
    end)

    TriggerServerEvent('eden_garage:modifystate', vehicle, true)

    ESX.SetTimeout(10000, function()
        TriggerServerEvent('eden_garage:modifystate', vehicle, false)
    end)
end

-- Marker actions
AddEventHandler('eden_garage:hasEnteredMarker', function(zone)
    if zone == 'spawn' then
        CurrentAction = 'spawn'
        CurrentActionMsg = _U('spawn')
        CurrentActionData = {}
    end

    if zone == 'delete' then
        CurrentAction = 'delete'
        CurrentActionMsg = _U('delete')
        CurrentActionData = {}
    end

    if zone == 'pound' then
        CurrentAction = 'pound_action_menu'
        CurrentActionMsg = _U('pound_action_menu')
        CurrentActionData = {}
    end
end)

AddEventHandler('eden_garage:hasExitedMarker', function(zone)
    ESX.UI.Menu.CloseAll()
    CurrentAction = nil
end)

function ReturnVehicleMenu()
    ESX.TriggerServerCallback('eden_garage:getOutVehicles', function(vehicles)
        local elements = {}

        for _, v in pairs(vehicles) do
            local hashVehicule = v.model
            local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
            local labelvehicle
            labelvehicle = _U('impound_list', vehicleName)

            table.insert(elements, {
                label = labelvehicle,
                value = v
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'return_vehicle', {
            title = _U('impound_yard'),
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            ESX.TriggerServerCallback('eden_garage:checkMoney', function(hasEnoughMoney)
                if hasEnoughMoney then
                    if times == 0 then
                        TriggerServerEvent('eden_garage:pay')
                        SpawnPoundedVehicle(data.current.value)
                        times = times + 1
                    elseif times > 0 then
                        ESX.SetTimeout(60000, function()
                            times = 0
                        end)
                    end
                else
                    exports.pNotify:SendNotification({
                        text = _U('impound_not_enough_money'),
                        queue = 'right',
                        timeout = 400,
                        layout = 'centerLeft'
                    })
                end
            end)
        end, function(data, menu)
            menu.close()
            RenderScriptCams(0, 1, 2000, 1, 1)
            DestroyCam(camera, true)
        end)
    end)
    --CurrentAction = 'open_garage_action'
end
local blipsTest = 0
-- Display markers 
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local coords = GetEntityCoords(GetPlayerPed(-1))
        if blipsTest == 0 then
            refreshBlips()
            blipsTest = 1
        end

        for k, v in pairs(Config.Garages) do
            if (GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
                DrawMarker(36, v.SpawnPoint.Pos.x, v.SpawnPoint.Pos.y, v.SpawnPoint.Pos.z+1.2, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, v.SpawnPoint.Color.r, v.SpawnPoint.Color.g, v.SpawnPoint.Color.b, 100, false, true, 2, false, false, false, false)
                DrawMarker(36, v.DeletePoint.Pos.x, v.DeletePoint.Pos.y, v.DeletePoint.Pos.z+1.2, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, v.DeletePoint.Color.r, v.DeletePoint.Color.g, v.DeletePoint.Color.b, 100, false, true, 2, false, false, false, false)
            end
                if (GetDistanceBetweenCoords(coords, v.MunicipalPoundPoint.Pos.x, v.MunicipalPoundPoint.Pos.y, v.MunicipalPoundPoint.Pos.z, true) < Config.DrawDistance) then
                    DrawMarker(39, v.MunicipalPoundPoint.Pos.x, v.MunicipalPoundPoint.Pos.y, v.MunicipalPoundPoint.Pos.z+1.2, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 247, 167, 37, 100, false, true, 2, false, false, false, false)
                    DrawMarker(25, v.SpawnMunicipalPoundPoint.Pos.x, v.SpawnMunicipalPoundPoint.Pos.y, v.SpawnMunicipalPoundPoint.Pos.z+0.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.SpawnMunicipalPoundPoint.Size.x, v.SpawnMunicipalPoundPoint.Size.y, v.SpawnMunicipalPoundPoint.Size.z, v.SpawnMunicipalPoundPoint.Color.r, v.SpawnMunicipalPoundPoint.Color.g, v.SpawnMunicipalPoundPoint.Color.b, 100, false, true, 2, false, false, false, false)
                end
        end
    end
end)

-- Open/close menus
Citizen.CreateThread(function()
    local currentZone = 'garage'

    while true do
        Wait(0)
        local coords = GetEntityCoords(GetPlayerPed(-1))
        local isInMarker = false

        for _, v in pairs(Config.Garages) do
            if (GetDistanceBetweenCoords(coords, v.SpawnPoint.Pos.x, v.SpawnPoint.Pos.y, v.SpawnPoint.Pos.z, true) < v.Size.x) then
                isInMarker = true
                this_Garage = v
                currentZone = 'spawn'
            end

            if (GetDistanceBetweenCoords(coords, v.DeletePoint.Pos.x, v.DeletePoint.Pos.y, v.DeletePoint.Pos.z, true) < v.Size.x) then
                isInMarker = true
                this_Garage = v
                currentZone = 'delete'
            end

                if (GetDistanceBetweenCoords(coords, v.MunicipalPoundPoint.Pos.x, v.MunicipalPoundPoint.Pos.y, v.MunicipalPoundPoint.Pos.z, true) < v.MunicipalPoundPoint.Size.x) then
                    isInMarker = true
                    this_Garage = v
                    currentZone = 'pound'
                end
        end

        if isInMarker and not hasAlreadyEnteredMarker then
            hasAlreadyEnteredMarker = true
            LastZone = currentZone
            TriggerEvent('eden_garage:hasEnteredMarker', currentZone)
        end

        if not isInMarker and hasAlreadyEnteredMarker then
            hasAlreadyEnteredMarker = false
            TriggerEvent('eden_garage:hasExitedMarker', LastZone)
        end
    end
end)

-- Button press
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if CurrentAction ~= nil then
            SetTextComponentFormat('STRING')
            AddTextComponentString(CurrentActionMsg)
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)

            if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 150 then
                if CurrentAction == 'pound_action_menu' then
                    OpenMenuGarage('pound')
                end

                if CurrentAction == 'spawn' then
                    OpenMenuGarage('spawn')
                end

                if CurrentAction == 'delete' then
                    OpenMenuGarage('delete')
                end

                CurrentAction = nil
                GUI.Time = GetGameTimer()
            end
        end
    end
end)
-- Fin controle touche