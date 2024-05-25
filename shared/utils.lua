RegisterCommand("stretchermenu", function()
    TriggerEvent("cl:OpenStretcherMenu")
    TriggerEvent('chat:addSuggestion', '/stretchermenu', 'Opens the stretcher interaction menu.')
end, Config.Permissions.stretchermenu)

RegisterCommand('stretcher', function(source, args, rawCommand)
    UTIL.SpawnStretcher('strykerpro')
    TriggerEvent('chat:addSuggestion', '/stretcher', 'Spawn a stretcher directly infront of you.')
end, Config.Permissions.stretcher)

RegisterCommand('delstretcher', function(source, args, rawCommand)
    UTIL.DeleteStretcher('strykerpro')
    TriggerEvent('chat:addSuggestion', '/delstretcher', 'Deletes a nearby stretcher.')
end, Config.Permissions.delstretcher)

RegisterCommand('mdstretcher', function(source, args, rawCommand)
    UTIL.DeleteAllStretchers('strykerpro')
    TriggerEvent('chat:addSuggestion', '/mdstretcher', 'Deletes all existing stretchers.')
end, Config.Permissions.mdstretcher)

RegisterNetEvent('cl:StretcherCleanUp')
AddEventHandler('cl:StretcherCleanUp', function()
    UTIL.DeleteAllStretchers('strykerpro')
end)

UTIL = UTIL or {}

-- Load animation dictionary
function UTIL.LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(5)
    end
    return true
end

-- Load model
function UTIL.LoadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(5)
    end
end

-- Play animation
function UTIL.PlayAnimation(player, dict, anim, offsetInfo)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local stretcherObject = GetClosestVehicle(playerCoords.x, playerCoords.y, playerCoords.z, 3.0, 0, 70)
    if GetEntityModel(stretcherObject) == GetHashKey("strykerpro") then

        if not CheckSittingState(GetVehicleNetId(stretcherObject)) or IsEntityAttachedToEntity(stretcherObject, PlayerPedId()) then
        
        AttachEntityToEntity(player, stretcherObject, offsetInfo[1], offsetInfo[2], offsetInfo[3], offsetInfo[4], offsetInfo[5], offsetInfo[6], offsetInfo[7], offsetInfo[8], offsetInfo[9], offsetInfo[10], offsetInfo[11], offsetInfo[12], offsetInfo[13])
        UTIL.LoadAnimDict(dict)
        TaskPlayAnim(player, dict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
        PreventTakingStretcherWhileSeated = true
        SetSittingState(GetVehicleNetId(stretcherObject), true)

        else UTIL.Notify("~y~Someone is on this strecher already!")
            return
        end
    end
end

-- Toggle stretcher equipment extra
function UTIL.ToggleEquipmentExtra(player, extraIndex)
    local stretcherObject = GetClosestVehicle(GetEntityCoords(player), 3.0, GetHashKey("strykerpro"), 70)
    if not stretcherObject then return end

    if type(extraIndex) == "table" then
        for _, index in ipairs(extraIndex) do
            ToggleExtra(player, stretcherObject, index)
        end
        return
    end

    if IsVehicleExtraTurnedOn(stretcherObject, extraIndex) then
        SetVehicleExtra(stretcherObject, extraIndex, 1)
    else
        SetVehicleExtra(stretcherObject, extraIndex, 0)
    end
end

-- Gets the closest vehicle
function UTIL.GetClosestVehicleFromPedPos(ped, maxDistance, maxHeight, canReturnVehicleInside, configTable)
    local veh = nil
    local smallestDistance = maxDistance
    local vehicles = GetGamePool('CVehicle')
    local matchingConfig = nil

    for _, v in ipairs(vehicles) do
        if DoesEntityExist(v) and (canReturnVehicleInside or not IsPedInVehicle(ped, v, false)) then
            local distance = #(GetEntityCoords(ped) - GetEntityCoords(v))
            local height = math.abs(GetEntityHeightAboveGround(v))
            if distance <= smallestDistance and height <= maxHeight and height >= 0 and IsVehicleDriveable(v, false) then
                local vehicleModel = GetEntityModel(v)
                for _, config in ipairs(configTable) do
                    if GetHashKey(config.modelHash) == vehicleModel then
                        smallestDistance = distance
                        veh = v
                        matchingConfig = config
                        break
                    end
                end
            end
        end
    end
    return veh, matchingConfig
end

-- Spawn stretcher
function UTIL.SpawnStretcher(model)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)

    UTIL.LoadModel(model)

    local offset = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.0, 0.0)
    local stretcher = CreateVehicle(model, offset.x, offset.y, offset.z, playerHeading - 90.0, true, false)

    SetVehicleOnGroundProperly(stretcher)
    SetVehicleHasBeenOwnedByPlayer(stretcher, true)
    
    SetVehicleExtra(stretcher, 2, 0) -- Disable extra
    SetVehicleExtra(stretcher, 12, 0)

    SetVehicleExtra(stretcher, 1, 1) -- Enable extra
    SetVehicleExtra(stretcher, 3, 1)
    SetVehicleExtra(stretcher, 5, 1)  
    SetVehicleExtra(stretcher, 6, 1)  
    SetVehicleExtra(stretcher, 7, 1) 
    SetVehicleExtra(stretcher, 11, 1)  
    SetVehicleHasBeenOwnedByPlayer(stretcher, true)
    SetModelAsNoLongerNeeded(model)

    AddStretcherId(GetVehicleNetId(stretcher))
    if Config.Debug.messages then
        print(GetVehicleNetId(stretcher))
    end
end

-- Delete stretcher
function UTIL.DeleteStretcher(model)
    local stretcherObject = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 5.0, GetHashKey(model), 70)
    if not DoesEntityExist(stretcherObject) then UTIL.Notify("~y~No stretcher nearby to delete!") return end
    SetEntityAsMissionEntity(stretcherObject, true, true)
    RemoveStretcherId(GetVehicleNetId(stretcherObject))
    DeleteVehicle(stretcherObject)
end

-- Delete all stretchers
function UTIL.DeleteAllStretchers(model)
    local modelHash = GetHashKey(model)
    local entityPool = GetGamePool('CVehicle')
    local delCount = 0

    for _, stretcher in ipairs(entityPool) do
        if GetEntityModel(stretcher) == modelHash then
            SetEntityAsMissionEntity(stretcher, true, true)
            RemoveStretcherId(GetVehicleNetId(stretcher))
            DeleteVehicle(stretcher)
            if DoesEntityExist(stretcher) then
                DeleteEntity(stretcher)
            end
            delCount = delCount + 1
        end
    end
    UTIL.Notify('~y~' .. delCount .. ' stretchers deleted.')
end

-- Display notification
function UTIL.Notify(message)
    PlaySoundFrontend(-1, "Event_Message_Purple", "GTAO_FM_Events_Soundset", false)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(false, false)
end

