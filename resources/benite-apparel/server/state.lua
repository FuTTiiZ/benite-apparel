-- Generate a list of all clothing slots

---@type table<string, table<integer, integer|boolean>>
ClothingSlots = {}

---@type table<integer, boolean>
local _emptyDrawableSlots<const> = {}
for i = 1, 26 * DrawablesEach do
  _emptyDrawableSlots[i] = false
end
for drawableId, drawable in pairs(GetAllDrawables()) do
  ClothingSlots[drawableId] = _emptyDrawableSlots
end


---Initialise player state
  ---@param source integer|string
function InitPlayerState(source)
  if not Player(source).state.scope then Player(source).state.scope = {} end
  Player(source).state.clothing = {}
  Player(source).state.clothingProperties = {}
  Player(source).state.apparelReady = false
end

-- Initialise player state when joining
AddEventHandler('playerJoining', function()
  ---@type integer|string
  local source<const> = source

  InitPlayerState(source)
end)

---Handle changes in player clothing statebag
  ---@param bagName string
  ---@param key 'clothing'
  ---@param newClothing table<ComponentID, table>
AddStateBagChangeHandler('clothing', '', function(bagName, key, newClothing)
  local source<const> = GetPlayerFromStateBagName(bagName)
  if not source then return end

  ---@type table<ComponentID, table>
  local oldClothing<const> = Player(source).state?.clothing or {}

  -- Check what new clothes need to be loaded
  ---@type table<ComponentID, table>
  local clothesToLoad<const> = {}
  for componentId, clothingData in pairs(newClothing) do
    if (not oldClothing[componentId]) then
      clothesToLoad[componentId] = clothingData
    end
  end

  -- Check what new clothes need to be unloaded
  ---@type table<ComponentID, table>
  local clothesToUnload<const> = {}
  for componentId, clothingData in pairs(oldClothing) do
    if (not newClothing[componentId]) then
      clothesToUnload[componentId] = clothingData
    end
  end

  -- Unload old clothes
  TriggerScopeEvent('benite-apparel:client:unloadTextures', source, clothesToUnload, tostring(source))

  -- Update new clothing texture properties
  ---@type table<PropertyID, any>
  local propertiesToLoad<const> = {}

  ---@type table<PropertyID, boolean>
  local updatedProperties<const> = {}
  for componentId, clothingData in pairs(clothesToLoad) do
    local drawable<const> = GetDrawable(clothingData.drawableId)
    for _, propertyId in ipairs(drawable.properties) do
      if not updatedProperties[propertyId] then
        updatedProperties[propertyId] = true
        local value<const> = Player(source).state.clothingProperties[propertyId]
        if value then
          propertiesToLoad[propertyId] = value
        end
      end
    end
  end

  -- Load new clothes
  TriggerScopeEvent('benite-apparel:client:loadTextures', source, clothesToLoad, propertiesToLoad, tostring(source))
end)


---Handle changes in player clothing properties
  ---@param bagName string
  ---@param key 'clothingProperties'
  ---@param newProperties table<PropertyID, any>
AddStateBagChangeHandler('clothingProperties', '', function(bagName, key, newProperties)
  local source<const> = GetPlayerFromStateBagName(bagName)
  if not source then return end

  ---@type table<string, any>
  local oldProperties<const> = Player(source).state?.clothingProperties or {}

  -- Update changed properties
  for propertyId, value in pairs(newProperties) do
    if (oldProperties[propertyId] ~= value) then
      TriggerScopeEvent('benite-apparel:client:updateTextures', source, propertyId, value, tostring(source))
    end
  end

end)


