-- / MODULES
local MAIN = script.Parent
local Errors = require(MAIN.Errors)
local Config = require(MAIN.Config)

local TemplateConfig = Config.TemplateConfig

-- / MAIN
local Build = {}

function Build.CreateTemplate()
    if script:FindFirstChild(TemplateConfig.TEMPLATE_NAME) then
        warn("Template already exists.")
        return
    end
    local model = Instance.new("Model")
    model.Name = "TemplateCharacter"
    
    local root = Instance.new("Part")
    root.Name = "Root"
    root.Parent = model

    root.CustomPhysicalProperties = TemplateConfig.PHYSICAL_PROPERTIES
end

return Build
