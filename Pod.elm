{-| Module for holding types to represent the pod,
as well as utility functions for interacting with it. -}
module Pod where

import Util (Positioned)
import Math.Vector2 as V2

{-| Represents the pod. -}
type Pod = Positioned { vel:V2.Vec2
                      , collided:Bool
                      , boostDir:[BoostDir]
                      , fuel:Int }

{-| Represents the current boost direction. -}
data BoostDir = U | D | L | R
