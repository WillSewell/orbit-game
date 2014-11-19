module Render where

import Math.Vector2 as V2
import State (Game)
import Pod (Pod)
import Planet (Planet)

render : (Int,Int) -> Game -> Element
render (w',h') {pod,planets} =
  let (w,h) = (toFloat w', toFloat h')
  in collage w' h' (renderPod pod :: map renderPlanet planets)

renderPod : Pod -> Form
renderPod p = square 10 |> outlined (solid (rgb 50 150 200)) 
                        |> move (V2.getX p.pos, V2.getY p.pos)

renderPlanet : Planet -> Form
renderPlanet p = circle p.mass |> outlined (solid (rgb 200 150 50))
                               |> move (V2.getX p.pos, V2.getY p.pos)