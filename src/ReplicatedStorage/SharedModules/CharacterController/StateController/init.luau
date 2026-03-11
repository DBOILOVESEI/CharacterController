local MAIN = script
local ROOT = MAIN.Parent

-- / MODULES
local Errors = require(MAIN.Errors)
local Types = require(ROOT.Types)

-- / TYPES
export type CharacterController = Types.CharacterController
export type CharacterState = Types.CharacterState

-- / MAIN
local StateController = {}
StateController.States = {}
StateController.StatesMap = {}
StateController.EnvironmentStates = {}
StateController.EnvironmentStatesMap = {}

function StateController.Init()
    StateController.LoadStates(MAIN.CharacterStates)
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
        local stateName = load.Name

        table.insert(states_list, load)
        states_map[stateName] = load
    end

    table.sort(states_list, function(a, b)
		return a.Weight > b.Weight
    end)

    StateController[stateType] = states_list
    StateController[stateTypeMap] = states_map
end

-- / CHARACTER STATES
function StateController.GetBestState(character: CharacterController)
    for _, state in StateController.States do
        local canEnter = state.CanEnter(character)
        if canEnter == false then continue end

        return state
    end
end

function StateController.EnterState(character: CharacterController, stateName: string)
    local state = StateController.StatesMap[stateName]
    if not state then
       warn(string.format(Errors.STATE_NOT_LOADED, stateName))
    end 
end

-- / ENVIRONMENT STATES
function StateController.EvaluateEnvironmentStates(character: CharacterController)
    for _, env_state in StateController.EnvironmentStates do
        env_state.EvaluateState(character)
    end
end

-- / END
return StateController