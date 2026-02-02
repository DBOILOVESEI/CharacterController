--!strict

local Types = {}

export type CharacterState = nil | "Fall" | "Land" | "Idle" | "Move"
export type CharacterEnvironmentState = nil | "InAir" | "OnGround"

return Types