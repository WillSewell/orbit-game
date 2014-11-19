module Main where

import Keyboard
import Window
import Debug as D
import State (defaultGame)
import Render (render)
import Step (step)

input : Signal (Float,{ x:Int, y:Int })
input = let delta = lift (\t -> t/20) (fps 24)
        in sampleOn delta (lift2 (,) delta Keyboard.arrows)

main = lift2 render Window.dimensions (foldp step defaultGame input)
