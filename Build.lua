local build = {}

function build.HasRootPart(model:Model)
	local root = model.PrimaryPart
	if not root then warn("Model is missing RootPart. Set the model's PrimaryPart to a BasePart to continue.") return false end
end

function build.ValidateModel(model:Model)
	if build.HasRootPart(model) == false then return false end
	local root = model.PrimaryPart
	
	local con = model:FindFirstChildOfClass("ControllerManager")
	if not con then warn("Model is missing ControllerManager.") return false end
	local groundSensor = root:FindFirstChildOfClass("ControllerPartSensor")
	if not groundSensor then warn("Model is missing GroundSensor in RootPart.") return false end
	
	local airController = con:FindFirstChildOfClass("AirController")
	if not airController then warn("Model is missing AirController in ControllerManger.") return false end
	local groundController = con:FindFirstChildOfClass("GroundController")
	if not groundController then warn("Model is missing GroundController in ControllerManger.") return false end
	
	return true, con, groundSensor, airController, groundController
end

function build.Build(model:Model)
	if build.HasRootPart(model) == false then return false end
	local root = model.PrimaryPart

	local con = model:FindFirstChildOfClass("ControllerManager")
	if not con then
		con = Instance.new("ControllerManager")
	end
	con.Name = "Controller"	

	local groundSensor = root:FindFirstChildOfClass("ControllerPartSensor")
	if not groundSensor then
		groundSensor = Instance.new("ControllerPartSensor")
	end
	groundSensor.Name = "GroundSensor"
	
	local airController = root:FindFirstChildOfClass("AirController")
	if not airController then
		airController = Instance.new("AirController")
	end
	airController.Name = "Air"
	
	local groundController = root:FindFirstChildOfClass("GroundController")
	if not groundController then
		groundController = Instance.new("GroundController")
	end
	groundController.Name = "Ground"
	
	airController.Parent = con
	groundController.Parent = con
	
	con.RootPart = root
	con.ActiveController = groundController
	con.Parent = model
	groundSensor.Parent = root
	
	return con, groundSensor, airController, groundController
end

return build
