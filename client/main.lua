if Config.framework == 'esx' then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.framework == 'qb' then
    QBCore = exports['qb-core']:GetCoreObject()
end

CreateThread(function()
    --
    for _, msg in pairs(Config.Messages) do
        local helpTexts = {}

        for _, value in pairs(msg.suggestions.helpTexts) do
            helpTexts[#helpTexts + 1] = { name = value.name, help = value.help }
        end

        TriggerEvent('chat:addSuggestion', '/' .. msg.command, msg.suggestions.title, helpTexts)
    end
    --
    TriggerEvent('chat:addSuggestion', '/' .. Config.MuteCommand, Lang.muteHelpTitle,
        { { name = Lang.muteHelpName, help = Lang.muteHelpText } })
    --
    TriggerEvent('chat:addSuggestion', '/' .. Config.UnmuteCommand, Lang.unmuteHelpTitle,
        { { name = Lang.unmuteHelpName, help = Lang.unmuteHelpText } })
    --
    TriggerEvent('chat:addSuggestion', '/' .. Config.StaffChat.command, Config.StaffChat.suggestions.title,
        Config.StaffChat.suggestions.helpTexts)
    --
    TriggerEvent('chat:addSuggestion', '/' .. Config.TryCommand.command, Config.TryCommand.suggestions.title, {})
    --
    TriggerEvent('chat:addSuggestion', '/' .. Config.DiceCommand.command, Config.DiceCommand.suggestions.title,
        Config.DiceCommand.suggestions.helpTexts)
    --
    TriggerEvent('chat:addSuggestion', '/' .. Config.ClearCommand.clearChat, Lang.clearChat, {})
    --
    TriggerEvent('chat:addSuggestion', '/' .. Config.ClearCommand.clearChatAll, Lang.clearChatAll, {})
end)

PlayClientSound = function()
    PlaySoundFrontend(1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
end

Notification = function(msg, type, time)
    QBCore.Functions.Notify(msg, type, time)
    --ESX.ShowNotification(msg, type, time)
end

LocalPlayer.state:set('bm_rpchat_cooldown', false, true)
MessageCooldown = function(time)
    LocalPlayer.state:set('bm_rpchat_cooldown', true, true)
    CreateThread(function()
        local waitTime = time * 1000
        while waitTime > 0 do
            waitTime = waitTime - 50
            Wait(50)
        end
        LocalPlayer.state:set('bm_rpchat_cooldown', false, true)
    end)
end

--Events
RegisterNetEvent('bm_rpchat:PlaySound', PlayClientSound)
RegisterNetEvent('bm_rpchat:Notification', Notification)
RegisterNetEvent('bm_rpchat:MessageCooldown', MessageCooldown)
