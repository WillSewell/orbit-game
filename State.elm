module State where

{-| Module containing types that represent the current state of the game.
Also contains the defaultGame (the start state). -}

import Math.Vector2 as V2

import Planet exposing (Planet)
import Pod exposing (Pod)

{-| Represents the current state of the game. -}
type alias Game =
  { pod : Pod
  , planets : List Planet
  , state : GameState
  , status : String
  , explosionSize : Int
  -- future states of the pod provided direction is not changed
  -- used to compute the trajectory.
  , futureStates : List Pod
  }

{-| Whether the game is running, or in another state. -}
type GameState = Running | Ended

game : Pod -> List Planet -> Game
game pod planets = Game pod planets Running "" 0 []
