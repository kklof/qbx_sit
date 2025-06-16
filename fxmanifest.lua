fx_version 'cerulean'
game 'gta5'

author 'klof'
description 'Sit System using ox_lib & ox_target - qbx_sit'
version '1.0.0'

lua54 'yes'

shared_script '@ox_lib/init.lua'

client_scripts {
    'config.lua',
    'client/main.lua',
}

server_scripts {
    'server/main.lua',
}

dependencies {
    'ox_lib',
    'ox_target',
    'five-textui'
}
