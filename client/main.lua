LocalPlayer.state.bm_rpchat_muted = false
LocalPlayer.state.bm_rpchat_cooldown = false
LocalPlayer.state.bm_chatmessage = false

SetThisScriptCanRemoveBlipsCreatedByAnyScript(true)

local cooldowns = {}
local cdEnabled = false
--
local RegisterMsgCommand = function(data)
    RegisterCommand(data.command, function(source, args, rawCommand)
        if cooldowns[data.command] then
            return Notification(Config.language.cooldown, "error", 4000)
        end

        if LocalPlayer.state.bm_rpchat_muted then
            return Notification(Config.language.canChat, "error", 4000)
        end

        local message = rawCommand:sub(string.len(data.command) + 1)
        if string.len(message) < 1 then
            return
        end

        if data.cooldown then
            CooldownThread(data.command, data.cooldown)
        end

        data.message = message
        SendMessage(data)
    end)
end
--
local commandList = {}

if Config.meCommand and Config.meCommand.enabled then
    commandList[#commandList + 1] = Config.meCommand

    TriggerEvent(
        "chat:addSuggestion",
        "/" .. Config.meCommand.command,
        Config.meCommand.chatSuggestion.text,
        { { name = Config.meCommand.chatSuggestion.name, help = Config.meCommand.chatSuggestion.help } }
    )
end

if Config.doCommand and Config.doCommand.enabled then
    commandList[#commandList + 1] = Config.doCommand

    TriggerEvent(
        "chat:addSuggestion",
        "/" .. Config.doCommand.command,
        Config.doCommand.chatSuggestion.text,
        { { name = Config.doCommand.chatSuggestion.name, help = Config.doCommand.chatSuggestion.help } }
    )
end

if Config.askIdCommand and Config.askIdCommand.enabled then
    commandList[#commandList + 1] = Config.askIdCommand

    TriggerEvent(
        "chat:addSuggestion",
        "/" .. Config.askIdCommand.command,
        Config.askIdCommand.chatSuggestion.text,
        { { name = Config.askIdCommand.chatSuggestion.name, help = Config.askIdCommand.chatSuggestion.help } }
    )
end

if Config.oocCommand and Config.oocCommand.enabled then
    commandList[#commandList + 1] = Config.oocCommand

    TriggerEvent(
        "chat:addSuggestion",
        "/" .. Config.oocCommand.command,
        Config.oocCommand.chatSuggestion.text,
        { { name = Config.oocCommand.chatSuggestion.name, help = Config.oocCommand.chatSuggestion.help } }
    )
end

CreateThread(function()
    for _, data in pairs(commandList) do
        if data.enabled then
            RegisterMsgCommand(data)
        end
    end

    --MUTE
    if Config.staffCommand.silence.enabled then
        TriggerEvent(
            "chat:addSuggestion",
            "/" .. Config.staffCommand.silence.command,
            Config.staffCommand.silence.chatSuggestion.text,
            {
                {
                    name = Config.staffCommand.silence.chatSuggestion.name,
                    help = Config.staffCommand.silence.chatSuggestion.help,
                },
            }
        )
    end

    --UNMUTE
    if Config.staffCommand.unsilence.enabled then
        TriggerEvent(
            "chat:addSuggestion",
            "/" .. Config.staffCommand.unsilence.command,
            Config.staffCommand.unsilence.chatSuggestion.text,
            {
                {
                    name = Config.staffCommand.unsilence.chatSuggestion.name,
                    help = Config.staffCommand.unsilence.chatSuggestion.help,
                },
            }
        )
    end

    --STAFF CHAT
    if Config.staffCommand.adminChat.enabled then
        RegisterCommand(Config.staffCommand.adminChat.command, function(source, args, rawCommand)
            local message = rawCommand:sub(string.len(Config.staffCommand.adminChat.command) + 1)
            if string.len(message) < 1 then
                return
            end
            local data = {}
            data.staff = true
            data.message = message
            data.sound = true
            SendMessage(data)
        end)

        TriggerEvent(
            "chat:addSuggestion",
            "/" .. Config.staffCommand.adminChat.command,
            Config.staffCommand.adminChat.chatSuggestion.text,
            {
                {
                    name = Config.staffCommand.adminChat.chatSuggestion.name,
                    help = Config.staffCommand.adminChat.chatSuggestion.help,
                },
            }
        )
    end

    --TRY
    if Config.tryCommand then
        RegisterCommand(Config.tryCommand.command, function(source, args, rawCommand)
            local options = Config.tryCommand.options
            local result = options[math.random(1, #options)]
            local data = {}
            data.try = true
            data.distance = Config.tryCommand.distance
            data.result = result
            SendMessage(data)
        end)

        TriggerEvent("chat:addSuggestion", "/" .. Config.tryCommand.command, Config.tryCommand.chatSuggestion.text, {})
    end

    --DICES
    if Config.diceCommand.enabled then
        RegisterCommand(Config.diceCommand.command, function(source, args, rawCommand)
            local amount = tonumber(args[1]) or 1
            if type(amount) ~= "number" then
                return
            end

            if not amount or amount < 1 then
                amount = 1
            end

            if amount > Config.diceCommand.maxDices then
                amount = Config.diceCommand.maxDices
            end
            --
            local sides = {
                [1] = "fas fa-dice-one",
                [2] = "fas fa-dice-two",
                [3] = "fas fa-dice-three",
                [4] = "fas fa-dice-four",
                [5] = "fas fa-dice-five",
                [6] = "fas fa-dice-six",
            }

            local dices = ""
            for i = 1, amount, 1 do
                local text = '<i class="' .. sides[math.random(1, 6)] .. ' dice"></i>'
                dices = dices .. text
            end
            --
            local data = {}
            data.dices = dices
            data.distance = Config.diceCommand.distance
            SendMessage(data)
        end)

        TriggerEvent(
            "chat:addSuggestion",
            "/" .. Config.diceCommand.command,
            Config.diceCommand.chatSuggestion.text,
            { { name = Config.diceCommand.chatSuggestion.name, help = Config.diceCommand.chatSuggestion.help } }
        )
    end

    --MSG
    if Config.msgCommand then
        RegisterCommand(Config.msgCommand.command, function(source, args, rawCommand)
            local message = rawCommand:sub(string.len(Config.msgCommand.command) + 3 + string.len(tostring(source)))
            if string.len(message) < 1 then
                return Notification(Config.language.noText, "error", 4000)
            end

            local target = tonumber(args[1])
            if target == GetPlayerServerId(PlayerId()) then
                return Notification(Config.language.noSelfText, "error", 4000)
            end

            local playerExists = lib.callback.await("bm_rpchat:server:callback:DoesPlayerExist", false, target)
            if not playerExists then
                return Notification(Config.language.noID, "error", 4000)
            end

            local data = {}
            data.msg = true
            data.target = target
            data.message = message
            exports.chat:addMessage({
                template = '<div class="mensajes"><span class="mensajes-titulo" style="color:{0};">{1}:</span><span class="mensajes-texto">{2}</span></div>',
                args = { Config.diceCommand.color, string.format(Config.language.msgTo, target, message) },
            })
            SendMessage(data)
        end)

        TriggerEvent("chat:addSuggestion", "/" .. Config.msgCommand.command, Config.msgCommand.chatSuggestion.text, {
            { name = "id", help = "ID" },
            { name = Config.msgCommand.chatSuggestion.name, help = Config.msgCommand.chatSuggestion.help },
        })
    end

    --CLEAR CHAT
    if Config.clearCommand.enable then
        RegisterCommand(Config.clearCommand.command, function()
            TriggerEvent("chat:clear")
        end)

        TriggerEvent(
            "chat:addSuggestion",
            "/" .. Config.clearCommand.command,
            Config.clearCommand.chatSuggestion.text,
            {}
        )
    end

    --CLEAR ALL CHAT
    if Config.clearAllCommand.enable then
        TriggerEvent(
            "chat:addSuggestion",
            "/" .. Config.clearAllCommand.command,
            Config.clearAllCommand.chatSuggestion.text,
            {}
        )
    end

    --Auto Announces
    if Config.AutoAnnounces.enabled then
        CreateThread(function()
            while true do
                local random = math.random(1, #Config.AutoAnnounces.texts)
                exports.chat:addMessage({
                    template = '<div class="mensajes"><span class="mensajes-titulo" style="color: {0};">{1}:</span><span class="mensajes-texto">{2}</span></div>',
                    args = {
                        Config.AutoAnnounces.color,
                        Config.AutoAnnounces.title,
                        Config.AutoAnnounces.texts[random],
                    },
                })
                Wait((Config.AutoAnnounces.intervals * 60) * 1000)
            end
        end)
    end

    for key, data in pairs(Config.environmentMessages) do
        RegisterMsgCommand(data)

        if data.chatSuggestion then
            TriggerEvent(
                "chat:addSuggestion",
                "/" .. data.command,
                data.chatSuggestion.text,
                { { name = data.chatSuggestion.name, help = data.chatSuggestion.help } }
            )
        end
    end
end)

CreateCustomBlip = function(coords, sprite, color, scale, text, area)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, scale + 0.0 or 0.8)
    SetBlipColour(blip, color or 1)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text or "Ubicación")
    EndTextCommandSetBlipName(blip)

    if area then
        local radiusBlip = AddBlipForRadius(coords.x, coords.y, coords.z, 100.0) -- 100m de radio
        SetBlipColour(radiusBlip, area)
        SetBlipAlpha(radiusBlip, 80)
        return blip, radiusBlip
    end

    return blip
end

local blipData = {}
local blipThread = false
HandleBlipThread = function()
    if blipThread then
        return
    end

    blipThread = true

    CreateThread(function()
        while true do
            for blip, time in pairs(blipData) do
                if time < GetGameTimer() then
                    if DoesBlipExist(blip) then
                        RemoveBlip(blip)
                    end

                    blipData[blip] = nil
                end
            end

            local blipCount = 0

            for _ in pairs(blipData) do
                blipCount = blipCount + 1
            end

            if blipCount <= 0 then
                break
            end

            Wait(500)
        end
    end)

    blipThread = false
end

AddStateBagChangeHandler("bm_chatmessage", nil, function(bagName, key, data, _, replicated)
    if replicated or not data then
        return
    end
    --
    local pPed = GetPlayerPed(GetPlayerFromStateBagName(bagName))

    if data then
        if data.sentMsg then
            exports.chat:addMessage({
                template = '<div class="mensajes"><span class="mensajes-titulo" style="color: {0};">{1}:</span><span class="mensajes-texto">{2}</span></div>',
                args = {
                    data.color,
                    Config.language.system,
                    data.sentMsg,
                },
            })
        end

        if data.blip then
            local coords = GetEntityCoords(pPed)
            local blip, area = CreateCustomBlip(
                coords,
                data.blip.sprite,
                data.blip.color,
                data.blip.scale,
                data.blip.text,
                data.blip.area
            )

            blipData[blip] = GetGameTimer() + data.blip.duration * 1000

            if area then
                blipData[area] = GetGameTimer() + data.blip.duration * 1000
            end

            HandleBlipThread()
        end

        if data.jobs then
            if not PlayerHasGroup(data.jobs) then
                return
            end
        end

        if data.distance then
            local distance = #(GetEntityCoords(pPed) - GetEntityCoords(PlayerPedId()))
            if distance > data.distance then
                return
            end
        end

        if data.staff then
            local isAdmin =
                lib.callback.await("bm_rpchat:server:callback:IsAdmin", false, GetPlayerServerId(PlayerId()))

            if not isAdmin then
                return
            end

            exports.chat:addMessage({
                template = '<div class="mensajes"><span class="mensajes-titulo" style="color: {0};">{1}:</span><span class="mensajes-texto">{2}</span></div>',
                args = {
                    "rgb(3, 252, 227)",
                    "[ " .. GetPlayerName(GetPlayerFromStateBagName(bagName)) .. " ]" .. " " .. "[STAFF]",
                    data.message,
                },
            })
        elseif data.try then
            exports.chat:addMessage({
                template = '<div class="mensajes"><span class="mensajes-titulo" style="color:{0};">{1}:</span><span class="mensajes-texto">{2}</span></div>',
                args = {
                    "rgb(252, 3, 123)",
                    "[" .. GetPlayerServerId(GetPlayerFromStateBagName(bagName)) .. "]" .. " " .. "[Intentar]",
                    data.result,
                },
            })
        elseif data.dices then
            exports.chat:addMessage({
                template = '<div class="dados"><div class="mensajes-titulo" style="color:'
                    .. "rgb(195, 139, 0)"
                    .. ';> </div><div class="mensajes-texto dices">'
                    .. "[ "
                    .. GetPlayerServerId(GetPlayerFromStateBagName(bagName))
                    .. " ]"
                    .. "[ Dados ]"
                    .. ":"
                    .. data.dices
                    .. "</div></div>",
                args = {},
            })
        elseif data.msg then
            if data.target ~= GetPlayerServerId(PlayerId()) then
                return
            end

            exports.chat:addMessage({
                template = '<div class="mensajes"><span class="mensajes-titulo" style="color:{0};">{1}:</span><span class="mensajes-texto">{2}</span></div>',
                args = {
                    "rgb(51, 212, 49)",
                    "MSG de " .. "[ " .. GetPlayerServerId(GetPlayerFromStateBagName(bagName)) .. " ]",
                    data.message,
                },
            })
        else
            exports.chat:addMessage({
                template = '<div class="mensajes"><span class="mensajes-titulo" style="color: {0};">[ {1} ] {2}:</span><span class="mensajes-texto">{3}</span></div>',
                args = { data.color, GetPlayerServerId(GetPlayerFromStateBagName(bagName)), data.title, data.message },
            })
        end
        --
        if data.sound then
            PlayClientSound()
        end
    end
end)

CooldownThread = function(key, cd)
    CreateThread(function()
        cooldowns[key] = true
        Wait(cd * 1000)
        cooldowns[key] = nil
    end)
end

SendMessage = function(data)
    LocalPlayer.state:set("bm_chatmessage", data, true)
    LocalPlayer.state:set("bm_chatmessage", false, true)
end

PlayClientSound = function()
    PlaySoundFrontend(1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
end

Notification = function(msg, type, time)
    lib.notify({
        description = msg,
        type = type,
        duration = time,
    })
end

RegisterNetEvent("bm_rpchat:client:PlaySound", PlayClientSound)
RegisterNetEvent("bm_rpchat:client:Notification", Notification)

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    for blip, time in pairs(blipData) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
end)
