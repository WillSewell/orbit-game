module Config where

{-| Module for storing game constants. -}

import Math.Vector2 as V2

import State exposing (Game, GameState(..))

{-| Record of all game constants. -}
type alias Config = { boostPwrFactor : Float
                    , gravPwrFactor : Float
                    , levels : List String
                    , podImgPath : String
                    , maxExplosionSize : Int }

{-| Where the constants are set, and how the game retrieves them. -}
config : Config
config = { boostPwrFactor = 0.02
         , gravPwrFactor = 0.0001
         , levels = [ "worlds/1.json", "worlds/2.json" ]
         , podImgPath = "resources/images/escapepodtest_large.png"
         , maxExplosionSize = 15 }

{-| Dummy configuration used before any game file is loaded. -}
defaultGame : Game
defaultGame =
  { pod = { imgPath = config.podImgPath
          , pos = V2.vec2 0 0
          , vel = V2.vec2 0 0
          , collided = False
          , boostDir = []
          , fuel = 500 }
  , planets = []
  , state = Running
  , status = ""
  , explosionSize = config.maxExplosionSize
  , futureStates = [] }
