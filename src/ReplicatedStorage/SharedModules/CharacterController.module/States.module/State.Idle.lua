local Main = script.Parent.Parent
local Types = require(Main.Types)

export type CharacterState = Types.CharacterState
export type EnvironmentState = Types.EnvironmentState
export type CharacterController = Types.CharacterController

local state = {}
state.priority = 9
state.name = "Idle"

function state:SetState(self: CharacterController)
	local root = self.root
	local con = self.controller
	
	con.ActiveController = self.groundController
	con.MovingDirection = Vector3.zero
	if root.Anchored == false then
		root.Anchored = true
	end
	self.root.CFrame = self.root.CFrame:Lerp(self.root.CFrame, 0.5)
end

function state:IsStateAvailable(self: CharacterController)
	return (self.envState == "OnGround" and self.moveDirection.Magnitude <= 0)
end

return state
