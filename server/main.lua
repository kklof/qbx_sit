local Chairs = {}

lib.callback.register('qbx_sit:GetChairs', function(source)
           print('[Client] Chairs received from server')
    return Chairs
end)

RegisterNetEvent('qbx_sit:Server:LockSynce', function(obj, bool)
    if bool then 
        Chairs[obj] = obj
    else
        Chairs[obj] = nil
    end
    print(obj)
end)

RegisterNetEvent('qbx_sit:Server:Enter', function(Current)
      TriggerClientEvent('qbx_sit:Client:Animation', source, Current)

    TriggerClientEvent('qbx_sit:Client:Animation', source, Current)
end)
