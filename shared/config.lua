Config = {}

Config.framework = 'qb' -- 'esx', 'qb'
--
Config.PMCommand = 'msg'
Config.PMColor = {
    send = 'rgb(204, 59, 217)',
    received = 'rgb(51, 212, 49)'
}
--
Config.ClearChat = 'clear'
Config.ClearChatAll = 'clearall'
--
Config.MuteCommand = 'mute'
Config.MuteMSGColor = 'rgb(252, 198, 3)'
--
Config.UnmuteCommand = 'unmute'
--
Config.AdminGroups = { 'god', 'admin' }
--
Config.Messages = {
    {
        command = 'me',                                -- Chat command
        admin = false,                                 -- Whether it's an admin command
        jobs = nil,                                    -- Which jobs can use the command. Use the following formats: a single job -> 'police' | multiple jobs -> {'police', 'ambulance'}
        cooldown = nil,                                -- Cooldown time to reuse the command in seconds. Set to nil to disable
        distance = 10,                                 -- Distance at which the message can be read
        title = 'Me',                                  -- Title displayed at the beginning of the message
        price = nil,                                   -- Price to use the command. Set to nil to disable
        sound = false,                                 -- Enable sound for the message
        color = 'rgb(247, 42, 27)',                    -- Title color. Accepts any CSS format: hex, rgb, keyword
        webhook = true,                                -- To be implemented
        suggestions = {
            title = 'ME - message to express actions', -- Command description when typing
            helpTexts = {
                {
                    name = 'message',     -- Title of the first argument
                    help = 'Message text' -- Explanation of the first argument
                }
            }
        }
    },
    {
        command = 'do',
        admin = false,
        distance = 10,
        title = 'Do',
        sound = false,
        color = 'rgb(51, 87, 232)',
        suggestions = {
            title = 'DO - message to describe surroundings',
            helpTexts = {
                {
                    name = 'message',
                    help = 'Message text'
                }
            }
        }
    },
    {
        command = 'id',
        admin = false,
        title = 'Request ID',
        sound = false,
        color = '#8B93FF',
        suggestions = {
            title = 'ID - channel to request someone\'s ID',
            helpTexts = {
                {
                    name = 'message',
                    help = 'Message text'
                }
            }
        }
    },
    {
        command = 'ooc',
        admin = false,
        distance = 15,
        title = '[ OOC ]',
        sound = false,
        color = 'rgb(145, 145, 145)',
        suggestions = {
            title = 'OOC - channel for out-of-character chat',
            helpTexts = {
                {
                    name = 'message',
                    help = 'Message text'
                }
            }
        }
    },
}


--
Config.AutoAnnounces = {
    enable = true,              -- Enables automatic announcements
    intervals = 30,             -- Interval between announcements in minutes
    color = 'rgb(195, 139, 0)', -- Color of the announcements
    title = 'Kings',            -- Title of the announcements
    texts = {
        "For any doubt, bug or report use /report",
        "If you can't find something, look carefully with your eye (Alt)",
        'Not knowing the rules does not exempt you from the consequences',
        'Use the chat properly',
        'Check the commands-ic channel to make the game easier for you'
    }
}

--
Config.DiceCommand = {
    enable = true,
    maxDices = 5,
    command = 'dice',
    distance = 10,
    color = 'rgb(195, 139, 0)',
    suggestions = {
        title = 'Dice - Roll between 1 to 5 dice',
        helpTexts = {
            {
                name = 'dice',
                help = 'Number of dice'
            }
        }
    }
}

--
Config.TryCommand = {
    enable = true,
    command = 'try',
    distance = 10,
    color = 'rgb(252, 3, 123)',
    suggestions = {
        title = 'Try - Test your luck with a 50% chance of success'
    }
}

--
Config.StaffChat = {
    enable = true,
    command = 'rstaff',
    color = 'rgb(3, 252, 227)',
    suggestions = {
        title = 'Staff - Private channel only for server staff.',
        helpTexts = {
            {
                name = 'message',
                help = 'Message text'
            }
        }
    }
}

--
Config.ClearCommand = {
    enable = true,
    clearChat = 'clear',
    clearChatAll = 'clearall'
}
