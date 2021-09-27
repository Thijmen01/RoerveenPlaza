fx_version 'adamant'
game 'gta5'

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Roerveen MediaPlaza script'
author 'Peak'
version '1.0'

client_scripts {
	"config.lua",
	"client/main.lua",
}

server_scripts {
	"config.lua",
	"server/main.lua",
}

files {
    'h.html'
}

export "startUI"