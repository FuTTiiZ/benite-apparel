---Sends NUI evnt to react app
---@param action string
---@param data? table
local function sendReactMessage(action, data)
  SendNUIMessage({
    action = action,
    data = data or {}
  })
end

---@type function | nil
local menuCloseHandler

---Show menu UI
---@param closeHandler function
function StartMenuUI(closeHandler)
  menuCloseHandler = closeHandler

  -- Init UI data
  local data<const> = {
    categories = {},
    articles = {},
    clothing = {},
    characterRotation = GetEntityHeading(PlayerPed),
    locale = Locale
  }

  -- Construct clothing articles data
  local drawables<const> = {}
  local allDrawables<const> = GetAllDrawables()

  local highestIndex<const> = {}

  for drawableId, drawable in pairs(allDrawables) do
    if not drawables[drawable.componentId] then drawables[drawable.componentId] = {} end

    if not highestIndex[drawable.componentId] then
      highestIndex[drawable.componentId] = drawable.idx
    else
      if drawable.idx > highestIndex[drawable.componentId] then
        highestIndex[drawable.componentId] = drawable.idx
      end
    end

    drawables[drawable.componentId][drawable.idx] = drawable
    drawables[drawable.componentId][drawable.idx].drawableId = drawableId
  end

  for i = 0, 11 do
    if not drawables[i] then
      goto continue
    end

    for j = 0, highestIndex[i] do
      local drawable<const> = drawables[i][j]
      if not drawable then
        goto continue
      end

      table.insert(data.articles, {
        id = (drawable --[[@as table]]).drawableId,
        label = drawable.label,
        componentId = drawable.componentId,
        properties = drawable.properties
      })

      ::continue::
    end

    ::continue::
  end

  -- Construct clothing categories data
  local components<const> = GetAllComponents()
  for i = 0, 11 do
    if not components[i] then
      goto continue
    end

    if not drawables[i] then
      goto continue
    end

    local component<const> = components[i]
    table.insert(data.categories, {
      id = i,
      name = component.name,
      label = component.label
    })

    ::continue::
  end

  -- Construct current clothing data
  for componentId, clothingData in pairs(LocalPlayer.state.clothing) do
    data.clothing[componentId] = clothingData.drawableId
  end

  sendReactMessage('openMenu', data)
end

function UpdateUICharacterCoords()
  local playerCoords<const> = GetEntityCoords(PlayerPed)
  local onScreen<const>, screenX<const>, screenY<const> = GetScreenCoordFromWorldCoord(playerCoords.x, playerCoords.y, playerCoords.z)
  sendReactMessage('setCharacterCoords', {
    coords = {
      x = screenX,
      y = screenY
    }
  })
end

---@type integer
local lastApplyTime = GetGameTimer()

---Apply drawable from menu
---@param data table
RegisterNUICallback('applyDrawable', function(data, cb)
  if not InMenu then return end

  -- Prevent spam
  local applyTime<const> = GetGameTimer()
  if applyTime - lastApplyTime < 500 then return end
  lastApplyTime = applyTime

  if not data.id then return end
  ApplyDrawable(data.id)

  cb({})
end)

RegisterNUICallback('closeMenu', function(data, cb)
  if not InMenu then return end

  if not menuCloseHandler then return end
  menuCloseHandler()
  menuCloseHandler = nil

  cb({})
end)

RegisterNUICallback('setCharacterRotation', function(data, cb)
  if not InMenu then
    cb({}) -- Stops error spamming in console
    return
  end
  
  SetEntityHeading(PlayerPed, data.heading + 0.0 or 0.0)

  cb({})
end)

RegisterNUICallback('setPropertyValue', function(data, cb)
  if not InMenu then return end
  
  local currentClothingProperties<const> = LocalPlayer.state.clothingProperties
  currentClothingProperties[data.id] = data.value

  LocalPlayer.state:set('clothingProperties', currentClothingProperties, true)

  cb({})
end)