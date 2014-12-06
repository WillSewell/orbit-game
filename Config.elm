{-| Module for storing game constants. -}
module Config where

{-| Record of all game constants. -}
type Config = { boostPwrFactor:Float, gravPwrFactor:Float }

{-| Where the constants are set, and how the game retrieves them. -}
config : Config
config = { boostPwrFactor = 0.02
         , gravPwrFactor = 0.0001 }

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
