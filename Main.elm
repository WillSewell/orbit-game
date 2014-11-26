{-| Main module that folds the step function over the input, starting from the defaultGame. -}
module Main where

import Keyboard
import Window
import State (defaultGame)
import Render (render)
import Step (step)

{-| input is a signal consisting of the pressed arrow keys, and the delta
- the time between frames. -}
input : Signal (Float,{ x:Int, y:Int })
input = let delta = lift (\t -> t/20) (fps 24)
        in sampleOn delta (lift2 (,) delta Keyboard.arrows)

{-| Run the game - see module doc. -}
main = lift2 render Window.dimensions (foldp step defaultGame input)
