local MAIN = script
local ROOT = MAIN.Parent.Parent.Parent

-- / MODULES
local Types = require(ROOT.Types)

-- / TYPES
export type Character = Types.Character

-- / MAIN
local Sensor = {}
Sensor.Name = "FloorSensor"
Sensor.Weight = 0

function Sensor.Update(character: Character): RaycastResult
    local env_flags = character.EnvironmentFlags

    local root = character.Root
    local activeGroundSensor = character.ActiveGroundSensor
    local groundDir = character.GroundDirection
    local filter = character.Filter
    
    local result: RaycastResult = workspace:Raycast(
        root.Position,
        groundDir,
        filter
    )

    if result then
        env_flags.IN_AIR = false
        env_flags.ON_GROUND = true
		env_flags.FLOOR_MATERIAL = result.Material
		activeGroundSensor.HitFrame = CFrame.lookAt(result.Position, result.Position + result.Normal)
		activeGroundSensor.HitNormal = result.Normal
        activeGroundSensor.SensedPart = result.Instance
    else
        env_flags.IN_AIR = true
        env_flags.ON_GROUND = false
		env_flags.FLOOR_MATERIAL = Enum.Material.Air
    end

    return result
end

return Sensor