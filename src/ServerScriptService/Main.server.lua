--!nocheck

local rs = game:GetService("ReplicatedStorage")

local SHAREDMODULES = rs.SharedModules
local Character = require(SHAREDMODULES.CharacterController)
Character.Init()
local char = Character.New()
char:Update()
