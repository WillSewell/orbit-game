{-| Module for holding types to represent planets,
as well as utility functions for interacting with it. -}
module Planet where

import Util (Positioned)
import Math.Vector2 as V2

{-| Represents a planet. -}
type Planet = Positioned { mass:Float }
