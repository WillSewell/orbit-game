module Pod where

import Util (Positioned)
import Math.Vector2 as V2

type Pod = Positioned { vel:V2.Vec2
                      , collided:Bool
                      , boostDir:[BoostDir]
                      , fuel:Int }

data BoostDir = U | D | L | R
