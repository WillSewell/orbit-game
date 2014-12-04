{-| Module containing types that represent the current state of the game.
Also contains the defaultGame (the start state). -}
module State where

import Math.Vector2 as V2
import Pod (Pod)
import Planet (Planet)

{-| Represents the current state of the game. -}
data Game = Game { pod:Pod
                 , planets:[Planet]
                 , state:GameState
                 , explosionSize:Float
                   {- future states of the pod provided direction is not changed 
                      used to compute the trejectory. -}
                 , futureStates:[Pod] }

{-| Whether the game is running, or in another state. -}
data GameState = Running | Ended

{-| The configuration of the initial game state. -}
defaultGame : Game
defaultGame = Game
  { pod = { pos=V2.vec2 0 0
          , vel=V2.vec2 0 0
          , collided=False
          , boostDir=[]
          , fuel=500 }
  , planets = []
  , state = Running
  , explosionSize = 0
  , futureStates = [] }

