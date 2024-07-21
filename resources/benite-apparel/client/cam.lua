--
-- CAMERA ANGLE CLASS
--

---Benite Apparel camera angle
---@class CameraAngle
  ---@field label string
  ---@field zoomOffset number
  ---@field zOffset number
  ---@field heading number
  ---@field gradientBone integer
  ---@field private new fun(label: string, zoomOffset?: number, zOffset?: number, heading?: number, gradientBone?: integer): self
local CameraAngle<const> = {}

---Creates new Benite Apparel camera angle
function CameraAngle.new(label, zoomOffset, zOffset, heading, gradientBone)
  local self<const> = setmetatable({}, CameraAngle) --[[@as CameraAngle]]

  self.label = label
  self.zoomOffset = zoomOffset or 0.0
  self.zOffset = zOffset or 0.0
  self.heading = heading or 0.0
  self.gradientBone = gradientBone or 0
  return self
end

--
-- SCRIPT
--

---@enum (key) CameraAngleID
local cameraAngles<const> = {
  front = CameraAngle.new(Locale.camera_angle_front, 1.0, 0.3, 90, 0)
}

---Positions a given camera in relation to a ped
  ---@param cam integer
  ---@param ped integer
  ---@param cameraAngleId CameraAngleID
  ---@return vector3
function PositionCamRelativeToPed(cam, ped, cameraAngleId)
  local cameraAngle<const> = cameraAngles[cameraAngleId] or cameraAngles.front

  local pedCoords<const> = GetEntityCoords(ped)
  local pedForwardVector<const> = GetEntityForwardVector(ped)
  local pedLeftVector<const> = vector3(-1 * pedForwardVector.y, pedForwardVector.x, pedForwardVector.z)

  local camPos<const> = pedCoords + pedForwardVector * 1.5
  local camFocusCoords<const> = pedCoords + pedLeftVector * 1.05

  local camHeight<const> = pedCoords.z + 0.3

  SetCamCoord(cam, camPos.x, camPos.y, camHeight)
  PointCamAtCoord(cam, camFocusCoords.x, camFocusCoords.y, camHeight)

  return vector3(camPos.x, camPos.y, camHeight)
end