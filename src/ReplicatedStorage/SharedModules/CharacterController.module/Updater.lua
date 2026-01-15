--!nocheck

--
-- SERVICES
--
local rs = game:GetService("RunService")

--
-- LIBRARIES
--
local MAIN = script.Parent
local Types = require(MAIN.Types)

--
-- TYPES
--

export type UpdaterController = Types.UpdaterController
export type CharacterController = Types.CharacterController
export type EnvironmentState = Types.EnvironmentState
export type CharacterState  = Types.CharacterState

--
-- MAIN
--

local Updater = {}
Updater.__index = Updater

local start = workspace.Start

function Updater.new(character: CharacterController, customSignal: RBXScriptSignal?, customFunction: (dt: number) -> ()?)
	if not character then warn("Missing CharacterController in argument 1."); return end
	
	local self = {}
	
	self._character = character
	
	self._frameCheckFrequency = 10
	self._framesSkipped = 0
	
	if customFunction then
		self._function = customFunction
	else
		--
		-- DEFAULT
		--
		self._function = function(dt)
			local character = self._character
			if not character then return end

			local con = character.controller

			local diff = (start.Position - character.root.Position)
			local flatDir = Vector3.new(diff.X, 0, diff.Z).Unit
			local dir = flatDir.Magnitude > 0 and flatDir.Unit or Vector3.zero

			character:SetEnvironmentState(character:DetermineEnvironmentState())
			character:SetState(character:DetermineState())
			
			self._framesSkipped += 1
			if self._framesSkipped >= self._frameCheckFrequency then
				local facingWall = character:WallInDirection(dir)
				if facingWall then
					character:Move(Vector3.zero)
				else
					character:Move(dir)
				end
				
				self._framesSkipped = 0
			end
		end
	end
	
	if customSignal then
		self._signal = customSignal
	else
		--
		-- DEFAULT
		--
		self._signal = rs.Heartbeat	
	end
	
	setmetatable(self, Updater)
	return self
end

function Updater:SetFunction(func: () -> ())
	-- Automatically update the Update Function.
	
	if typeof(func) ~= "function" then warn("Provided argument is not a function.") return end
	
	self._function = func
	self:Connect()
end

function Updater:SetSignal(signal: RBXScriptSignal)
	-- Automatically update the Update Signal.
	
	if typeof(signal) ~= "RBXScriptSignal" then warn("Provided argument is not an RBXScriptSignal.") return end
	
	self._signal = signal
	self:Connect()
end

function Updater:GetFunction()
	return self._function
end

function Updater:GetSignal()
	return self._signal
end

function Updater:Connect()
	local conn = self._connection
	if conn then conn:Disconnect() end
	
	local signal = self._signal
	local func = self._function
	if not (signal and func) or not (typeof(signal) == "RBXScriptSignal" and typeof(func) == "function") then warn("Couldn't find Signal or Function to connect.") return end
	
	self._connection = signal:Connect(func)
end

function Updater:Disconnect()
	local conn = self._connection
	if conn and typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
	
	self._connection = nil
end

return Updater
