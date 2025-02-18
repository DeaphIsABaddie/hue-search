fx_version 'cerulean'
game 'gta5'

author 'hue'
description 'fivem bin searching script'
version '1.0.0'

client_scripts {
    'client/client.lua'
}

shared_script {
    "config.lua"
}

server_script {
    "server/server.lua"
}

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/ui.css'
}