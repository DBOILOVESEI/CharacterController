local Build = {}
Build.TemplateModel = nil

function Build.Init()
    local model = Build.TemplateModel
    if model and model.Destroy then
        model:Destroy()
    end

    Build.CreateTemplate()
end

function Build.CreateTemplate()
    -- Instance
    local model = Instance.new("Model")
    local root = Instance.new("Part")

    local controller = Instance.new("ControllerManager")

    local groundController = Instance.new("GroundController")
    local airController = Instance.new("AirController")

    local groundSensor = Instance.new("ControllerPartSensor")

    -- Properties
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

    Build.TemplateModel = model
end

function Build.NewModelFromTemplate(): Model
    return Build.TemplateModel:Clone()
end

function Build.IsModelValid(model: Model): boolean
    local root = model.PrimaryPart
    if not root then return false end

    local groundSensor = root:FindFirstChildOfClass("ControllerPartSensor")
    if not groundSensor or groundSensor.SensorMode ~= Enum.SensorMode.Floor then return false end

    local controller = model:FindFirstChildOfClass("ControllerManager")
    if not controller then return false end

    local groundController = controller:FindFirstChildOfClass("GroundController")
    local airController = controller:FindFirstChildOfClass("AirController")
    if not (groundController and airController) then return false end

    return true
end

return Build