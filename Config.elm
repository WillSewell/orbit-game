module Config where

type Config = { boostPwrFactor:Float, gravPwrFactor:Float, dirFactor:Float }

config : Config
config = { boostPwrFactor = 0.02
         , gravPwrFactor = 0.0005
         , dirFactor = 0.01}