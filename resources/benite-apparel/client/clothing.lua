---Send request to free server slot, and clear component state
  ---@param componentId ComponentID
  ---@param drawableId DrawableID
  ---@param slot number
local function unapplyDrawable(componentId, drawableId, slot)
  -- Free clothing slot
  TriggerServerEvent('benite-apparel:server:freeSlot', drawableId, slot)

  -- Clear player clothing data
  ---@type table<integer, table>
  local playerClothing<const> = LocalPlayer.state.clothing

  playerClothing[tostring(componentId)] = nil
  LocalPlayer.state:set('clothing', playerClothing, true)
end

---Apply drawable and send server slot requset
  ---@param drawableId DrawableID
function ApplyDrawable(drawableId)
  if not IsPlayermodelVerified(GetEntityModel(PlayerPed) --[[@as PlayermodelHash]]) then
    Log(1, 'Error: Cannot request clothing slot!')
    Log(1, '  Current playermodel could not be verified')
    return
  end

  local drawable<const> = GetDrawable(drawableId)
  local componentId<const> = drawable.componentId
  
  -- Unapply current if already wearing clothing for component
  local componentClothing<const> = LocalPlayer.state.clothing[tostring(componentId)]
  if componentClothing then
    if componentClothing.drawableId == drawableId then return end -- Return out of function if it's the same

    unapplyDrawable(componentId, componentClothing.drawableId, componentClothing.slot)
  end

  ---Callback from slot assignment request
  ---@param drawableIdx integer
  ---@param textureIdx integer
  ---@param slot integer
  TriggerServerCallback('benite-apparel:server:assignSlot', function(drawableIdx, textureIdx, slot)
    if not drawableIdx or not textureIdx then return end

    Log(4, 'Drawable changed!')
    Log(4, '  Applied Drawable: { '.. componentId .. ', '.. drawableId ..' }')

    -- Set appropriate arms, if available
    if drawable.arms then
      SetPedComponentVariation(PlayerPed, 3, drawable.arms, 0, 2)
    end

    SetPedComponentVariation(PlayerPed, componentId, drawableIdx, textureIdx, 2)
  end, drawableId)
end

---@type PlayermodelHash
local lastPlayermodel

---Check for changes in player's model, drawable and texture
function CheckForClothingUpdates()
  local playermodel<const> = GetEntityModel(PlayerPed) --[[@as PlayermodelHash]]
  if playermodel ~= lastPlayermodel then
    lastPlayermodel = playermodel
    VerifyPlayermodel(playermodel)
  end

  ---@type table<string, table>
  local playerClothing<const> = LocalPlayer.state.clothing
  for sComponentId, data in pairs(playerClothing) do
    local componentId<const> = tonumber(sComponentId)--[[@as ComponentID]]

    ---@type DrawableID, integer, integer, integer
    local drawableId, slot, drawableIdx, textureIdx in data

    local currentDrawableIdx<const> = GetPedDrawableVariation(PlayerPed, componentId)
    if currentDrawableIdx ~= drawableIdx then
      unapplyDrawable(componentId, drawableId, slot)

      Log(4, 'Drawable changed!')
      Log(4, '  Unapplied Drawable: { '.. componentId .. ', '.. drawableId ..' }')
      goto continue
    end

    local currentTextureIdx<const> = GetPedTextureVariation(PlayerPed, componentId)
    if currentTextureIdx ~= textureIdx then
      unapplyDrawable(componentId, drawableId, slot)

      Log(4, 'Texture changed!')
      Log(4, '  Unapplied Drawable: { '.. componentId .. ', '.. drawableId ..' }')
      goto continue
    end

    ::continue::
  end
end