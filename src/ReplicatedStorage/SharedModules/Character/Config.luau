local RunService = game:GetService("RunService")

-- / MAIN
local Config = {}

-- This is meant to be for NPCs.
-- You can change to RenderStepped
-- if you're using for client.
Config.DEFAULT_SIMULATION_TYPE = RunService.Heartbeat
Config.GROUND_MARGIN_ERROR = 0.5

return Config