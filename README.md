# CharacterController

Learning

-Central States module containing State modules\n
--A State module contains 2 methods: CheckStateAvailable() and SetState()\n
--States module maps states based on priority, has a separate dictionary\n
-Every Heartbeat: loops through every state (Greedy)\n
--Gets state via indexing\n
--CheckStateAvailable()\n
--If true: SetState()\n
--Time complexity: O(n) (negligible)\n
There are also EnvironmentStates but I'm lazy to explain\n
Updater module: custom logic
