local MAIN = script.Parent
local ROOT = MAIN.Parent

local StateController = {}
StateController.States = {}
StateController.StatesMap = {}

function StateController.Init()
    for _, stateModule in MAIN.States:GetChildren() do
        local load = require(stateModule)
        
    end    
end

return StateController