module Input where

{-| Types for the inputs and functions to unmarshalling the input into these
types. -}

import Char
import Http
import Keyboard
import Signal
import Signal exposing ((<~))
import String
import Task
import Time

import Config exposing (defaultGame)
import State exposing (Game)
import Util exposing (isOk)
import WorldReader exposing (worldMailbox)

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

{-| Get a number representing the numerical key pressed. -}
numKeyPressed : Signal.Signal (Result String Int)
numKeyPressed = Signal.filter isOk (Ok 1) <| String.toInt
                                          << String.fromChar
                                          << Char.fromCode
                                          <~ Keyboard.presses

{-| Combine the input from the user, and input from loading a new level. -}
input : Signal.Signal Update
input = Signal.mergeMany [ Reset <~ worldMailbox.signal
                         , NormalInput <~ controls
                         ]