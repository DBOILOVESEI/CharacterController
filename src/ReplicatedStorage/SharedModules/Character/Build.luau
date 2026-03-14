local AssetService = game:GetService("AssetService")

-- / ROOTS
local MAIN = script
local ROOT = MAIN.Parent

-- /  MODULES
local Config = require(ROOT.Config)

-- / MAIN
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

    -- Building model
    local root = AssetService:CreateMeshPartAsync(Config.TEMPLATE_MESH_CYLINDER)

    local rootWidth = Config.TEMPLATE_ROOT_SIZE.X
    print(Config.TEMPLATE_ROOT_SIZE + Vector3.new(0, -rootWidth, 0))
    root.Size = Config.TEMPLATE_ROOT_SIZE + Vector3.new(0, -(rootWidth), 0)

    local sphere1 = AssetService:CreateMeshPartAsync(Config.TEMPLATE_MESH_SPHERE)
    sphere1.Size = Vector3.new(rootWidth, rootWidth, rootWidth)
	sphere1.Position = Vector3.new(0, root.Size.Y / 2, 0)
    sphere1.CanCollide = false
    sphere1.CanTouch = false
    sphere1.CanQuery = false
    sphere1.Parent = root

    local sphere2 = sphere1:Clone()
    sphere2.Position = Vector3.new(0, -(root.Size.Y/2), 0)
    sphere2.Size = sphere1.Size
    sphere2.Parent = root

    local weld1 = Instance.new("WeldConstraint")
    weld1.Part0 = sphere1
    weld1.Part1 = root
    weld1.Parent = sphere1

    local weld2 = weld1:Clone()
    weld2.Part0 = sphere2
    weld2.Parent = sphere2

    root.Parent = model

    -- Controller components
    local controller = Instance.new("ControllerManager")

    local groundController = Instance.new("GroundController")
    local airController = Instance.new("AirController")

    local groundSensor = Instance.new("ControllerPartSensor")

    -- Properties
    model.PrimaryPart = root

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