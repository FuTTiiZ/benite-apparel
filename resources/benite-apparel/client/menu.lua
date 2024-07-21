---@type integer | nil
local menuCam

---@type integer
local enterWeapon

local exitingMenu = false
local function menuCloseHandler()
  if not InMenu then return end
  exitingMenu = true
  InMenu = false

  SetEntityCollision(PlayerPed, true, true)
  FreezeEntityPosition(PlayerPed, false)

  DisplayHud(true)
  DisplayRadar(true)

  SetNuiFocus(false, false)

  -- Ease out of the camera
  RenderScriptCams(false, true, 1000, true, true)

  CreateThread(function() 
    Wait(1000)

    DestroyCam(menuCam --[[@as number]], true)
    menuCam = nil

    -- Give weapon back
    SetCurrentPedWeapon(PlayerPed, enterWeapon, true)

    exitingMenu = false
  end)

end

---Open Benite Apparel menu
local menuLoadTime<const> = 1000
function OpenMenu()
  if InMenu or exitingMenu then return end
  InMenu = true

  --local screenX<const>, screenY<const> = GetActiveScreenResolution()

  ---@type boolean
  local menuLoaded = false

  -- Clear ped animations
  ClearPedTasksImmediately(PlayerPed)
  ResetPedMovementClipset(PlayerPed, 0.0)
  ResetPedStrafeClipset(PlayerPed)
  ResetPedWeaponMovementClipset(PlayerPed)

  -- Freeze ped
  SetEntityCollision(PlayerPed, false, false)
  FreezeEntityPosition(PlayerPed, true)

  -- Shove away weapon
  enterWeapon = GetSelectedPedWeapon(PlayerPed)
  SetCurrentPedWeapon(PlayerPed, `WEAPON_UNARMED`, true)

  -- Setup camera
  menuCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
  local camPos<const> = PositionCamRelativeToPed(menuCam, PlayerPed, 'front')

  -- Start blur
  --TriggerScreenblurFadeIn(1000)

  -- Menu loop 
  CreateThread(function()
    Wait(1000)

    -- End blur
    --TriggerScreenblurFadeOut(1000)

    UpdateUICharacterCoords()

    -- Open UI
    StartMenuUI(menuCloseHandler)

    local startLoadTime<const> = GetGameTimer()

    ---@type number
    local loadProgress = 0

    local backgroundPos<const> = GetOffsetFromEntityInWorldCoords(PlayerPed, 0.0, --[[ Cameras.default.bgDepth or  ]]-0.7, -1.0)
    local spotlightFocus<const> = GetEntityForwardVector(PlayerPed) * -1.05
    while InMenu do
      -- Disable player controls
      DisablePlayerFiring(LocalPlayerId, true)

      -- Draw background
      ---@diagnostic disable-next-line: missing-parameter
      DrawMarker(
        43,
        backgroundPos.x, backgroundPos.y, backgroundPos.z,
        0.0, 0.0, 0.0,
        0.0, 0.0, GetCamRot(menuCam, 0).z + 180,
        10.0, 0.0, 5.0,
        2, 5, 10, math.floor(200 * loadProgress),
        false, false, 2, false
      )

      DrawSpotLight(
        camPos.x, camPos.y, camPos.z - 0.2,
        spotlightFocus.x, spotlightFocus.y, spotlightFocus.z,
        255, 255, 255,
        4.0, 2.0 * loadProgress + 0.5, 1.0,
        30.0, 10.0
      )

      UpdateUICharacterCoords()

      if menuLoaded then
        loadProgress = 1.0

        goto continue
      end

      loadProgress = (GetGameTimer() - startLoadTime) / menuLoadTime

      ::continue::
      Wait(0)
    end
  end)

  -- Ease into the camera
  RenderScriptCams(true, true, menuLoadTime, true, true)
  SetNuiFocus(true, true)

  DisplayHud(false)
  DisplayRadar(false)

  Wait(1000 + menuLoadTime)

  menuLoaded = true
end