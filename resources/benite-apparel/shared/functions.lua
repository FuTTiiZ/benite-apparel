ResourceName = GetCurrentResourceName()
local verbose<const> = (GetResourceMetadata(ResourceName, 'verbose', 0) or 'no') == 'yes'

---Logs to console using cfx color codes
  ---@param colorCode integer
  ---@param message string
function Log(colorCode, message)
  if not verbose then return end

  if colorCode == nil then colorCode = 0 end

  print('^'.. colorCode .. message .. '^7')
end