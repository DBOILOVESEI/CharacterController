-- / MODULES
local MAIN = script.Parent
local Errors = require(MAIN.Errors)
local Config = require(MAIN.Config)

local TemplateConfig = Config.TemplateConfig

-- / MAIN
local Build = {}

function Build.GetBaseTemplateModel()
    local model = script:FindFirstChild(TemplateConfig.TEMPLATE_NAME)
    if not model then
        Build.CreateTemplate()
        model = script:FindFirstChild(TemplateConfig.TEMPLATE_NAME)
    end
    
    return model
end

function Build.GetNewTemplateModel()
    return Build.GetTemplateModel():Clone()
end

function Build.CreateTemplate()
    if Build.GetTemplateModel() then
        warn("Template already exists.")
        return
    end

    -- Model
    local model = Instance.new("Model")
    model.Name = TemplateConfig.TEMPLATE_NAME
    
    local root = Instance.new("Part")
    root.Size = TemplateConfig.ROOT_SIZE
    root.Shape = TemplateConfig.ROOT_SHAPE
    root.Name = "Root"
    root.Parent = model

    root.Massless = TemplateConfig.ROOT_MASSLESS

    -- Controller
    local controller = Instance.new("ControllerManager")
    controller.Name = "Controller"
    controller.Parent = model

    local groundController = Instance.new("GroundController")
    groundController.Name = "Ground"
    groundController.BalanceRigidityEnabled = TemplateConfig.GROUND_CONTROLLER_RIGIDITY_ENABLED
    groundController.Parent = controller

    local airController = Instance.new("AirController")
    airController.Name = "Air"
    airController.BalanceRigidityEnabled = TemplateConfig.AIR_CONTROLLER_RIGIDITY_ENABLED
    airController.Parent = controller

    -- Sensor
    local groundSensor = Instance.new("ControllerPartSensor")
    groundSensor.Name = "GroundSensor"
    groundSensor.SensorMode = TemplateConfig.GROUND_SENSOR_UPDATE_TYPE
    groundSensor.Parent = root

    model.PrimaryPart = root
    model.Parent = script

    return model
end

return Build
