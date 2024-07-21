local textureDictPrefix<const> = 'benite_apparel'

---@type table<integer, integer>
local textureDicts<const> = {}

---@type boolean
DuiInitialized = false

---@type table<string, table>
DuiLoadQueue = {}

---@type table<string, table>
local duiData<const> = {}

---Encode string character to hex string
  ---@param character string
  ---@return string
local function charToHex(character)
  return string.format("%%%02X", string.byte(character))
end

---Used to encode DUI url params
  ---@param string string | number | table
  ---@return string
local function urlEncode(string)
  if not string then return '' end
  if type(string) == 'table' then
    string = json.encode(string)
  else
    string = tostring(string)
  end

  string = string:gsub("\n", "\r\n")
  string = string:gsub("([^%w ])", charToHex)
  string = string:gsub(" ", "+")

  return string
end

---Create DUI browser
  ---@param drawableId DrawableID
  ---@param filePath string
  ---@param params table<string, string|number>
function CreateDrawableDUI(drawableId, filePath, params)
  if not DuiInitialized then
    Log(1, 'Error: Cannot create drawable Streaming!')
    Log(1, '  Streaming is not initialised')
    return
  end

  local drawable<const> = GetDrawable(drawableId)
  local res<const> = drawable.resolution
  params.width = res.x
  params.height = res.y

  ---@type string
  local urlParams = '?'
  if params then
    for k,v in pairs(params) do
      urlParams = urlParams .. urlEncode(k)..'='..urlEncode(v)..'&'
    end
  end

  local url<const> = 'https://cfx-nui-'..ResourceName..'-dlc-'.. drawable.dlc ..'/streaming/'..drawableId..'/index.html'..urlParams
  local object<const> = CreateDui(url, math.floor(res[1]), math.floor(res[2]))
  local handle<const> = GetDuiHandle(object)

  duiData[params.textureId] = {
    object = object,
    handle = handle,

    filePath = filePath,
    textureName = drawable.textureName,

    drawableId = drawableId,

    replaceTextureDictName = textureDictPrefix ..'_'.. drawableId,
    replaceTextureName = params.textureId ..'_'.. GetGameTimer()
  }
end

---Handle DUI browser loaded
  ---@param data table
  ---@param cb function
RegisterNUICallback('streamingReady', function(data, cb)
  ---@type string, DrawableID
  local textureId, drawableId in data

  local dui<const> = duiData[textureId]

  CreateThread(function()
    -- Has replace texture dict loaded?
    while not HasStreamedTextureDictLoaded(dui.replaceTextureDictName) do
      RequestStreamedTextureDict(dui.replaceTextureDictName, false)
      Wait(0)
    end

    while not HasStreamedTextureDictLoaded(textureDictPrefix ..'_'.. drawableId) do
      RequestStreamedTextureDict(textureDictPrefix ..'_'.. drawableId, false)
      Wait(0)
    end
    local textureDict<const> = textureDicts[drawableId]

    local texture<const> = CreateRuntimeTextureFromDuiHandle(textureDict, dui.replaceTextureName, dui.handle) -- Create the texture with DUI

    -- Has DUI texture dict loaded?
--[[     while not HasStreamedTextureDictLoaded(textureDict) do
      RequestStreamedTextureDict(textureDict, false)
      print('2RequestStreamedTextureDict', textureDict)
      Wait(0)
    end
    print('textureDict loaded', textureDict, HasStreamedTextureDictLoaded(textureDict)) ]]
    Wait(250)

    AddReplaceTexture(dui.filePath, dui.textureName, dui.replaceTextureDictName, dui.replaceTextureName) -- Replace original texture with the created texture
  end)

  cb(1)
end)

---Destroy DUI browser and replaced texture
  ---@param textureId string
function DestroyDrawableDUI(textureId)
  local dui<const> = duiData[textureId]
  if not dui then
    Log(1, 'Error: Cannot destroy drawable Streaming!')
    Log(1, '  Streaming does not exist')
    return
  end

  CreateThread(function()
    if IsDuiAvailable(dui.object) then
      DestroyDui(dui.object)
    end

    RemoveReplaceTexture(dui.replaceTextureDictName, dui.replaceTextureName)

    RemoveReplaceTexture(dui.filePath, dui.textureName)

    duiData[textureId] = nil
  end)
end

---Get drawable DUI object
  ---@param textureId string
  ---@return integer
function GetDrawableDUIObject(textureId)
  local dui<const> = duiData[textureId]
  if not dui then
    Log(1, 'Error: Cannot get drawable Streaming!')
    Log(1, '  Streaming does not exist')
    return -1
  end

  return dui.object
end

---Initialise texture dictionaries for each drawableId
function InitDUI()
  if DuiInitialized then
    Log(1, 'Error: Cannot init Streaming!')
    Log(1, '  Streaming is already initialised')
    return
  end

  Log(4, 'Init Streaming')

  CreateThread(function()
    if not GetAllDrawables then
      Log(3, 'GetAllDrawables does not exist')
      Log(3, '  Awaiting GetAllDrawables...')
      repeat Wait(0) until GetAllDrawables
      Log(2, '  GetAllDrawables found!')
    end

    for drawableId, drawable in pairs(GetAllDrawables()) do
      textureDicts[drawableId] = CreateRuntimeTxd(textureDictPrefix ..'_'.. drawableId)
    end

    DuiInitialized = true

    for textureId, args in pairs(DuiLoadQueue) do
      CreateDrawableDUI(args[1], args[2], args[3])
    end
    DuiLoadQueue = {}
  end)
end

---Destroy all drawable DUIs
function ShutdownDUI()
  if not DuiInitialized then
    Log(1, 'Error: Cannot shut Streaming down!')
    Log(1, '  Streaming is not initialised')
    return
  end

  for textureId, dui in pairs(duiData) do
    DestroyDrawableDUI(textureId)
  end
end