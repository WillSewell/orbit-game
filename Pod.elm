module Pod where

import Math.Vector2 as V2

type Pod = { pos:V2.Vec2
           , vel:V2.Vec2
           , collided:Bool
           , boostDir:[BoostDir]
           , fuel:Int }

data BoostDir = U | D | L | R