{-| Types for the inputs and functions to unmarshalling the input into these types. -}
module Input where

import Keyboard
import Time
import Signal ((<~))
import Signal
import State (Game)
import WorldReader (getLevel)

{-| Represents possible update values. -}
type Update
    = Reset (Result String Game)
    | NormalInput Input

{-| Input from the user and time delta between frames. -}
type alias Input = (Float, { x : Int, y : Int })

{-| controls is a signal consisting of the pressed arrow keys, and the delta
- the time between frames. -}
controls : Signal.Signal Input
controls = let delta = Signal.map (\t -> t/20) (Time.fps 24)
           in Signal.sampleOn delta (Signal.map2 (,) delta Keyboard.arrows)

{-| Combine the input from the user, and input from loading a new level. -}
input : Signal.Signal Update
input = Signal.merge (Reset <~ getLevel 2) (NormalInput <~ controls)
