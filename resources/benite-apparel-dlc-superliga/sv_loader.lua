---Logs to console using cfx color codes
  ---@param colorCode integer
  ---@param message string
function Log(colorCode, message)
  if colorCode == nil then colorCode = 0 end

  print('^'.. colorCode .. message .. '^7')
end

local ResourceName<const> = GetCurrentResourceName()
if ResourceName ~= 'benite-apparel-dlc-superliga' then
  Log(1, 'Error: Resource has been renamed!')
  Log(1, '  Benite Apparel WILL NOT work properly')
  Log(1, '  This resource must be named "benite-apparel-dlc-superliga"')
end

GlobalState['85be8c2872ffab21b9aa0bccdb72880eccf654ba00cde3ab161fb32a81da9a70'] = true