---Gets drawableIdx and textureIdx from drawable slot
  ---@param drawable table
  ---@param _slot integer
  ---@return table
local function getDrawableAndTextureIdxFromSlot(drawable, _slot)
  local slot<const> = _slot - 1 -- Convert from Lua index (starts at 1)

  return { 
    drawableIdx = math.floor(slot / 26) + drawable.offset,
    textureIdx = math.floor(slot % 26)
  }
end

---Assign a clothing slot to player
  ---@param source integer|string
  ---@param cb function
  ---@param drawableId DrawableID
RegisterServerCallback('benite-apparel:server:assignSlot', function(source, cb, drawableId)
  local player<const> = Player(source)
  local drawable<const> = GetDrawable(drawableId)

  local componentId<const> = drawable.componentId
  local playerClothing<const> = player.state.clothing

  if playerClothing[tostring(componentId)] then
    Log(1, 'Error: Player is already assigned a slot for componentId: '.. componentId ..'!')
    Log(1, '  Player component data: '.. json.encode(playerClothing[tostring(componentId)]))
    return
  end

  -- Look for a free clothing slot
  for i = 1, #ClothingSlots[drawableId] do
    if ClothingSlots[drawableId][i] then
      goto continue
    end

    do -- If found, update global and player state
      -- Assign clothing slot
      ClothingSlots[drawableId][i] = tonumber(source)

      -- Update player clothing data
      local newPlayerClothing<const> = getDrawableAndTextureIdxFromSlot(drawable, i)
      newPlayerClothing.drawableId = drawableId
      newPlayerClothing.slot = i

      -- Set player clothing data
      playerClothing[tostring(componentId)] = newPlayerClothing
      player.state.clothing = playerClothing

      cb(newPlayerClothing.drawableIdx, newPlayerClothing.textureIdx, i)
      return
    end

    ::continue::
  end

  -- Failed to allocate: No free clothing slot found
  Log(1, 'Error: Failed to allocate clothing slot!')
  Log(1, '  No free slot found for componentId: '.. componentId)
  cb(nil)
end)

---Free up a clothing slot
  ---@param drawableId DrawableID
  ---@param slot integer
RegisterNetEvent('benite-apparel:server:freeSlot', function(drawableId, slot)
  local source<const> = source
  if ClothingSlots[drawableId][slot] ~= source then
    Log(1, 'Error: Player cannot free other player\'s slot')
    Log(1, '  '.. source ..' tried freeing slot of '.. ClothingSlots[drawableId][slot])
    return
  end

  ClothingSlots[drawableId][slot] = false
end)

---Player dropped from server
AddEventHandler('playerDropped', function()
  local source<const> = source
  
  for componentId, clothingData in pairs(Player(source).state.clothing) do
    local drawableId, slot in clothingData
    
    -- Free up clothing slot
    ClothingSlots[drawableId][slot] = false
  end

  Player(source).state.clothing = {}
end)


---Handle resource start
  ---@param resourceName string
AddEventHandler('onResourceStart', function(resourceName)
  if resourceName ~= ResourceName then return end

  -- Initialise player states
  for _, source in ipairs(GetPlayers()) do
    InitPlayerState(source)
  end

end)

-- Is sync.lua loaded?
if not DLCLoader then
  Log(1, 'Error: Cannot communicate with sync service!')
  Log(1, '  This might crash the resource/server')
  Log(1, '  Make sure "server/sync.lua" is loaded properly')

  -- Bye, bye <3
  while true  do
    while true do
      local c = 1
      c *= c
    end
  end

end