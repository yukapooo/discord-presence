# discord-presence

FiveM / QBCore向けのシンプルな **Discord Rich Presence** リソースです。

Discordのプロフィール上に、サーバー接続状況・プレイヤーのサーバーID・現在の接続人数を表示できます。

## Features

- Discord Rich Presence対応
- FiveM起動・ロード中のステータス表示
- QBCoreログイン後にプレイヤー情報を表示
- 自分のサーバーIDを表示
- 現在のオンライン人数を表示
- Discord Developer Portalで設定した画像を表示
- 軽量なシンプル構成

## Preview

### 接続中

```text
🔗 Connecting to server...
```

### ログイン後

```text
ID：12｜Player：35/64
```

## Requirements

- FiveM Server
- [qb-core](https://github.com/qbcore-framework/qb-core)
- Discord Application / Rich Presence Assets

## Installation

1. `discord-presence` フォルダをFiveMサーバーの `resources` 内に配置します。

```text
resources/
└── discord-presence/
    ├── fxmanifest.lua
    ├── client.lua
    ├── server.lua
    └── README.md
```

2. `server.cfg` に以下を追加します。

```cfg
ensure qb-core
ensure discord-presence
```

3. `client.lua` のDiscord設定を自分のサーバー用に変更します。

4. サーバーを再起動してください。

## Discord Application Setup

Discord Developer PortalでRich Presence用のApplicationを作成してください。

1. Discord Developer Portalを開く
2. `New Application` からApplicationを作成
3. Application IDをコピー
4. Rich Presence用の画像を登録
5. `client.lua` の設定を変更

Discord Developer Portal:

https://discord.com/developers/applications

## Configuration

このリソースには専用の `config.lua` はありません。
設定は `client.lua` 内で直接変更します。

### Discord Application ID

```lua
SetDiscordAppId(0000000000000000000)
```

Discord Developer Portalで作成したApplicationの **Application ID** に変更してください。

例:

```lua
SetDiscordAppId(123456789012345678)
```

## Discord Logo

```lua
SetDiscordRichPresenceAsset("logo")
```

`logo` はDiscord Developer Portal側で登録したRich Presence Asset名です。

Developer Portalで登録した画像名と完全に同じ名前を指定してください。

例:

```lua
SetDiscordRichPresenceAsset("server_logo")
```

## Logo Hover Text

Discord上で画像にカーソルを合わせた際に表示される文字です。

```lua
SetDiscordRichPresenceAssetText("Yourserver")
```

自分のサーバー名に変更してください。

例:

```lua
SetDiscordRichPresenceAssetText("My FiveM Server")
```

## Maximum Players

現在のコードでは最大人数が `64` に固定されています。

```lua
SetRichPresence(
    "ID：" .. playerId ..
    "｜Player：" .. serverPlayers .. "/64"
)
```

サーバーの最大人数に合わせて変更してください。

### 例: 最大128人

```lua
SetRichPresence(
    "ID：" .. playerId ..
    "｜Player：" .. serverPlayers .. "/128"
)
```

## Update Interval

Discord Rich Presenceは現在5秒ごとに更新されます。

```lua
Wait(5000)
```

`5000` = 5秒です。

必要に応じて変更できますが、短くしすぎる必要はありません。

## Player Count

ログイン後、クライアントからサーバーへ現在人数を要求します。

```lua
TriggerServerEvent('discord:getPlayerCount')
```

サーバー側では以下で現在のオンライン人数を取得しています。

```lua
GetNumPlayerIndices()
```

取得した人数は対象プレイヤーのクライアントへ返されます。

## QBCore Login Detection

プレイヤーがQBCoreへログインしたタイミングでRich Presenceの表示を切り替えます。

```lua
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)
```

ログイン前は:

```text
🔗 Connecting to server...
```

ログイン後は:

```text
ID：サーバーID｜Player：現在人数/最大人数
```

という表示になります。

## File Structure

```text
discord-presence/
├── fxmanifest.lua
├── client.lua
├── server.lua
└── README.md
```

### `client.lua`

- Discord Rich Presence初期化
- QBCoreログイン検知
- サーバーID取得
- プレイヤー人数取得要求
- Rich Presence更新
- Discord画像設定

### `server.lua`

- 現在のオンライン人数を取得
- クライアントへ人数を送信

### `fxmanifest.lua`

FiveMリソース情報とClient / Server Scriptを定義しています。

## Example Customization

```lua
CreateThread(function()
    SetDiscordAppId(123456789012345678)

    while true do
        Wait(5000)

        if not isLoggedIn then
            SetRichPresence("🔗 Connecting to server...")

            SetDiscordRichPresenceAsset("logo")
            SetDiscordRichPresenceAssetText("My FiveM Server")
        else
            TriggerServerEvent('discord:getPlayerCount')

            local playerId = GetPlayerServerId(PlayerId())

            SetRichPresence(
                "ID：" .. playerId ..
                "｜Player：" .. serverPlayers .. "/64"
            )

            SetDiscordRichPresenceAsset("logo")
            SetDiscordRichPresenceAssetText("My FiveM Server")
        end
    end
end)
```

## Troubleshooting

### DiscordにRich Presenceが表示されない

以下を確認してください。

- Discordデスクトップアプリが起動している
- FiveMとDiscordを同じPCで起動している
- `SetDiscordAppId()` のApplication IDが正しい
- Discord Developer Portal側にAssetが登録されている
- Asset名と `SetDiscordRichPresenceAsset()` の名前が一致している
- `discord-presence` が正常に `ensure` されている

### ロゴが表示されない

以下の設定を確認してください。

```lua
SetDiscordRichPresenceAsset("logo")
```

Discord Developer Portalに登録したAsset名が `logo` ではない場合、そのAsset名へ変更してください。

### 人数が更新されない

`server.lua` が正しく読み込まれているか確認してください。

```lua
server_script 'server.lua'
```

また、F8 / Server Consoleにエラーが出ていないか確認してください。

## Notes

- 現在のバージョンはQBCore向けです。
- 最大人数は自動取得ではなく、初期状態では `/64` の固定表示です。
- Application ID、Asset名、サーバー名は自分の環境に合わせて変更してください。
- Discord側のAsset反映に少し時間がかかる場合があります。

## Version

`1.0.0`

