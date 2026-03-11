-- / ROOTS
local MAIN = script

-- / MODULES
local Signal = require(MAIN.Signal)
local StateController = require(MAIN.StateController)
local Config = require(MAIN.Config)

-- / MAIN
local CharacterController = {}
CharacterController.__index = CharacterController

-- Private
-- I don't name it "active_controllers"
-- because it is a global variable.
-- Only to make it look nice.
local ActiveControllers = {}

-- Public
function CharacterController.Init()
    StateController.Init()

    Config.DEFAULT_SIMULATION_TYPE:Connect(function(dt: number)
        for i = #ActiveControllers, 1, -1 do
            local controller = ActiveControllers[i]
            controller:Update(dt)
        end
    end)
end

function CharacterController.New()
    local self = {}
    self.CurrentState = ""
    self.PreviousState = ""

    table.insert(ActiveControllers, self)
    
    setmetatable(self, CharacterController)
    return self
end

function CharacterController:Update(dt: number)
   print(self.CurrentState)
end

return CharacterController