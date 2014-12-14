{-| Module containing types that represent the current state of the game.
Also contains the defaultGame (the start state). -}
module State where

import Math.Vector2 as V2
import Pod (Pod)
import Planet (Planet)

{-| Represents the current state of the game. -}
type alias Game = { pod : Pod
                  , planets : List Planet
                  , state : GameState
                  {- future states of the pod provided direction is not changed
                  used to compute the trajectory. -}
                  , explosionSize : Int
                  , futureStates : List Pod }

{-| Whether the game is running, or in another state. -}
type GameState = Running | Ended

game : Pod -> List Planet -> Game
game pod planets = Game pod planets Running 0 []
