local IsTextInUse = false
local TempPlayerCoords, TempChairCoords = {}, {}
local Chairs, TempLockChairs = {}, nil
local PlayerSit = false

CreateThread(function()
    for k, v in pairs(Config.ChairLocations) do
        exports['ox_target']:addModel({ v.obj }, {
            {
                name = 'qbx_sit:client:Chair_' .. k,
                label = 'Sit',
                icon = 'fa-solid fa-chair',
                distance = 1.0,
                event = 'qbx_sit:client:Chair',
                args = {
                    chair = k,
                    object = v.obj
                }
            }
        })
    end
end)

local function RunLoop()
    PlayerSit = true
    if not IsTextInUse then 
        exports['five-textui']:showTextUI("sit_text", "[ F ] Stand up", "F")
        IsTextInUse = true
    end

    CreateThread(function()
        while PlayerSit do 
            Wait(5)
            if IsControlJustPressed(0, 23) then
                PlayerSit = false
                if IsTextInUse then 
                    exports['five-textui']:hideTextUI("sit_text")
                    IsTextInUse = false
                end
                ClearPedTasksImmediately(PlayerPedId())
                FreezeEntityPosition(PlayerPedId(), false)
                SetEntityHeading(PlayerPedId(), TempPlayerCoords.oldH)
                SetEntityCoords(PlayerPedId(), TempPlayerCoords.oldX, TempPlayerCoords.oldY, TempPlayerCoords.oldZ)
                TempPlayerCoords, TempChairCoords = {}, {}
                TempLockChairs = nil
                break
            end
        end
    end)

    Wait(4000)
    if IsTextInUse then 
        exports['five-textui']:hideTextUI("sit_text")
        IsTextInUse = false
    end
end

RegisterNetEvent('qbx_sit:client:Chair', function(data)
    local args = data.args
    if not args then return end
    if PlayerSit then return end

    local ped = PlayerPedId()
    local plyCoords = GetEntityCoords(ped)

    print('[Client] Event received: qbx_sit:client:Chair | Chair ID:', args.chair)

    lib.callback('qbx_sit:GetChairs', false, function(GChairs)
        Chairs = GChairs
        local closestObject = GetClosestObjectOfType(plyCoords.x, plyCoords.y, plyCoords.z, 3.0, args.object, false, false, false)
        local coordsObject = GetEntityCoords(closestObject)
        if #(coordsObject - plyCoords) < 3.0 and closestObject ~= 0 then
            Chairs[closestObject] = closestObject
            TempLockChairs = closestObject
            TempChairCoords = {
                x = coordsObject.x,
                y = coordsObject.y,
                z = coordsObject.z,
                h = GetEntityHeading(closestObject) - 180.0
            }
            TempPlayerCoords = {
                oldX = plyCoords.x,
                oldY = plyCoords.y,
                oldZ = plyCoords.z,
                oldH = GetEntityHeading(ped)
            }
            FreezeEntityPosition(ped, true)
            SetEntityCoords(ped, coordsObject.x, coordsObject.y, coordsObject.z)
            TriggerServerEvent('qbx_sit:Server:Enter', args.chair)
            RunLoop()
        end
    end)
end)


RegisterNetEvent('qbx_sit:Client:Animation', function(Current)
    print('[Client] Received animation event for chair:', Current)
    local ped = PlayerPedId()
    local chairConfig = Config.ChairLocations[Current]

    local tempX = TempChairCoords.x + (chairConfig.TempChairOffset and chairConfig.TempChairOffset.x or 0.0)
    local tempY = TempChairCoords.y + (chairConfig.TempChairOffset and chairConfig.TempChairOffset.y or 0.0)
    local tempZ = TempChairCoords.z + (chairConfig.TempChairOffset and chairConfig.TempChairOffset.z or 0.0)
    local tempH = TempChairCoords.h + (chairConfig.TempChairOffset and chairConfig.TempChairOffset.h or 0.0)

    if chairConfig.zFixPlus then 
        tempZ = tempZ + chairConfig.zFixPlus
    elseif chairConfig.zFixM then
        tempZ = tempZ - chairConfig.zFixM
    end

    TaskStartScenarioAtPosition(ped, chairConfig.SitAnimation.anim, tempX, tempY, tempZ, tempH, 0, true, true)
end)
