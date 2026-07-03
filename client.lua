local QBCore = exports['qb-core']:GetCoreObject()
local serverPlayers = 0
local isLoggedIn = false

-- 人数受信
RegisterNetEvent('discord:setPlayerCount', function(count)
    serverPlayers = count
end)

-- QBCoreログイン検知
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)

-- Discord初期化（FiveM起動直後）
CreateThread(function()
    SetDiscordAppId(1456960062051586134) -- discord DeveloperのApp ID

    while true do
        Wait(5000)

        if not isLoggedIn then
            -- 接続中 / ロード中
            SetRichPresence("🔗 Connecting to server...")

            SetDiscordRichPresenceAsset("logo")
            SetDiscordRichPresenceAssetText("Yourserver")

        else
            -- ログイン後
            TriggerServerEvent('discord:getPlayerCount')

            local playerId = GetPlayerServerId(PlayerId())

            SetRichPresence(
                "ID：" .. playerId ..
                "｜Player：" .. serverPlayers .. "/64"
            )

            SetDiscordRichPresenceAsset("logo")
            SetDiscordRichPresenceAssetText("Yourserver")
        end
    end
end)
