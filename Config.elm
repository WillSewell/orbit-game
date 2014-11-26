{-| Module for storing game constants. -}
module Config where

{-| Record of all game constants. -}
type Config = { boostPwrFactor:Float, gravPwrFactor:Float }

{-| Where the constants are set, and how the game retrieves them. -}
config : Config
config = { boostPwrFactor = 0.02
         , gravPwrFactor = 0.0005 }