---@type table<integer, boolean>
local verifiedModels<const> = {}

---@type table<integer, boolean>
local checkedModels<const> = {}

---Verify if player's model is compatible with benite-apparel
  ---@param playermodelHash PlayermodelHash
function VerifyPlayermodel(playermodelHash)
  -- Have we already checked this model?
  if checkedModels[playermodelHash] then return end

  -- We're not using a compatible model
  local modelDrawableVariations<const> = DLCDrawableVariations?.models[playermodelHash]
  if modelDrawableVariations == nil then return end

  Log(4, 'Verifying playermodel: '.. (GetPlayermodel(playermodelHash)?.name or playermodelHash))

  -- If everything is set up correctly, the benite_apparel
  -- DLC is loaded before any other clothing resource.
  -- We're checking the first two drawables of every component
  -- to "verify" if the resource is indeed loaded correctly.
  local err = false
  for i = 0, 11 do
    if
      GetNumberOfPedTextureVariations(PlayerPed, i, modelDrawableVariations[i]) == 22 and
      GetNumberOfPedTextureVariations(PlayerPed, i, modelDrawableVariations[i] + 1) == 23 
    then
      goto continue
      Log(2, i ..' > Success')
    end

    Log(1, '  '.. i ..' > Failed')

    err = true
    break

    ::continue::
  end

  checkedModels[playermodelHash] = true

  if err then
    Log(3, 'Warning: This server has not configured their resources correctly!')
    Log(3, '  Benite Apparel must be loaded before any other clothing resources')
    Log(3, '  Please contact a server administrator to resolve the issue')
    return
  end

  verifiedModels[playermodelHash] = true

  Log(2, '  Verification successful!')
end

---Check if the specified model has been verified
  ---@param playermodelHash PlayermodelHash
  ---@return boolean
function IsPlayermodelVerified(playermodelHash)
  return not not verifiedModels[playermodelHash]
end