export type CharacterState = {
    Name: string,
    Weight: number,
    IsStateAvailable: () -> boolean,
    SetState: () -> any
}

return {}