fx_version 'cerulean'
game 'gta5'

description 'Benite Apparel DLC: Politi'
author 'FuTTiiZ'

-- Lua 5.4
lua54 'yes'

server_script 'sv_loader.lua'
client_script 'cl_loader.lua'

file 'streaming/**'
ui_page 'streaming/index.html'

dependencies {
  '/onesync'
}