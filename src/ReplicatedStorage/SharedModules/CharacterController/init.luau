-- / MODULES
local MAIN = script.Parent
local Config = require(MAIN.Config)
local Build = require(MAIN.Build)

-- / MAIN
local Character = {}
Character.__index = Character

function Character.init()
    Build.CreateTemplate()

    return true
end

function Character.new(model: Model)
    if not model then
        model = Build.GetTemplateModel()
    end

    local self = {}
    self.State = ""
    self.LastState = ""
    self.EnvironmentState = ""
    self.LastEnvironmentState = ""

    local CharacterConfig = table.clone(Config.CharacterConfig)

    self.Model = model
    self.Config = CharacterConfig

    setmetatable(self, Character)
    return self
end

function Character:OnUpdate()

end

return Character