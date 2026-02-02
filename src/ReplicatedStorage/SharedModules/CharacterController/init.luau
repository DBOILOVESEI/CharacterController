-- / MODULES
local MAIN = script
local Config = require(MAIN.Config)
local Build = require(MAIN.Build)
local Types = require(MAIN.Types)

-- / Types
export type CharacterState = Types.CharacterState
export type CharacterEnvironmentState = Types.CharacterEnvironmentState

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

    -- Initial states
    local state: CharacterState = nil
    local lastState: CharacterState = nil
    local envState: CharacterEnvironmentState = nil
    local lastEnvState: CharacterEnvironmentState = nil

    local self = {}
    self.State = state
    self.LastState = lastState
    self.EnvironmentState = envState
    self.LastEnvironmentState = lastEnvState

    local CharacterConfig = table.clone(Config.CharacterConfig)

    self.Model = model
    self.Config = CharacterConfig

    setmetatable(self, Character)
    return self
end

function Character:OnUpdate()

end

return Character