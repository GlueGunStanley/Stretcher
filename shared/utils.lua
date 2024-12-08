
     --[[ STANLEY DEVELOPMENT STUDIOS ]]--
--[[ https://discord.com/invite/uCKZJed3Gq ]]--

RegisterCommand("stretchermenu", function()
    if Config.Permissions.stretchermenu then
        TriggerServerEvent("sv:getIsAllowed","command.stretchermenu")
        Wait(1000)
        if canStretcherMenu then 
            TriggerEvent("cl:OpenStretcherMenu")
            TriggerEvent('chat:addSuggestion', '/stretchermenu', 'Opens the stretcher interaction menu.')
        else
            print("You do not have permissions to interact with stretchers.")
        end
    else
        TriggerEvent("cl:OpenStretcherMenu")
        TriggerEvent('chat:addSuggestion', '/stretchermenu', 'Opens the stretcher interaction menu.')
    end
end)

RegisterCommand('stretcher', function(args)
    if Config.Permissions.stretcher then
        TriggerServerEvent("sv:getIsAllowed","command.stretcher")
        Wait(1000)
        if canStretcher then 
            UTIL.SpawnStretcher(Config.Stretcher.modelHash)
            TriggerEvent('chat:addSuggestion', '/stretcher', 'Spawn a stretcher directly infront of you.')
        else
            print("You do not have permissions to add stretchers.")
        end
    else
        UTIL.SpawnStretcher(Config.Stretcher.modelHash)
        TriggerEvent('chat:addSuggestion', '/stretcher', 'Spawn a stretcher directly infront of you.')
    end
end)

RegisterCommand('delstretcher', function(args)
    if Config.Permissions.delstretcher then
        TriggerServerEvent("sv:getIsAllowed","command.delstretcher")
        Wait(1000)
        if canDelStretcher then 
            UTIL.DeleteStretcher(Config.Stretcher.modelHash)
            TriggerEvent('chat:addSuggestion', '/delstretcher', 'Deletes a nearby stretcher.')
        else
            print('You do not have permissions to delete a stretcher.')
        end
    else
        UTIL.DeleteStretcher(Config.Stretcher.modelHash)
        TriggerEvent('chat:addSuggestion', '/delstretcher', 'Deletes a nearby stretcher.')
    end
end)

RegisterCommand('mdstretcher', function(args)
    if Config.Permissions.mdstretcher then
        TriggerServerEvent("sv:getIsAllowed","command.mdstretcher")
        Wait(1000)
        if canMdStretcher then 
            UTIL.DeleteAllStretchers(Config.Stretcher.modelHash)
            TriggerEvent('chat:addSuggestion', '/mdstretcher', 'Deletes all existing stretchers.')
        else
            print('You do not have permissions to delete all stretchers.')
        end
    else
        UTIL.DeleteAllStretchers(Config.Stretcher.modelHash)
        TriggerEvent('chat:addSuggestion', '/mdstretcher', 'Deletes all existing stretchers.')
        
    end 
end)

RegisterNetEvent('cl:StretcherCleanUp')
AddEventHandler('cl:StretcherCleanUp', function()
    UTIL.DeleteAllStretchers(Config.Stretcher.modelHash)
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
