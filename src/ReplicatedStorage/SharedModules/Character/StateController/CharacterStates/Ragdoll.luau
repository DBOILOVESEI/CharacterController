local MAIN = script
local ROOT = MAIN.Parent.Parent.Parent

-- / MODULES
local Types = require(ROOT.Types)

-- / TYPES
export type Character = Types.Character

-- / MAIN
local State = {}
State.Name = "Ragdoll"
State.Weight = 11

function State.CanEnter(character: Character)
    local flags = character.EnvironmentFlags
    return (flags.RAGDOLL == true)
end

function State.OnEnter(character: Character)
    character.Controller.ActiveController = nil
end

return State