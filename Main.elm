{-| Main module that folds the step function over the input, starting from the defaultGame. -}
module Main where

import Keyboard
import Window
import Maybe
import Config (defaultGame)
import Render (render)
import Step (step)
import State (Game)
import WorldReader (getLevel)

{-| Represents possible update values. -}
data Update
    = Reset (Maybe Game)
    | NormalInput Input

{-| Input from the user and time delta between frames. -}
type Input = (Float, { x:Int, y:Int })

{-| input is a signal consisting of the pressed arrow keys, and the delta
- the time between frames. -}
input : Signal Input
input = let delta = lift (\t -> t/20) (fps 24)
            world = getLevel 1
        in sampleOn delta (lift2 (,) delta Keyboard.arrows)

{-| Combine the input from the user, and input from loading a new level. -}
input' : Signal Update
input' = merge (Reset <~ getLevel 1) (NormalInput <~ input)

{-| Load in a new game if a new game event is triggered, else perform normal step. -}
update' : Update -> Maybe Game -> Maybe Game
update' upd game = case upd of
  Reset (Just g) -> Just g
  Reset Nothing -> game
  NormalInput i -> Maybe.map (step i) game

{-| Run the game - see module doc. -}
main = lift2 render Window.dimensions (foldp update' (Just defaultGame) input')
