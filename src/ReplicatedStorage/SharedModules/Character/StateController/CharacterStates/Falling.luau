local MAIN = script
local ROOT = MAIN.Parent.Parent.Parent

-- / MODULES
local Types = require(ROOT.Types)

-- / TYPES
export type Character = Types.Character

-- / MAIN
local State = {}
State.Name = "Falling"

function State.CanEnter()
    return true
end

function State.OnEnter(character: Character)
    local controller = character.Controller
    local active 
end

return State