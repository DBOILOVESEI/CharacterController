local Main = script.Parent.Parent
local Types = require(Main.Types)

export type CharacterState = Types.CharacterState
export type EnvironmentState = Types.EnvironmentState
export type CharacterController = Types.CharacterController

local state = {}
state.priority = 8
state.name = "Land"

function state:SetState(self: CharacterController)
	local root = self.root
	local con = self.controller

	con.ActiveController = self.groundController
	if root.Anchored == true then root.Anchored = false end
end

function state:IsStateAvailable(self: CharacterController)
	return (self.envState == "OnGround" and self.state == "Fall")
end

return state
