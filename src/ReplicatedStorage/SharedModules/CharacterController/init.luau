local HapticService = game:GetService("HapticService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--[[

CharacterController, utilizing Character class.
CharacterController and Character are
essentially 2 different modules that serve
different purposes. CharacterController is
specfically for controlling Player's character
(Client sided).

]]--

-- / ROOTS
local SHARED_MODULES = ReplicatedStorage.SharedModules

-- / MODULES
local Character = require(SHARED_MODULES.Character)

-- / MAIN
local CharacterController = {}

function CharacterController.New()
    
end

return CharacterController