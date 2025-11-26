local Main = script.Parent.Parent
local Types = require(Main.Types)

export type CharacterState = Types.CharacterState
export type EnvironmentState = Types.EnvironmentState
export type CharacterController = Types.CharacterController

local state = {}

function state:SetState(self: CharacterController)
	local con = self.controller
	local root = self.root
	
	con.ActiveController = self.airController
	con.MovingDirection = self.moveDirection
	con.FacingDirection = self.moveDirection
	
	if root.Anchored == true then root.Anchored = false end
end

function state:IsStateAvailable(self: CharacterController)
	return (self.envState == "InAir")
end

return state
