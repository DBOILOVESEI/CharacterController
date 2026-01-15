local States = {}
States.states = {}
States.states_map = {}

-- O(n) one time.
local modules = script:GetChildren()
for _, module in modules do
	local load = require(module)
	local name = load.name

	load.states = States
	
	table.insert(States.states, load)
	States.states_map[name] = load
end
table.clear(modules)
modules = nil

table.sort(States.states, function(a, b)
	return a.priority < b.priority
end)

return States
