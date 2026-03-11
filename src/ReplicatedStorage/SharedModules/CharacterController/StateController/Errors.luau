local Errors = {}

Errors.STATE_ESSENTIAL_NOT_EXIST = "State module %s is missing key items. Module will be skipped."
Errors.STATE_NOT_LOADED = "State %s is not loaded. Please check StateController.States and StateController.StatesMap."
Errors.STATE_TYPE_ALREADY_LOADED = "State type %s has already been loaded. Reloading."

return Errors