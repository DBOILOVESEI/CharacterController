# Character and CharacterController Class for handling Player's Character
1. Character Class
    Character class is a class that acts similarly to a state machine that handles Characters generally.\
    This class is used as is if you want to make an NPC, but client might require some work (see CharacterController).\

    It works by going through every state that was loaded and check for its condition every heartbeat. If the condition if met, the Character will enter that state.\
2. CharacterController
    CharacterController is a new class that I am planning on making. It will handle Player's Character for the client.

# CharacterController
This one is way too old at this point, I will not rewrite it soon.

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
