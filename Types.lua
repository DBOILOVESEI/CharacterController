export type CharacterState = "" | "Walk" | "Fall" | "Land"

export type EnvironmentState = "" | "OnGround" | "InAir" | "InWater" | "Submerged"

export type CharacterController = {
	root: BasePart?,

	controller: ControllerManager,
	groundSensor: ControllerPartSensor,
	airController: AirController,
	groundController: GroundController,

	--
	-- PRIVATE
	--

	state: CharacterState,
	prevState: CharacterState,
	envState: EnvironmentState,
	prevEnvState: EnvironmentState,
	
	moveDirection: Vector3,
	
	--
	-- FUNCTIONS
	--
	
	new: (model:Model) -> CharacterController,
	
	SetState: (stateName: CharacterState) -> (),
	GetState: () -> CharacterState,
	GetPreviousState: () -> CharacterState,
	
	SetEnvironmentState: (state: EnvironmentState) -> (),
	GetEnvironmentState: () -> EnvironmentState,
	GetPreviousEnvironmentState: () -> EnvironmentState,
	
	SetHipHeight: (hipHeight: number) -> (),
	GetHipHeight: () -> number,
	
	DetermineState: () -> CharacterState,
	DetermineEnvironmentState: () -> EnvironmentState,
	
	UpdateRayFilter: () -> (),
	AddToRayFilter: (item: any) -> (),
	RemoveFromRayFilter: (item: any) -> (),
	
	WallInDirection: (dir: Vector3) -> boolean,
	Move: (dir: Vector3) -> (),
	
	Update: () -> (),
	StopUpdate: () -> (),
}

export type UpdaterController = {
	new: (character: CharacterController, customSignal: RBXScriptSignal?, customFunction: () -> ()?) -> UpdaterController,
	
	--
	-- PRIVATE
	--
	
	_connection: RBXScriptConnection | nil,
	_function: () -> (),
	_signal: RBXScriptSignal,
	_character: CharacterController,
	
	--
	-- FUNCTIONS
	--
	
	Connect: () -> (),
	Disconnect: () -> (),
	
	SetFunction: (func: () -> ()?) -> (),
	GetFunction: () -> (() -> ());
	
	SetSignal: (signal: RBXScriptSignal?) -> (),
	GetSignal: () -> RBXScriptSignal,
}

return {}
