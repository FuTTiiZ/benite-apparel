---Handle resource stop
  ---@param resourceName string
AddEventHandler('onResourceStop', function(resourceName)
  if resourceName ~= ResourceName then return end
  
  ShutdownDUI()
end)

-- Player spawned
AddEventHandler('playerSpawned', function(resourceName)
  if DuiInitialized then return end
  InitDUI()
end)

-- Handle 'apparel' console command
RegisterCommand('apparel', function()
  if 
    IsPedFalling(PlayerPed) or
    GetPedParachuteState(PlayerPed) ~= -1 or
    IsPedRagdoll(PlayerPed)
  then return end

  OpenMenu()
end, false)
TriggerEvent('chat:addSuggestion', '/apparel', Locale.command_description, {})

-- Main update loop
CreateThread(function()
  while true do
    PlayerPed = PlayerPedId()

    CheckForClothingUpdates()

    Wait(0)
  end
end)