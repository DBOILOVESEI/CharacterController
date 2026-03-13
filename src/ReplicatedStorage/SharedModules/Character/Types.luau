-- / ROOTS
local MAIN = script
local ROOT = MAIN.Parent

-- / MODULES
local Signal = require(ROOT.Signal)

-- / TYPES

-- Other types
export type Signal = Signal.Signal

-- Controller specific types
export type Character = {
    CurrentState: string,
    PreviousState: string,
    EnvironmentFlags: {[string]: boolean},

    Model: Model,
    Root: BasePart,

    Controller: ControllerManager,
    Controllers: {[string]: ControllerBase},
    Sensors: {[string]: SensorBase},

    GroundDistance: number,
    Filter: RaycastParams,

    EnterState: () -> (),
    StateChanged: Signal
}

export type CharacterState = {
    Name: string,
    Weight: number,
    CanEnter: () -> boolean,
    Enter: () -> any
}

export type EnvironmentState = {
    Name: string,
}

return {}