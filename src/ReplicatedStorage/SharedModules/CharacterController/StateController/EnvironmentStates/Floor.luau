local MAIN = script
local ROOT = MAIN.Parent.Parent.Parent

-- / MODULES
local Types = require(ROOT.Types)

local Sensor = {}
Sensor.Name = "FloorSensor"
Sensor.Weight = 0

function Sensor.Update(character)

    local result = workspace:Raycast()    
end

return Sensor