# Naming Rules

1. Module that contains more modules has .module suffix.</br>
1.1. This is due to the way ROJO/Argon was set up.</br>
1.2. Didn't do it to every script because I just wanted to separate the folder script and normal file script.</br>

2. All scripts must end in .luau since it's more compatible for Roblox.

# CharacterController
This one is actually quite old, I might rewrite it soon.

Learning

-Central States module containing State modules\
--A State module contains 2 methods: CheckStateAvailable() and SetState()\
--States module maps states based on priority, has a separate dictionary\
-Every Heartbeat: loops through every state (Greedy)\
--Gets state via indexing\
--CheckStateAvailable()\
--If true: SetState()\
--Time complexity: O(n) (negligible)\
There are also EnvironmentStates but I'm lazy to explain\
Updater module: custom logic
