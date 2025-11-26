local states = {}
states.states = {}
states.states_map = {}

-- O(n) one time. Negligible.
local modules = script:GetChildren()
for _, module in modules do
	local load = require(module)
	load.states = states
	load.name = module.Name
	load.priority = module:GetAttribute("Priority")
	
	table.insert(states.states, load)
	states.states_map[module.Name] = load
end
table.clear(modules)
modules = nil

table.sort(states.states, function(a, b)
	return a.priority < b.priority
end)

return states
