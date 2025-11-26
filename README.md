# CharacterController

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
