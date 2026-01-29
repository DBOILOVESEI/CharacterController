local MAIN = script.Parent

local Errors = require(MAIN.Errors)

local build = {}

function build.HasRootPart(model:Model): boolean
	local root = model.PrimaryPart
	if root then return true end
	
	return false
end

function build.ValidateModel(model:Model): (boolean, ...any)
	assert(build.HasRootPart(model) == true, Errors.NO_ROOT_PART)

	local root = model.PrimaryPart
	
	local con = model:FindFirstChildOfClass("ControllerManager")
	if not con then warn(string.format(Errors.MISSING_X, "ControllerManager")); return false end
	
	local airController = con:FindFirstChildOfClass("AirController")
	if not airController then warn(string.format(Errors.MISSING_X, "AirController in ControllerManger.")); return false end
	local groundController = con:FindFirstChildOfClass("GroundController")
	if not groundController then warn(string.format(Errors.MISSING_X, "GroundController in ControllerManger.")); return false end
	
	return true, con, airController, groundController
end

function build.Build(model:Model)
	assert(build.HasRootPart(model) == true, Errors.NO_ROOT_PART)

	local root = model.PrimaryPart

	local con = model:FindFirstChildOfClass("ControllerManager")
	if not con then
		con = Instance.new("ControllerManager")
	end
	con.Name = "Controller"	
	
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
	
	return true, con, airController, groundController
end

return build
