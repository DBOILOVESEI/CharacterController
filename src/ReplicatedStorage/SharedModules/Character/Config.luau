local RunService = game:GetService("RunService")

-- / MAIN
local Config = {}

Config.TEMPLATE_MESH_SPHERE = "rbxassetid://13643721663"
Config.TEMPLATE_MESH_CYLINDER = "rbxassetid://13643721202"
Config.TEMPLATE_ROOT_SIZE = Vector3.new(2, 5, 2)

-- This is meant to be for NPCs.
-- You can change to RenderStepped
-- if you're using for client.
Config.DEFAULT_SIMULATION_TYPE = RunService.Heartbeat
Config.GROUND_MARGIN_ERROR = 1

return Config