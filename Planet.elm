{-| Module for holding types to represent planets,
as well as utility functions for interacting with it. -}
module Planet where

import Util (Positioned, HasImage, vec2Pair)
import Math.Vector2 as V2
import String as S

{-| Represents a planet. -}
type Planet = HasImage (Positioned { mass:Int })

{-| String representation of a planet. -}
showPlanet : Planet -> String
showPlanet planet = "{ pos=" ++ (show <| vec2Pair planet.pos) ++ (S.fromList ['\n'])
                    ++ ", mass=" ++ show planet.mass ++ " }"
