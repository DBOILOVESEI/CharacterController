-- / ROOTS
local MAIN = script
local ROOT = MAIN.Parent

-- / MODULES
local Signal = require(ROOT.Signal)

-- / TYPES

-- Other types
export type Signal = Signal.Signal


-- State types
-- Controller specific types
export type Character = {
    CurrentState: StateBase | nil,
    PreviousState: StateBase | nil,
    EnvironmentFlags: EnvironmentFlags,

    Model: Model,
    Root: BasePart,

    Controller: ControllerManager,
    ActiveController: ControllerBase,
    ActiveGroundSensor: ControllerPartSensor | nil,

    DefaultControllers: {[string]: ControllerBase},
    DefaultSensors: {[string]: SensorBase},

    Controllers: {[string]: ControllerBase},
    Sensors: {[string]: SensorBase},

    GroundDistance: number,
    GroundDirection: Vector3,
    Filter: RaycastParams,
    
    -- Cached results for Environment States
    CachedFloorResult: RaycastResult | nil,

    EnterState: () -> (),
    StateChanged: Signal
}

export type StateBase = {
    Name: string,
    Weight: number,
    
    CanEnter: () -> boolean,
    
    OnEnter: (Character) -> any | nil,
    OnExit: (Character) -> any | nil,
    OnUpdate: (Character) -> any | nil,
}

export type EnvironmentFlags = {
    FLOOR_MATERIAL: Enum.Material,
    IN_AIR: boolean,
    ON_GROUND: boolean

}
return {}