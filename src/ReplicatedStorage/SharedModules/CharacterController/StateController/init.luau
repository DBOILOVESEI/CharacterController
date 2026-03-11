local MAIN = script
local ROOT = MAIN.Parent

-- / MODULES
local Errors = require(MAIN.Errors)
local Types = require(ROOT.Types)

-- / TYPES
export type CharacterState = Types.CharacterState

-- / MAIN
local StateController = {}
StateController.States = {}
StateController.StatesMap = {}
StateController.EnvironmentStates = {}
StateController.EnvironmentStatesMap = {}

function StateController.Init()
    StateController.LoadStates(MAIN.States)
    StateController.LoadStates(MAIN.EnvironmentStates)   
    
end

function StateController.LoadStates(statesContainer: Folder)
    local stateType = statesContainer.Name
    local stateTypeMap = stateType.."Map"

    if StateController[stateType] or StateController[stateTypeMap] then
        warn(string.format(Errors.STATE_TYPE_ALREADY_LOADED, stateType))
    end

    local states_list = {}
    local states_map = {}
    for _, stateModule in statesContainer:GetChildren() do
        local load = require(stateModule)
        if not (load.Name and load.Weight and load.IsStateAvailable and load.SetState) then
            warn(string.format(Errors.STATE_ESSENTIAL_NOT_EXIST, stateModule.Name))
            continue
        end

        local stateName = load.Name

        table.insert(states_list, load)
        states_map[stateName] = load

        table.sort(states_list, function(a, b)
            return a.Weight > b.Weight
        end)
    end

    StateController[stateType] = states_list
    StateController[stateTypeMap] = states_map
end

-- / CHARACTER STATES
function StateController.GetBestState(character)
    for _, state in StateController.States do
        local stateAvailable = state.IsStateAvailable()
        if stateAvailable == false then continue end

        return state
    end
end

function StateController.SetState(character, stateName: string)
    local state = StateController.StatesMap[stateName]
    if not state then
       warn(string.format(Errors.STATE_NOT_LOADED, stateName))
    end    
end

-- / ENVIRONMENT STATES
function StateController.GetBestEnvironmentState(character)
    
end

return StateController