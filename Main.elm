module Main (main) where

{-| Main module that folds the step function over the input, starting from the
defaultGame. 

@docs main

-}

import Graphics.Element exposing (..)
import Http
import Window
import Result
import Signal
import Signal exposing ((<~), (~))
import Task

import Config exposing (defaultGame)
import Input exposing (Update(..), input, numKeyPressed)
import Render exposing (renderGame)
import State exposing (Game)
import Step exposing (step)
import Util exposing (flipResult)
import WorldReader exposing (decoder, getLevel, worldMailbox)

{-| Request the level denoted by a number. It's a signal transformer that takes
a keypress, and if it's numerical, loads the level -- otherwise defaults to
level 1. Level is loaded by unpacking the JSON file into the game datatype. -}
port runGetLevel : Signal (Task.Task Http.Error ())
port runGetLevel =
  Signal.map
    (\lvl -> flipResult (Result.map getLevel lvl)
             `Task.andThen` Signal.send worldMailbox.address)
    numKeyPressed

{-| Load in a new game if a new game event is triggered, else perform normal
step. -}
update : Update -> Game -> Game
update update state = case update of
  Reset (Ok g) -> { g | status <- "Level loaded" }
  NormalInput i -> step i state

render : (Int, Int) -> Game -> Element
render dimensions state = renderGame dimensions state

{-| Run the game. -}
main : Signal Element
main = render <~ Window.dimensions ~ Signal.foldp update defaultGame input
