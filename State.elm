module State where

import Math.Vector2 as V2
import Pod (Pod)
import Planet (Planet)

data Game = Game { pod:Pod
                 , planets:[Planet]
                 , state:GameState
                 , explosionSize:Float
                 , futureStates:[Pod] }
          
data GameState = Running | Ended

defaultGame : Game
defaultGame = Game
  { pod = { pos=V2.vec2 0 0
          , vel=V2.vec2 0 0
          , collided=False
          , boostDir=[]
          , fuel=500 }
  , planets = [ { pos=V2.vec2 50 50, mass=5 }
              , { pos=V2.vec2 100 0, mass=10 }
              , { pos=V2.vec2 150 200, mass=15 } ]
  , state = Running
  , explosionSize = 0
  , futureStates = [] }