local MAIN = script
local ROOT = MAIN.Parent.Parent.Parent

-- / MODULES
local Types = require(ROOT.Types)

-- / TYPES
export type Character = Types.Character

-- / MAIN
local State = {}
State.Name = "Falling"
State.Weight = 10

function State.CanEnter(character: Character)
    local flags = character.EnvironmentFlags
    return (flags.IN_AIR == true and flags.ON_GROUND == false)
end

function State.OnEnter(character: Character)
    character.Controller.ActiveController = character.DefaultControllers.Air
end

return State