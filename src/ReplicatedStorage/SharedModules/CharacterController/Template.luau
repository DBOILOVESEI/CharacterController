local Template = {}
Template.TemplateModel = nil

function Template.Init()
    local model = Template.TemplateModel
    if model then return end
end

function Template.CreateTemplate()
    -- Instance
    local model = Instance.new("Model")
    local root = Instance.new("Part")

    local controller = Instance.new("ControllerManager")

    local groundController = Instance.new("GroundController")
    local airController = Instance.new("AirController")

    local groundSensor = Instance.new("ControllerPartSensor")

    -- Values
    model.PrimaryPart = root

    root.Size = Vector3.new(2, 4, 2)

    controller.RootPart = root
    controller.ActiveController = groundController
    controller.GroundSensor = groundSensor

    groundController.BalanceRigidityEnabled = true
    airController.BalanceRigidityEnabled = true
    
    groundSensor.UpdateType = Enum.SensorUpdateType.Manual
    
    -- Parents
    root.Parent = model

    controller.Parent = model

    groundController.Parent = controller
    airController.Parent = controller

    groundSensor.Parent = root

    model.Parent = nil

    Template.TemplateModel = model
end

return Template