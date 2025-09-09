Config = {}
--
Config.AdminGroups = { "admin", "mod" } --Groups that can mute and use staff chat

Config.AutoAnnounces = {
    enabled = true, -- Enable automatic announcements
    intervals = 30, -- Interval between announcements in minutes
    color = "#ef7d05", -- Announcement color (any CSS-accepted format works)
    title = "System", -- Title of the announcements
    texts = {
        "For any questions, bugs, or reports use /report",
        "If you can't find something, look carefully with your eye (Alt)",
        "Not knowing the rules does not exempt you from the consequences",
        "Use the chat properly",
        "Check the ic-commands channel to make your gameplay easier",
    },
}

Config.ZoneMessages = {
    {
        coords = vector3(0.0, 0.0, 0.0), --Coordinates of the safe zone
        radius = 20, --Radius in meters
        cooldown = 30, --Cooldown in seconds
        message = "Test Message", --Message to display
    },
}

Config.environmentMessages = { --Environment messages
    {
        command = "help", --Command to execute the message
        title = "[ Help ]", --Title of the message
        color = "#ef7d05", --Message color
        jobs = { ["police"] = 0, ["ambulance"] = 0 }, --Jobs that can read the message and minimum grade
        sound = true, --If it should emit a sound
        sentMsg = "Environment message has been sent", --Message for the sender. nil to disable
        cooldown = 30, --Cooldown before using again
        blip = { --Blip of the sender’s position for the receiver. nil to disable
            duration = 10, --Blip duration in seconds
            sprite = 366, --https://docs.fivem.net/docs/game-references/blips
            color = 54,
            scale = 1.0, --Blip size
            text = "Help", --Blip text
            area = 1, --Blip area color. nil to disable area
        },
        chatSuggestion = { --Chat suggestion texts. nil to disable
            name = "message",
            help = "Message text",
            text = "Help - Environment message to alert emergency services",
        },
    },
}

Config.meCommand = {
    enabled = true,
    command = "me",
    title = "[ Me ]",
    color = "rgb(247, 42, 27)",
    distance = 20,
    sound = false,
    chatSuggestion = {
        name = "message",
        help = "Message text",
        text = "Me - Message to express actions",
    },
}

Config.doCommand = {
    enabled = true,
    command = "do",
    title = "[ Do ]",
    color = "rgb(51, 87, 232)",
    distance = 20,
    sound = false,
    chatSuggestion = {
        name = "message",
        help = "Message text",
        text = "Do - Message to describe the environment",
    },
}

Config.askIdCommand = {
    enabled = true,
    command = "askid",
    title = "[ Ask ID ]",
    color = "#e77601",
    distance = false,
    cooldown = 30,
    sound = false,
    chatSuggestion = {
        name = "message",
        help = "Message text",
        text = "Channel to request a player’s ID",
    },
}

Config.oocCommand = {
    enabled = true,
    command = "ooc",
    title = "[ OOC ]",
    color = "rgb(180, 180, 180)",
    distance = 20,
    sound = false,
    chatSuggestion = {
        name = "message",
        help = "Message text",
        text = "OOC - Channel for out-of-character chat",
    },
}

Config.msgCommand = {
    enabled = true,
    command = "msg",
    chatSuggestion = {
        name = "message",
        help = "Message text",
        text = "Direct message to another player",
    },
}

Config.staffCommand = {
    groups = { "admin", "mod" },
    adminChat = {
        enabled = true,
        command = "rstaff",
        chatSuggestion = {
            name = "message",
            help = "Message text",
            text = "Staff - Private channel only for staff",
        },
    },
    silence = {
        enabled = true,
        command = "silence",
        chatSuggestion = {
            name = "id",
            help = "Player ID to silence",
            text = "Silence a player",
        },
    },
    unsilence = {
        enabled = true,
        command = "unsilence",
        chatSuggestion = {
            name = "id",
            help = "Player ID to unsilence",
            text = "Remove silence from a player",
        },
    },
}

Config.tryCommand = {
    enabled = true,
    command = "try",
    options = { "You got lucky!", "Oops... it didn’t work" },
    distance = 20,
    chatSuggestion = { text = "Try - Test your luck with a 50% chance" },
}

Config.diceCommand = {
    enabled = true,
    command = "dice",
    maxDices = 5,
    distance = 20,
    color = "rgb(204, 59, 217)",
    chatSuggestion = {
        name = "dice",
        help = "Number of dice",
        text = "Dice - Roll 1 to 5 six-sided dice",
    },
}

Config.clearCommand = {
    enable = true,
    command = "clear",
    chatSuggestion = { text = "Clear the chat completely" },
}

Config.clearAllCommand = {
    enable = true,
    command = "clearall",
    chatSuggestion = { text = "Clear the chat for all users (Admin)" },
}

--
Config.language = {
    system = "🧟Survivor🧟",
    noText = "You didn’t enter any text",
    noSelfText = "You can’t send a message to yourself",
    noID = "The provided ID does not exist",
    msgTo = "MSG to [ %s ]: %s",
    clearAll = "The chat has been cleared by an administrator.",
    playerSilenced = "%s successfully silenced",
    playerUnsilenced = "%s is no longer silenced",
    silenced = "You have been silenced by an administrator.",
    unsilenced = "An administrator has removed your silence.",
    notSilenced = "This player was not silenced",
    silencedAlready = "This player is already silenced",
    cantSilenceAdmin = "You can’t silence an administrator",
    cantSilenceSelf = "You can’t mute yourself, dumbass",
    canChat = "You cannot chat, you were silenced by an administrator",
    cooldown = "You must wait before using this command again",
    zoneMessage = "Enviorement",
}

--
PlayerHasGroup = function(jobs) --Function to check if the player has any of the jobs required for environment messages
    --jobs equals the jobs table from the environment messages
    return exports.qbx_core:HasGroup(jobs)
end
