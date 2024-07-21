---Gets file path for specific texture
  ---@param drawableId DrawableID
  ---@param drawableIdx integer
  ---@param textureIdx integer
  ---@return string
local function getFilePath(drawableId, drawableIdx, textureIdx)
  local drawable<const> = GetDrawable(drawableId)
  local componentId<const> = drawable.componentId
  local modelHash<const>   = drawable.modelHash

  local modelName<const> = GetPlayermodel(modelHash).name

  local componentName<const> = GetComponent(componentId).name

  local dlcOffset<const> = drawableIdx - DLCDrawableVariations.models[modelHash][componentId]
  local textureLetter<const> = string.char(97 + textureIdx)

  return modelName ..'_'.. BeniteDLCName ..'\\'.. componentName ..'_diff_'.. ('000'.. dlcOffset):sub(-3) ..'_'.. textureLetter ..'_uni'
end

---@type table<integer, table<PropertyID, string[]>>
local propertyTextures<const> = {}

---Load drawable texture
  ---@param textures table<string, table>
  ---@param properties table<PropertyID, any>
  ---@param source string
RegisterNetEvent('benite-apparel:client:loadTextures', function(textures, properties, source)
  for componentId, clothingData in pairs(textures) do
    ---@type DrawableID, integer, integer, integer
    local drawableId, drawableIdx, textureIdx, slot in clothingData

    local filePath<const> = getFilePath(drawableId, drawableIdx, textureIdx)
    local textureId<const> = drawableId ..'_'.. slot

    local drawable<const> = GetDrawable(drawableId)

    -- Add texture to property update list
    if not propertyTextures[source] then propertyTextures[source] = {} end
    for _, propertyId in ipairs(drawable.properties) do
      if not propertyTextures[source][propertyId] then propertyTextures[source][propertyId] = {} end
      table.insert(propertyTextures[source][propertyId], textureId)
    end

    -- Create DUI Browser
    -- This will also replace the filePath when loaded

    local params<const> = {
      title = textureId,
      textureId = textureId,
      drawableId = drawableId
    }

    for k,v in pairs(properties) do params[k] = v end

    if not DuiInitialized then
      DuiLoadQueue[textureId] = { drawableId, filePath, params }
    else
      CreateDrawableDUI(drawableId, filePath, params)
    end
  end
end)

---Unload drawable texture
  ---@param textures table<string, table>
  ---@param source string
RegisterNetEvent('benite-apparel:client:unloadTextures', function(textures, source)
  for componentId, clothingData in pairs(textures) do
    local drawableId, slot in clothingData
    local textureId<const> = drawableId ..'_'.. slot

    local drawable<const> = GetDrawable(drawableId)

    -- Remove texture from property update list
    for _, propertyId in ipairs(drawable.properties) do
      local newTextures<const> = {}
      for _, txtId in ipairs(propertyTextures[source][propertyId]) do
        if txtId ~= textureId then table.insert(newTextures, txtId) end
      end
      propertyTextures[source][propertyId] = newTextures
    end
    
    if not DuiInitialized then
      DuiLoadQueue[textureId] = nil
    else
      -- Destroy DUI Browser
      -- This will also remove the replaced file
      DestroyDrawableDUI(textureId)
    end
  end
end)

---Update related drawable textures
  ---@param propertyId PropertyID
  ---@param value string | number
  ---@param source string
RegisterNetEvent('benite-apparel:client:updateTextures', function(propertyId, value, source)
  for _, textureId in ipairs(propertyTextures[source][propertyId]) do
    local duiObject<const> = GetDrawableDUIObject(textureId)
    SendDuiMessage(duiObject, json.encode({
      property = propertyId,
      value = value
    }))
  end
end)