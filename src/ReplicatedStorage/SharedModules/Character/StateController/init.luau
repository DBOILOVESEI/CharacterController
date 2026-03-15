local MAIN = script
local ROOT = MAIN.Parent

-- / MODULES
local Errors = require(MAIN.Errors)
local Types = require(ROOT.Types)

-- / TYPES
export type CharacterController = Types.Character
export type StateBase = Types.StateBase

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

-- Force enter a state
-- Instead of using StateName directly,
-- we force scripts to use StateBase
-- class for safety and also reduce map
-- search.
function StateController.EnterState(character: CharacterController, state: StateBase)
    local stateName = state.Name
    local currentState = character.CurrentState
    -- State doesn't change
    -- Run OnUpdate function (if exist)
    if currentState.Name == stateName then
        if currentState.OnUpdate then currentState.OnUpdate(character) end

        return
    end

	-- State change

	-- Set states
	character.PreviousState = character.CurrentState
	character.CurrentState = state

    -- Run OnExit function (if exist)
    if currentState.OnExit then
        currentState.OnExit(character)
    end

    -- New state
    -- Run OnEnter (if exist)
    if state.OnEnter then
        state.OnEnter(character)
    end

	character.StateChanged:Fire()
end

-- Safe enter state
function StateController.UpdateState(character: CharacterController)
    local state = StateController.GetBestState(character)
    if not state then return end

    StateController.EnterState(character, state)
end

-- / ENVIRONMENT STATES
function StateController.UpdateEnvironmentFlags(character: CharacterController)
    for _, env_state in StateController.EnvironmentStates do
        env_state.Update(character)
    end
end

-- / END
return StateController