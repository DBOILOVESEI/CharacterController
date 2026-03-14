local MAIN = script
local ROOT = MAIN.Parent.Parent.Parent

-- / MODULES
local Types = require(ROOT.Types)

-- / TYPES
export type Character = Types.Character

-- / MAIN
local State = {}
State.Name = "Idle"
State.Weight = 9

function State.CanEnter(character: Character)
    local flags = character.EnvironmentFlags
    return (flags.IN_AIR == false and flags.ON_GROUND == true)
end

function State.OnEnter(character: Character)
    character.Controller.ActiveController = character.DefaultControllers.Ground
end

return State