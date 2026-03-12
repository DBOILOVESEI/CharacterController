-- / ROOTS
local MAIN = script

-- / MODULES
local Signal = require(MAIN.Signal)
local StateController = require(MAIN.StateController)
local Config = require(MAIN.Config)
local Build = require(MAIN.Build)
local Errors = require(MAIN.Errors)

-- / MAIN
local CharacterController = {}
CharacterController.__index = CharacterController

-- Private
-- I don't name it "active_controllers"
-- because it is a global variable.
-- Only to make it look nice.
local ActiveControllers = {}
local ActiveSimulation: RBXScriptConnection

-- Public
function CharacterController.Init()
    StateController.Init()
    Build.Init()

    if ActiveSimulation then ActiveSimulation:Disconnect() end

    ActiveSimulation = Config.DEFAULT_SIMULATION_TYPE:Connect(function(dt: number)
        for i = #ActiveControllers, 1, -1 do
            local controller = ActiveControllers[i]
            controller:Update(dt)
        end
    end)
end

function CharacterController.New(model: Model)
    if not model then
        model = Build.NewModelFromTemplate()
    else
		local modelValid = Build.IsModelValid(model)
        if modelValid == false then
            warn(Errors.MODEL_NOT_VALID)
            return
        end
    end

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