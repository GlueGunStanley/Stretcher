local stretchers = {}

RegisterNetEvent('cl:SyncStretchers')
AddEventHandler('cl:SyncStretchers', function(updatedStretchers)
    stretchers = updatedStretchers
    for netId, data in pairs(stretchers) do
        if Config.Debug.messages then
            print("Stretcher ID: " .. netId .. " Moving: " .. tostring(data.moving))
            print("Stretcher ID: " .. netId .. " Moving: " .. tostring(data.sitting))
        end
    end
end)

RegisterNetEvent('cl:SyncMovingState')
AddEventHandler('cl:SyncMovingState', function(netId, bool)
    if stretchers[netId] then
        stretchers[netId].moving = bool
        if Config.Debug.messages then
            print("Moving bool for stretcher ID " .. netId .. " updated to " .. tostring(bool))
        end
    else
        stretchers[netId] = { moving = bool }
        if Config.Debug.messages then
            print("Stretcher ID: " .. netId .. " added with moving bool: " .. tostring(bool))
        end
    end
end)

RegisterNetEvent('cl:SyncSittingState')
AddEventHandler('cl:SyncSittingState', function(netId, bool)
    if stretchers[netId] then
        stretchers[netId].sitting = bool
        if Config.Debug.messages then
            print("Sitting bool for stretcher ID " .. netId .. " updated to " .. tostring(bool))
        end
    else
        stretchers[netId] = { moving = bool }
        if Config.Debug.messages then
            print("Stretcher ID: " .. netId .. " added with sitting bool: " .. tostring(bool))
        end    
    end
end)

RegisterNetEvent('cl:RemoveStretcherFromTable')
AddEventHandler('cl:RemoveStretcherFromTable', function(netId)
    if stretchers[netId] then
        stretchers[netId] = nil
        if Config.Debug.messages then
            print("Stretcher with network ID " .. netId .. " removed")
        end
    elseif Config.Debug.messages then
        print("Stretcher with network ID " .. netId .. " not found")
    end
end)

function AddStretcherId(netId)
    TriggerServerEvent('sv:AddStretcherToTable', netId)
end

function SetMovingState(netId, bool)
    TriggerServerEvent('sv:SetMovingState', netId, bool)
end

function SetSittingState(netId, bool)
    TriggerServerEvent('sv:SetSittingState', netId, bool)
end

function RemoveStretcherId(netId)
    TriggerServerEvent('sv:RemoveStretcherFromTable', netId)
end

function GetVehicleNetId(vehicle)
    local netId = VehToNet(vehicle)
    return netId
end

function GetPedNetId(playerPed)
    local netId = PedToNet(playerPed)
    return netId
end

function GetVehicleFromNetId(netId)
    local vehicle = NetToVeh(netId)
    return vehicle
end

function GetPedFromNetId(netId)
    local playerPed = NetToPed(netId)
    return playerPed
end

function CheckMovingState(netId)
    if stretchers[netId] then
        return stretchers[netId].moving
    else
        return nil
    end
end

function CheckSittingState(netId)
    if stretchers[netId] then
        return stretchers[netId].sitting
    else
        return nil
    end
end


Citizen.CreateThread(function()
    local activated = false
    while true do
        Wait(0)
        if IsControlPressed(0, Config.Keys.doors) and not IsPedInAnyVehicle(PlayerPedId()) then
            if not activated then
                local timer = 0 
                local hold = 700 
                activated = true
                while IsControlPressed(0, Config.Keys.doors) do
                    Wait(0)
                    timer = timer + GetFrameTime() * 1000
                    if timer >= hold then
                        ToggleVehicleDoors()
                        break
                    end
                end
            end
        else
            activated = false
        end
    end
end)

VehicleDoorIndex = { FLD = 0, FRD = 1, BLD = 2, BRD = 3, HOOD = 4, TRUNK = 5, RLD = 6, RRD = 7 }

function ToggleVehicleDoors()
    local nearestVehicle, vehicleConfig = UTIL.GetClosestVehicleFromPedPos(PlayerPedId(), 20.0, 7.0, true, Config.Vehicles)
    if nearestVehicle and vehicleConfig then
        if Config.Debug.messages then
            print("The nearest vehicle matches a specified model: " .. vehicleConfig.modelHash)
            print("Doors: " .. table.concat(vehicleConfig.doors, ", "))
        end

        SetVehicleHasBeenOwnedByPlayer(nearestVehicle, true)
        SetEntityAsMissionEntity(nearestVehicle, true, true)

        local vehicleCoords = GetEntityCoords(nearestVehicle)
        local distanceToVehicle = #(GetEntityCoords(PlayerPedId()) - vehicleCoords)
        if distanceToVehicle > vehicleConfig.dist then
            if Config.Debug.messages then
                print("Player is not within the required distance to the vehicle.")
            end
            return
        end

        -- Initialize all door variables to false
        local fld, frd, bld, brd, hood, trunk, rld, rrd = false, false, false, false, false, false, false, false

        -- Set corresponding variables to true if the door is present in vehicleConfig.doors
        for _, door in ipairs(vehicleConfig.doors) do
            if door == "FLD" then fld = true end
            if door == "FRD" then frd = true end
            if door == "BLD" then bld = true end
            if door == "BRD" then brd = true end
            if door == "HOOD" then hood = true end
            if door == "TRUNK" then trunk = true end
            if door == "RLD" then rld = true end
            if door == "RRD" then rrd = true end
        end

        TriggerServerEvent('sv:ToggleVehicleDoors', GetVehicleNetId(nearestVehicle), fld, frd, bld, brd, hood, trunk, rld, rrd)
    end
end


RegisterNetEvent('cl:SyncVehicleDoors')
AddEventHandler('cl:SyncVehicleDoors', function(netId, fld, frd, bld, brd, hood, trunk, rld, rrd)
    local doors = {fld, frd, bld, brd, hood, trunk, rld, rrd}
    local doorIndices = {0, 1, 2, 3, 4, 5, 6, 7} -- Adjusted to 0-based indices
    local vehicle = GetVehicleFromNetId(netId)
        if Config.Debug.messages then
            print(vehicle)
            print(doors)
        end
    if vehicle then
        local openCount = 0
        local closedCount = 0

        -- Check the state of each door
        for i, isOpen in ipairs(doors) do
            if isOpen then
                local doorIndex = doorIndices[i]
                local doorState = GetVehicleDoorAngleRatio(vehicle, doorIndex) > 0
                if doorState then
                    openCount = openCount + 1
                else
                    closedCount = closedCount + 1
                end
            end
        end

        -- Determine the overall state
        local allOpen = openCount == #doors
        local allClosed = closedCount == #doors

        -- Toggle all doors based on the overall state
        for i, isOpen in ipairs(doors) do
            if isOpen then
                local doorIndex = doorIndices[i]
                if allClosed or (closedCount > openCount) then
                    SetVehicleDoorOpen(vehicle, doorIndex, false, false)
                else
                    SetVehicleDoorShut(vehicle, doorIndex, false)
                end
            end
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(0, Config.Keys.take) then
        local playerCoords = GetEntityCoords(PlayerPedId())
        local stretcherObject = GetClosestVehicle(playerCoords, 3.0, GetHashKey(Config.Stretcher.modelHash), 70)
        if stretcherObject then
            TakeStretcher(stretcherObject)
        end
        end
    end
end)


function TakeStretcher(stretcherObject)
    if Config.Debug.messages then print("TakeStretcher function triggered") end
    if IsPedInAnyVehicle(PlayerPedId()) then 
        if Config.Debug.messages then
        print("You can't take the stretcher while in a vehicle!") 
        end
        return 
    end
    if PreventTakingStretcherWhileSeated then 
        if Config.Debug.messages then
            print("You can't take the stretcher while seated on it!") 
        end
        return 
    end

    if not stretcherObject or not DoesEntityExist(stretcherObject) then return end

    UTIL.LoadAnimDict("anim@heists@box_carry@")

    NetworkRequestControlOfEntity(stretcherObject)
    while not NetworkHasControlOfEntity(stretcherObject) do
        Wait(0)
    end

    if Config.Debug.messages then print("about to attach") end
    AttachEntityToEntity(stretcherObject, PlayerPedId(), PlayerPedId(), -0.05, 1.375, -0.3450 , 180.0, 180.0, 180.0, 0.0, false, false, false, false, 2, true)
    SetVehicleExtra(stretcherObject, 1, 0)
    SetVehicleExtra(stretcherObject, 2, 1)
    SetMovingState((GetVehicleNetId(stretcherObject)), true)

    while IsEntityAttachedToEntity(stretcherObject, PlayerPedId()) do
        Wait(0)

        HideHudComponentThisFrame(19) -- Hide weapon wheel
        DisableControlAction(0, 37, true) -- Disable Weapon Wheel (tab)
        DisableControlAction(0, 22, true) -- Disable the jump/climb action (space bar)
        DisableControlAction(0, 44, true) -- Disable the take cover action (q)
        DisableControlAction(0, 24, true) -- INPUT_ATTACK (left mouse)
        DisableControlAction(0, 142, true) -- INPUT_MELEE_ATTACK_ALTERNATE (left mouse)
        DisableControlAction(0, 25, true) -- INPUT_AIM (right mouse)
        DisableControlAction(0, 257, true) -- INPUT_ATTACK2 (right mouse)
        DisableControlAction(0, 45, true) -- INPUT_RELOAD (r)
        DisableControlAction(0, 140, true) -- INPUT_MELEE_ATTACK_HEAVY (r)

        if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
            TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
        end

        if IsPedDeadOrDying(PlayerPedId()) or IsPedRagdoll(PlayerPedId()) then
            ClearPedTasksImmediately(PlayerPedId())
            SetVehicleExtra(stretcherObject, 1, 1)
            SetVehicleExtra(stretcherObject, 2, 0)
            DetachEntity(stretcherObject, true, true)
            SetVehicleOnGroundProperly(stretcherObject)

            SetMovingState((GetVehicleNetId(stretcherObject)), false)
        end

        if IsControlJustPressed(0, Config.Keys.load) then -- Load Stretcher
            ClearPedTasksImmediately(PlayerPedId())
            AttachToAmbulance(stretcherObject)
        end

        if IsControlJustPressed(0, Config.Keys.take) then -- Drop Stretcher
            ClearPedTasksImmediately(PlayerPedId())
            SetVehicleExtra(stretcherObject, 1, 1)
            SetVehicleExtra(stretcherObject, 2, 0)
            DetachEntity(stretcherObject, true, false)
            SetVehicleOnGroundProperly(stretcherObject)

            -- Corrects offset when setting the stretcher down
            local playerPed = PlayerPedId()
            local OffsetCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.127, 1.375, -0.030)
            SetEntityCoords(stretcherObject, OffsetCoords.x, OffsetCoords.y, OffsetCoords.z)

            SetMovingState((GetVehicleNetId(stretcherObject)), false)
        end
    end
end


function AttachToAmbulance(stretcherObject)
    local nearestVehicle, vehicleConfig = UTIL.GetClosestVehicleFromPedPos(PlayerPedId(), 20.0, 7.0, true, Config.Vehicles)
    
    if nearestVehicle and vehicleConfig then
        local vehicleCoords = GetEntityCoords(nearestVehicle)
        local distanceToVehicle = #(GetEntityCoords(PlayerPedId()) - vehicleCoords)
        if distanceToVehicle > vehicleConfig.dist then
            if Config.Debug.messages then
                print("Player is not within the required distance to the vehicle.")
            end
            return
        end
        
        NetworkRequestControlOfEntity(nearestVehicle)
        
        local vehicleBone = -1

        if vehicleConfig.powerload then
            vehicleBone = GetEntityBoneIndexByName(nearestVehicle, "bonnet")
            if vehicleBone == -1 then
                if Config.Debug.messages then
                    print("This vehicle does not support powerload.")
                end
                return
            end
        else
            vehicleBone = GetEntityBoneIndexByName(nearestVehicle, "chassis_dummy")
            if Config.Debug.messages then
                print("Vehicle bone detected: chassis dummy")
            end
            if vehicleBone == -1 then
                vehicleBone = GetEntityBoneIndexByName(nearestVehicle, "chassis")
                if Config.Debug.messages then
                    print("Vehicle bone detected: chassis")
                end
            end
            if vehicleBone == -1 then
                vehicleBone = GetEntityBoneIndexByName(nearestVehicle, "bodyshell")
                if Config.Debug.messages then
                    print("Vehicle bone detected: bodyshell")
                end
            end
            if vehicleBone == -1 then
                vehicleBone = GetEntityBoneIndexByName(nearestVehicle, "seat_dside_f")
                if Config.Debug.messages then
                    print("Vehicle bone detected: driver seat")
                end
            end
        
            if vehicleBone == -1 then
                if Config.Debug.messages then
                    print("Bone index not found.")
                end
                return
            end
        end

        if vehicleBone ~= -1 then
        SetVehicleHasBeenOwnedByPlayer(nearestVehicle, true)
        SetEntityAsMissionEntity(nearestVehicle, true, true)
        
        SetVehicleExtra(stretcherObject, 1, 1)
        SetVehicleExtra(stretcherObject, 2, 0)
        
        AttachEntityToEntity(stretcherObject, nearestVehicle, vehicleBone, vehicleConfig.xOffset, vehicleConfig.yOffset, vehicleConfig.zOffset, 0.0, 0.0, vehicleConfig.rotOffset, false, false, true, false, 2, true)
        SetMovingState((GetVehicleNetId(stretcherObject)), true)
        end

        if Config.Debug.messages then print("Stretcher attached to ambulance.") end

    elseif Config.Debug.messages then
        print("Vehicle not found or no matching configuration.")
    end
end



-- Stretcher Equipment Menu Events
AddEventHandler('ToggleHeadrest', function()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local stretcherObject = GetClosestVehicle(playerCoords, 3.0, GetHashKey(Config.Stretcher.modelHash), 70)
    if IsVehicleExtraTurnedOn(stretcherObject, 11) then
        SetVehicleExtra(stretcherObject, 11, 1)
        SetVehicleExtra(stretcherObject, 12, 0)
    elseif IsVehicleExtraTurnedOn(stretcherObject, 12) then
        SetVehicleExtra(stretcherObject, 11, 0)
        SetVehicleExtra(stretcherObject, 12, 1)
    end
end)

AddEventHandler('ToggleBackboard', function()
    UTIL.ToggleEquipmentExtra(PlayerPedId(), 3)
end)

AddEventHandler('ToggleMonitor', function()
    UTIL.ToggleEquipmentExtra(PlayerPedId(), 5)
end)

AddEventHandler('ToggleRedBag', function()
    UTIL.ToggleEquipmentExtra(PlayerPedId(), 6)
end)

AddEventHandler('ToggleBlueBag', function()
    UTIL.ToggleEquipmentExtra(PlayerPedId(), 7)
end)

-- Stretcher  Menu Events
local EventHandlers = {
    ["StretcherReceiveCPR"] = { "mini@cpr@char_b@cpr_str", "cpr_pumpchest", {0, 0.0, 0.2, 1.5, 0.0, 0.0, 180.0, false, false, false, false, 2, true} },
    ["StretcherSitRight"] = { "amb@prop_human_seat_chair_food@male@base", "base", {0, 0.0, -0.2, 0.55, 0.0, 0.0, -90.0, false, false, false, false, 2, true} },
    ["StretcherSitLeft"] = { "amb@prop_human_seat_chair_food@male@base", "base", {0, 0.0, -0.2, 0.55, 0.0, 0.0, 90.0, false, false, false, false, 2, true} },
    ["StretcherSitEnd"] = { "anim@heists@fleeca_bank@hostages@intro", "intro_loop_ped_a", {0, 0.0, -1.1, 1.05, 0.0, 0.0, 180.0, false, false, false, false, 2, true} },
    ["StretcherSitUpright"] = { "amb@world_human_stupor@male@base", "base", {0, -0.05, 0.1, 1.5, 0.0, 0.0, 180.0, false, false, false, false, 2, true} },
    ["StretcherSitUprightLegsCrossed"] = { "switch@michael@tv_w_kids", "001520_02_mics3_14_tv_w_kids_exit_trc", {0, 0.0, -0.075, 1.6, 0.0, 0.0, 180.0, false, false, false, false, 2, true} },
    ["StretcherSitUprightKneesTucked"] = { "anim@amb@casino@out_of_money@ped_male@02b@base", "base", {0, 0.0, 0.1, 1.52, 0.0, 0.0, 184.0, false, false, false, false, 2, true} },
    ["StretcherLieBack"] = { "savecouch@", "t_sleep_loop_couch", {0, 0.0, 0.2, 1.1, 0.0, 0.0, 180.0, false, false, false, false, 2, true} },
    ["StretcherLieLeft"] = { "amb@lo_res_idles@", "world_human_bum_slumped_right_lo_res_base", {0, 0.2, 0.1, 1.55, 0.0, 0.0, 100.0, false, false, false, false, 2, true} },
    ["StretcherLieUpright"] = { "amb@world_human_stupor@male_looking_left@base", "base", {0, 0.0, 0.3, 1.5, 0.0, 0.0, 180.0, false, false, false, false, 2, true} },
    ["StretcherLieProne"] = { "amb@world_human_sunbathe@male@front@base", "base", {0, 0.0, 0.2, 1.5, 0.0, 0.0, 0.0, false, false, false, false, 2, true} },

}

for event, data in pairs(EventHandlers) do
    AddEventHandler(event, function()
        UTIL.PlayAnimation(PlayerPedId(), data[1], data[2], data[3])
    end)
end


AddEventHandler('StretcherGetUp', function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local stretcherHash = GetHashKey(Config.Stretcher.modelHash)
    local stretcherObject = GetClosestVehicle(playerCoords.x, playerCoords.y, playerCoords.z, 5.0, stretcherHash, 70)

    if not stretcherObject then return end
    if not GetEntityModel(stretcherObject) == stretcherHash then return end

    if not NetworkHasControlOfEntity(stretcherObject) then
        NetworkRequestControlOfEntity(stretcherObject)
        while not NetworkHasControlOfEntity(stretcherObject) do
            Wait(0)
        end
        TriggerEvent('StretcherGetUp')
        return
    end

    local stretcherCoords = GetEntityCoords(stretcherObject)
    local stretcherHeading = GetEntityHeading(stretcherObject)

    local extras = {}
    for i = 0, 20 do
        if DoesExtraExist(stretcherObject, i) then
            extras[i] = IsVehicleExtraTurnedOn(stretcherObject, i) and 0 or 1
        end
    end

    DetachEntity(playerPed, true, true)
    local x, y, z = table.unpack(stretcherCoords + GetEntityForwardVector(stretcherObject) * -1.5)
    SetEntityCoords(playerPed, x, y, z)
    ClearPedTasksImmediately(playerPed)

    PreventTakingStretcherWhileSeated = false

    SetVehicleHasBeenOwnedByPlayer(stretcherObject, false)
    SetEntityAsMissionEntity(stretcherObject, true, true)
    RemoveStretcherId(GetVehicleNetId(stretcherObject))
    DeleteVehicle(stretcherObject)
    SetEntityAsNoLongerNeeded(stretcherObject)

    UTIL.LoadModel(stretcherHash)

    local newStretcher = CreateVehicle(stretcherHash, stretcherCoords.x, stretcherCoords.y, stretcherCoords.z, stretcherHeading, true, false)

    SetVehicleOnGroundProperly(newStretcher)
    SetVehicleHasBeenOwnedByPlayer(newStretcher, true)

    for extra, state in pairs(extras) do
        SetVehicleExtra(newStretcher, extra, state)
    end
    SetModelAsNoLongerNeeded(stretcherHash)

    AddStretcherId(GetVehicleNetId(newStretcher))
    SetSittingState(GetVehicleNetId(newStretcher), false)
    if Config.Debug.messages then
        print(GetVehicleNetId(newStretcher))
    end
end)