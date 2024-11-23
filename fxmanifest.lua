fx_version 'cerulean'

game 'gta5'
lua54 'yes'

author '_garny'

description 'BiggaMods Script Base'

files {
    'nui/**',
    'nui/assets/**'
    'locales/*.json'
}

ui_page 'nui/ui.html'

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua'
}
