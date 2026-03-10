-- / ROOTS
local MAIN = script

-- / MODULES
local Signal = require(MAIN.Signal)

-- / MAIN
local CharacterController = {}
CharacterController.__index = CharacterController

function CharacterController.New()
    local self = {}

    setmetatable(self, CharacterController)
    return self
end

return CharacterController