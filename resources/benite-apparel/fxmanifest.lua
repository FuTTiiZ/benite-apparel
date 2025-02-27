fx_version 'cerulean'
game 'gta5'

description 'Benite Apparel'
author 'FuTTiiZ'
version '1.2'

language 'en-US' -- Resource language. Can be any .json locale file found in ./locales/ (you can even add your own language!)

verbose 'yes' -- Enables/disables verbose mode. Should be either "yes" or "no". This will print debug messages to the console.

-- Lua 5.4
lua54 'yes'

shared_scripts {
  'shared/functions.lua',
  'shared/data.lua',
  'locales/loader.lua',
  'shared/dlcs.lua',
  'shared/clothing.lua',
  'shared/drawables.lua'
}

server_scripts {
  'server/cb.lua',

  'server/sync.lua',
  'server/scope.lua',
  'server/state.lua',
  'server/main.lua'
}

client_scripts {
  'client/data.lua',

  'client/cb.lua',

  'client/verify.lua',
  'client/streaming.lua',
  'client/textures.lua',
  'client/clothing.lua',
  'client/cam.lua',
  'client/nui.lua',
  'client/menu.lua',
  'client/main.lua'
}

files {
  'locales/*.json',

  'data/mp_m_freemode_01_benite_apparel.meta',

  'client/nui/index.html',
  'client/nui/**'
}

ui_page 'client/nui/index.html'

data_file 'SHOP_PED_APPAREL_META_FILE' 'data/mp_m_freemode_01_benite_apparel.meta'

dependencies {
  'spawnmanager',
  '/onesync'
}