fx_version 'cerulean'
game 'gta5'

author 'Stanley'
description 'Stretcher Script'
version '1.0.0'


shared_scripts {
    'shared/config.lua',
    'shared/utils.lua',
}

client_scripts {
    'dependencies/NativeUI.lua',
    'client/menu.lua',
    'client/cl_main.lua',
}

server_scripts {
    'server/sv_main.lua',
}

files {
	'data/vehicles.meta',
	'data/carvariations.meta',
}

data_file 'VEHICLE_METADATA_FILE' 'data/vehicles.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/carvariations.meta'
