{-| Module for holding types to represent planets,
as well as utility functions for interacting with it. -}
module Planet where

import Util (Positioned, HasImage, vec2Pair)
import Math.Vector2 as V2
import String as S

{-| Represents a planet. -}
type alias Planet = HasImage (Positioned { mass : Int })

{-| String representation of a planet. -}
showPlanet : Planet -> String
showPlanet planet = "{ pos=" ++ (toString <| vec2Pair planet.pos)
                    ++ (S.fromList ['\n'])
                    ++ ", mass=" ++ toString planet.mass ++ " }"

planet pos mass imgPath = { pos = pos
                         , imgPath = imgPath
                         , mass = mass }
