{-| Main module that folds the step function over the input, starting from the defaultGame. -}
module Main where

import Window
import Result
import Signal (..)
import Input (Update(..), input)
import Config (defaultGame)
import Render (render)
import Step (step)
import State (Game)

{-| Load in a new game if a new game event is triggered, else perform normal step. -}
update : Update -> Game -> Game
update upd game = case upd of
  Reset (Ok g) -> { g | status <- "Level loaded" }
  Reset (Err msg) -> { game | status <- msg }
  NormalInput i -> step i game

{-| Run the game - see module doc. -}
main = map2 render Window.dimensions (foldp update defaultGame input)
