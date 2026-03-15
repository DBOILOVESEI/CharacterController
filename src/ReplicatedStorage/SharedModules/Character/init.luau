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
    table.insert(ActiveControllers, self)

    -- Controller values
    self.CurrentState = ""
    self.PreviousState = ""
    self.EnvironmentFlags = {
        -- Testing
        -- RAGDOLL = true
        
    }

    -- Instances
    self.Model = model
    self.Root = root
    self.Controller = controller

    -- Defaults
    self.DefaultControllers = {
        Ground = groundController,
        Air = airController
    }
    self.DefaultSensors = {
        Ground = groundSensor
    }

    -- Actives
    self.ActiveController = groundSensor
    self.ActiveGroundSensor = groundSensor

    -- Controllers and Sensors
    self.Controllers = {}
    self.Controllers[groundController.Name] = groundController
    self.Controllers[airController.Name] = airController

    self.Sensors = {}
    self.Sensors[groundSensor.Name] = groundSensor

    self.GroundDistance = groundController.GroundOffset+(root.Size.Y/2) + Config.GROUND_MARGIN_ERROR
    self.GroundDirection = Vector3.new(0, -self.GroundDistance, 0)
    
    -- groundSensor.SearchDistance = self.GroundDistance

    self.Filter = RaycastParams.new()
    self.Filter.FilterType = Enum.RaycastFilterType.Exclude
    self.Filter.FilterDescendantsInstances = {model}
    
    -- Finishing
    setmetatable(self, Character)
    return self
end

function Character:Update(dt: number)
    StateController.UpdateEnvironmentFlags(self)
    
    StateController.UpdateState(self)
end

function Character:Destroy()
    setmetatable(self, nil)

    local activeIndex = table.find(ActiveControllers, self)
    if activeIndex then
        table.remove(ActiveControllers, activeIndex)
    end

    for i, v in self do
        if v.Destroy then v:Destroy() end
        self[i] = nil
    end
    table.clear(self)
end

return Character