local Config = {}

Config.TemplateConfig = table.freeze(
    {
        TEMPLATE_NAME = "TemplateCharacter",

        ROOT_SIZE = Vector3.new(4, 2, 2), -- Cylinder
        ROOT_SHAPE = Enum.PartType.Cylinder,
        ROOT_MASSLESS = true,

        WALK_SPEED = 16,
        JUMP_HEIGHT = 5,

        GROUND_OFFSET = 1,

        GROUND_CONTROLLER_RIGIDITY_ENABLED = true,
        AIR_CONTROLLER_RIGIDITY_ENABLED = true,

        GROUND_SENSOR_UPDATE_TYPE = Enum.SensorUpdateType.Manual
    }
)

Config.RayConfig = {
    Distance = 0,
    FilterParams = nil
}

Config.CharacterConfig = {
    WALK_SPEED = 16,
    JUMP_HEIGHT = 5,

    GROUND_RAY_CONFIG = table.clone(Config.RayConfig),
    WALL_RAY_CONFIG = table.clone(Config.RayConfig),
}

return Config