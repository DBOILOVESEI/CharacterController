local State = {}
State.Name = "InAir"

function State.CanEnter()
    return true
end

function State.Enter()
    print("Set state")
end

return State