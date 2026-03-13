-- / ROOTS
local MAIN = script

-- / MODULES
local Signal = require(MAIN.Signal)
local StateController = require(MAIN.StateController)
local Config = require(MAIN.Config)
local Build = require(MAIN.Build)
local Errors = require(MAIN.Errors)

-- / MAIN
local Character = {}
Character.__index = Character

-- Private
-- I don't name it "active_controllers"
-- because it is a global variable.
-- Only to make it look nice.
local ActiveControllers = {}
local ActiveSimulation: RBXScriptConnection

-- Public
function Character.Init()
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

function Character.New(model: Model)
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
    Character.ActiveControllers[model] = self

    -- Controller values
    self.CurrentState = ""
    self.PreviousState = ""
    self.EnvironmentFlags = {}

    -- Instances
    self.Model = model
    self.Root = root
    self.Controller = controller

    self.Controllers = {}
    self.Controllers[groundController.Name] = groundController
    self.Controller[airController.Name] = airController

    self.Sensors = {}
    self.Sensors[groundSensor.Name] = groundSensor

    self.GroundDistance = groundSensor.SearchDistance+(root.Size.Y/2)

    self.Filter = RaycastParams.new()
    self.Filter.FilterType = Enum.RaycastFilterType.Exclude
    self.Filter.FilterDescendantsInstances = {model}
    
    -- Finishing
    setmetatable(self, Character)
    return self
end

function Character:Update(dt: number)
    StateController.UpdateEnvironmentFlags(self)
end

function Character:Destroy()
    setmetatable(self, nil)

    Character.ActiveControllers[self.Model] = nil

    table.clear(self)
end

return Character