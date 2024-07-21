---Logs to console using cfx color codes
  ---@param colorCode integer
  ---@param message string
function Log(colorCode, message)
  if colorCode == nil then colorCode = 0 end

  print('^'.. colorCode .. message .. '^7')
end

local ResourceName<const> = GetCurrentResourceName()
if ResourceName ~= 'benite-apparel-dlc-custom' then
  Log(1, 'Error: Resource has been renamed!')
  Log(1, '  Benite Apparel WILL NOT work properly')
  Log(1, '  This resource must be named "benite-apparel-dlc-custom"')
end

GlobalState['10442980a9ce7142a7247ee243e638c4235c46dfa546f547be17f5cb8d298fd7'] = true