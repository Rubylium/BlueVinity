function EntInFrontOfPlayer(ped, distance)
  local ent = nil

  local entCoords = GetEntityCoords(ped, 1)
  local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, distance, 0.0)

  local ray = StartShapeTestRay(entCoords, offset, -1, ped, 0)
  local _, _, _, _, ent = GetRaycastResult(ray)

  return ent
end

function CoordsFromCam(distance)
  local camRot = GetGameplayCamRot(2)
  local camCoords = GetGameplayCamCoord()

  local newRotX = camRot.x * 0.0174532924
  local newRotZ = camRot.z * 0.0174532924
  local num = math.abs(math.cos(newRotZ))

  local resultCoords = vector3(camCoords.x + (-math.sin(newRotZ)) * (num + distance), camCoords.y + (math.cos(newRotZ)) * (num + distance), camCoords.z + (math.sin(newRotX) * 8.0))

  return resultCoords
end

function Target(ped, distance)
  local ent = nil

  local camCoords = GetGameplayCamCoord()
  local coords = CoordsFromCam(distance)
  
  local ray = StartShapeTestRay(camCoords, coords, -1, ped, 0)
  local _, _, _, _, ent = GetRaycastResult(ray)

  return ent, coords
end

exports('GetEntInFrontOfPlayer', EntInFrontOfPlayer)
exports('GetCoordsFromCam', CoordsFromCam)
exports('GetTarget', Target)