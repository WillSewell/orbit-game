module Planet where

{-| Module for holding types to represent planets,
as well as utility functions for interacting with it. -}

import Math.Vector2 as V2
import String as S

import Util exposing (Positioned, HasImage)

{-| Represents a planet. -}
type alias Planet = HasImage (Positioned { mass : Int })

{-| String representation of a planet. -}
showPlanet : Planet -> String
showPlanet planet =
  "{ pos=" ++ (toString <| V2.toTuple planet.pos)
  ++ (S.fromList ['\n'])
  ++ ", mass=" ++ toString planet.mass ++ " }"

{-| Function for generating a new pod.
The type constructor does not work because it uses extensible records. -}
planet pos mass imgPath =
  { pos = pos
  , imgPath = imgPath
  , mass = mass
  }
