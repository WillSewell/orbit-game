{-| Module for storing game constants. -}
module Config where

import State (Game, GameState(..))
import Math.Vector2 as V2

{-| Record of all game constants. -}
type alias Config = { boostPwrFactor : Float
                    , gravPwrFactor : Float
                    , levels : List String 
                    , maxExplosionSize : Int }

{-| Where the constants are set, and how the game retrieves them. -}
config : Config
config = { boostPwrFactor = 0.02
         , gravPwrFactor = 0.0001
         , levels = [ "worlds/1.json", "worlds/2.json" ] 
         , maxExplosionSize = 15 }

{-| Dummy configuration used before any game file is loaded. -}
defaultGame : Game
defaultGame =
  { pod = { pos=V2.vec2 0 0
          , vel=V2.vec2 0 0
          , collided=False
          , boostDir=[]
          , fuel=500 }
  , planets = []
  , state = Running
  , status = ""
  , explosionSize = config.maxExplosionSize
  , futureStates = [] }
