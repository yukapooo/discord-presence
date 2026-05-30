RegisterNetEvent('discord:getPlayerCount', function()
    TriggerClientEvent(
        'discord:setPlayerCount',
        source,
        GetNumPlayerIndices()
    )
end)
