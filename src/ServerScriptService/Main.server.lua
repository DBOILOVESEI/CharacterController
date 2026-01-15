--!nocheck

local rs = game:GetService("ReplicatedStorage")

local SHAREDMODULES = rs.SharedModules
local Character = require(SHAREDMODULES["CharacterController.module"])

local characters = workspace.Characters:GetChildren()
for _, model in characters do
    local char = Character.new(model)
    char:Update()
end
