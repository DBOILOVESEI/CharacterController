-- / ROOTS
local MAIN = script
local ROOT = MAIN.Parent

-- / MODULES
local Signal = require(ROOT.Signal)

-- / TYPES

-- Other types
export type Signal = Signal.Signal

-- Controller specific types
export type CharacterController = {
    SetState: () -> (),
    StateChanged: Signal
}

export type CharacterState = {
    Name: string,
    Weight: number,
    IsStateAvailable: () -> boolean,
    SetState: () -> any
}

return {}