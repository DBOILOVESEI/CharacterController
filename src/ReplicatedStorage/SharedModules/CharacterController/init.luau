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

        -- TODO: Remove this
        model:PivotTo(CFrame.new(0, 50, 0)) 
        model.Parent = workspace
    else
		local modelValid = Build.IsModelValid(model)
        if modelValid == false then
            warn(Errors.MODEL_NOT_VALID)
            return
        end
    end

    local root = model.PrimaryPart
    local controller = model:FindFirstChildOfClass("ControllerManager")
    local groundController = controller:FindFirstChildOfClass("GroundController")
    local airController = controller:FindFirstChildOfClass("AirController")
    local groundSensor = root:FindFirstChildOfClass("ControllerPartSensor")

    -- Values
    local self = {}

    -- System values
    
    -- Controller values
    self.CurrentState = ""
    self.PreviousState = ""
    self.EnvironmentFlags = {}

    -- Instances
    self.Root = root
    self.Controller = controller
    self.GroundController = groundController
    self.AirController = airController
    self.GroundSensor = groundSensor

    self.HipHeight = groundSensor.SearchDistance+(root.Size.Y/2)

    self.Filter = RaycastParams.new()
    self.Filter.FilterType = Enum.RaycastFilterType.Exclude
    self.Filter.FilterDescendantsInstances = {model}
    
    -- Finishing
    setmetatable(self, CharacterController)
    return self
end

function CharacterController:Update(dt: number)
    StateController.UpdateEnvironmentFlags(self)
end

function CharacterController:Destroy()
    setmetatable(self, nil)

    local activeIndex = self.ActiveIndex
    table.remove(CharacterController.ActiveControllers, activeIndex)

    table.clear(self)
end

return CharacterController