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
    EnvironmentFlags: EnvironmentFlags,

    Model: Model,
    Root: BasePart,

    Controller: ControllerManager,

    Controllers: {[string]: ControllerBase},
    ActiveController: ControllerBase,

    Sensors: {[string]: SensorBase},
    ActiveGroundSensor: ControllerPartSensor | nil,

    GroundDistance: number,
    GroundDirection: Vector3,
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

export type EnvironmentFlags = {
    FLOOR_MATERIAL: Enum.Material,
    IN_AIR: boolean,
    ON_GROUND: boolean

}
return {}