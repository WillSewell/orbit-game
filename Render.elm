module Render where

import Math.Vector2 as V2
import State (Game)
import Pod (Pod)
import Planet (Planet)

render : (Int,Int) -> Game -> Element
render (w',h') {pod,planets,explosionSize} =
  let (w,h) = (toFloat w', toFloat h')
  in collage w' h' ([renderBg (w,h), renderPod pod]
                    ++ map renderPlanet planets
                    ++ [renderExplosion pod explosionSize])

renderBg : (Float,Float) -> Form
renderBg (w,h) = rect w h |> filled black

renderPod : Pod -> Form
renderPod p = square 10 |> outlined (solid (rgb 50 150 200)) 
                        |> move (V2.getX p.pos, V2.getY p.pos)

renderPlanet : Planet -> Form
renderPlanet p = circle p.mass |> outlined (solid (rgb 200 150 50))
                               |> move (V2.getX p.pos, V2.getY p.pos)

renderExplosion : Pod -> Float -> Form
renderExplosion pod exploSize = circle exploSize 
  |> gradient (radial (0,0) 10 (0,10) (exploSize) [(0, rgb 252 75 65), (1, rgba 228 199 0 0)])
  |> move (V2.getX pod.pos, V2.getY pod.pos)