local MAIN = script
local ROOT = MAIN.Parent

-- / MODULES
local Errors = require(ROOT.Errors)
local Types = require(ROOT.Types)

-- / TYPES
export type CharacterState = Types.CharacterState

-- / MAIN
local StateController = {}
StateController.__index = StateController
StateController.States = {}
StateController.StatesMap = {}

function StateController.Init()
    local states = StateController.States
    local states_map = StateController.StatesMap

    for _, stateModule in MAIN.States:GetChildren() do
        local load = require(stateModule)
        if not (load.Name and load.Weight and load.IsStateAvailable and load.SetState) then
            warn(string.format(Errors.STATE_ESSENTIALS_NOT_EXIST, stateModule.Name))
            continue
        end

        local name = load.Name

        table.insert(states, load)
        states_map[name] = load
    end

    -- Descending sort
    -- Higher weight = higher priority
    table.sort(states, function(a, b)
        return a.Weight > b.Weight
    end)
end

function StateController.New()
    local self = {}

    setmetatable(self, StateController)
    return self
end

return StateController