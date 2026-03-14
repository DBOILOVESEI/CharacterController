--!nocheck

local rs = game:GetService("ReplicatedStorage")

local SHAREDMODULES = rs.SharedModules
local Character = require(SHAREDMODULES.Character)
Character.Init()

for i = 32, 1, -1 do
    for j = 32, 1, -1 do
		local char = Character.New()
        char.Model:PivotTo(CFrame.new(i*6, 30, j*6))
		char:Update()
       
    end
end
