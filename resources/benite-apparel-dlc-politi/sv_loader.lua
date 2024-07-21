---Logs to console using cfx color codes
  ---@param colorCode integer
  ---@param message string
function Log(colorCode, message)
  if colorCode == nil then colorCode = 0 end

  print('^'.. colorCode .. message .. '^7')
end

local ResourceName<const> = GetCurrentResourceName()
if ResourceName ~= 'benite-apparel-dlc-politi' then
  Log(1, 'Error: Resource has been renamed!')
  Log(1, '  Benite Apparel WILL NOT work properly')
  Log(1, '  This resource must be named "benite-apparel-dlc-politi"')
end

GlobalState['d0df10ac050fb483ce354a0f4795114b1e221099d0e024657eab626e0ce0fe8e'] = true