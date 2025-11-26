--!nocheck

--
--
--

--
-- SERVICES
--

local rs = game:GetService("RunService")

--
-- LIBRARIES
--

local MAIN = script
local States = require(MAIN.States)
local Build = require(MAIN.Build)
local Types = require(MAIN.Types)
local Updater = require(MAIN.Updater)

--
-- TYPES
--

export type CharacterController = Types.CharacterController
export type CharacterState = Types.CharacterState
export type EnvironmentState = Types.EnvironmentState
export type UpdaterController = Types.UpdaterController

--
-- MAIN
--

local Character = {}
Character.__index = Character

function Character.new(model:Model): CharacterController
	assert(model, "Invalid model.")
	
	local isModelValid, con, groundSensor, airController, groundController = Build.ValidateModel(model)
	if isModelValid == false then
		warn("Model is missing items. Building model.")
		con, groundSensor, airController, groundController = Build.Build(model)
		warn("Finished building model.")
	end
	
	local self: CharacterController = {}

	--
	-- INSTANCES
	--
	
	self.root = model.PrimaryPart
	
	self.controller = con
	self.groundSensor = groundSensor
	self.airController = airController
	self.groundController = groundController
	
	--
	-- PRIVATE
	--
	
	self.state = ""
	self.prevState = ""
	self.envState = ""
	self.prevEnvState = ""
	
	self.moveDirection = Vector3.zero
	
	--
	-- CONFIG
	--
	
	local filter = {model}
	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.FilterDescendantsInstances = filter
	rayParams.CollisionGroup = "Default"
	rayParams.RespectCanCollide = true
	
	self.RAY_FILTER_LIST = filter
	self.RAY_FILTER = rayParams
	self.RAY_DIRECTION_OFFSET = (self.root.Size.X)

	self._updater = Updater.new(self)
	
	--
	-- END
	--
	
	setmetatable(self, Character)
	return self
end

--
-- GET SET
--

-- STATE

function Character:SetState(stateName: CharacterState)
	-- CHECK FIRST
	-- SET LATER
	-- If you want to check for state availability, check self.state instead of self.prevState.
	
	local state = States.states_map[stateName]
	if not state then warn(`Failed to find state "{stateName}."`) return end
	
	if self.state ~= stateName then self.prevState = self.state end
	
	self.state = stateName
	state:SetState(self)
end

function Character:GetState(): CharacterState
	return self.state
end

function Character:GetPreviousState(): CharacterState
	return self.prevState
end

-- ENVIRONMENT STATE

function Character:SetEnvironmentState(state: EnvironmentState)
	if self.envState ~= state then self.prevEnvState = self.envState end

	self.envState = state
end

function Character:GetEnvironmentState(): EnvironmentState
	return self.envState
end

function Character:GetPreviousEnvironmentState(): EnvironmentState
	return self.prevEnvState
end

-- HIP HEIGHT

function Character:SetHipHeight(hipHeight: number)
	local activeController = self.controller.ActiveController
	if not (activeController and activeController:IsA("GroundController")) then activeController = self.groundController end
	
	activeController.GroundOffset = hipHeight
end

function Character:GetHipHeight(): number
	-- There might be more than one GroundController in the Character.
	-- (Used for different purposes that I haven't thought of yet.)
	-- The active one will be checked first.
	
	local activeController = self.controller.ActiveController
	if not (activeController and activeController:IsA("GroundController")) then activeController = self.groundController end
	
	return activeController.GroundOffset
end

--
-- DETERMINE
--

function Character:DetermineState(): CharacterState
	local last = self.state
	if last ~= "" and States.states_map[last]:IsStateAvailable(self) then
		return last
	end
	
	-- Worst case: O(n)
	for _, state in States.states do
		if state:IsStateAvailable(self) == false then continue end
		
		return state.name
	end
	
	-- Return lowest priority as a fail-safe.
	return States.states[#States.states].name
end

function Character:DetermineEnvironmentState(): EnvironmentState
	--[[
	local result = workspace:Raycast(
		self.root.Position,
		self.RAY_DIRECTION,
		self.RAY_FILTER
	)
	]]
	local result = self.groundSensor.SensedPart
	
	if not result then return "InAir" end
	
	return "OnGround"
end

--
-- EDIT
--

function Character:UpdateRayFilter()
	local rayParams = self.RAY_PARAMS
	rayParams:AddToFilter(self.RAY_FILTER)
end

function Character:AddToRayFilter(item: any)
	table.insert(self.RAY_FILTER_LIST, item)
	
	self:UpdateRayFilter()
end

function Character:RemoveFromRayFilter(item: any)
	local itemIndex = table.find(self.RAY_FILTER_LIST)
	if not itemIndex then return end
	
	table.remove(self.RAY_FILTER_LIST, itemIndex)

	self:UpdateRayFilter()
end

function Character:WallInDirection(dir:Vector3): boolean
	if not dir then dir = self.root.CFrame.LookVector end
	-- OPTIMIZATION 2: Use Raycast instead of Spherecast (much faster)
	local result = workspace:Raycast(
		self.root.Position,
		dir*self.RAY_DIRECTION_OFFSET,
		self.RAY_FILTER
	)

	if result then
		return true
	end

	return false
end

--
-- MAIN
--

function Character:Move(dir: Vector3)
	self.moveDirection = dir
end

function Character:Update()
	local updater: UpdaterController = self._updater
	if not updater then return end
	--if updater and typeof(updater._connection) == "RBXScriptConnection" then warn("Updating already enabled.") return end
	
	updater:Connect()
end

function Character:StopUpdate()
	local updater: UpdaterController = self._updater
	if not updater then return end
	
	updater:Disconnect()
end

return Character
