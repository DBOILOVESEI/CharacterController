local MAIN = script
local ROOT = MAIN.Parent

-- / MODULES
local Errors = require(MAIN.Errors)
local Types = require(ROOT.Types)

-- / TYPES
export type CharacterController = Types.Character
export type CharacterState = Types.CharacterState

-- / MAIN
local StateController = {}

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
    for _, state in StateController.CharacterStates do
        local canEnter = state.CanEnter(character)
        if canEnter == false then continue end

        return state
    end
	return StateController.States[#StateController.States]
end

function StateController.EnterState(character: CharacterController, stateName: string)
	local state = StateController.CharacterStatesMap[stateName]
    if not state then return end 

    if character.CurrentState == stateName then return end

    local oldState = StateController.CharacterStatesMap[character.CurrentState]
    if oldState and oldState.OnExit then
        oldState.OnExit(character)
    end

    character.PreviousState = character.CurrentState
    character.CurrentState = stateName
    
    state.OnEnter(character)
end

function StateController.UpdateState(character: CharacterController)
    StateController.EnterState(character, StateController.GetBestState(character).Name)
end

-- / ENVIRONMENT STATES
function StateController.UpdateEnvironmentFlags(character: CharacterController)
    for _, env_state in StateController.EnvironmentStates do
        env_state.Update(character)
    end
end

-- / END
return StateController