module Planet where

import Util (Positioned)
import Math.Vector2 as V2

type Planet = Positioned { mass:Float }
