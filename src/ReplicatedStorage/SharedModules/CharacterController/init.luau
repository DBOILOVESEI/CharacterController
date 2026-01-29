local Character = {}
Character.__index = Character

function Character.new()
    local self = {}

    

    setmetatable(self, Character)
    return self
end

return Character