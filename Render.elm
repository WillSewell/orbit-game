module Render where

import Math.Vector2 as V2
import State (Game(..))
import Pod (Pod, BoostDir(..))
import Planet (Planet)

render : (Int,Int) -> Game -> Element
render (w',h') (Game { pod, planets, explosionSize, futureStates }) =
  let (w,h) = (toFloat w', toFloat h')
  in collage w' (h' - 20) ([renderBg (w,h), renderPod pod]
                           ++ map renderPod futureStates
                           ++ map renderPlanet planets
                           ++ map (renderBoost pod) pod.boostDir
                           ++ [renderExplosion pod explosionSize])
     `below` asText ("Fuel: " ++ show pod.fuel)

renderBg : (Float,Float) -> Form
renderBg (w,h) = rect w h |> filled black

renderPod : Pod -> Form
renderPod p = square 10 |> filled blue
                        |> move ((V2.getX p.pos), V2.getY p.pos)

renderBoost : Pod -> BoostDir -> Form
renderBoost pod boostDir = 
  let oldX = V2.getX pod.pos
      oldY = V2.getY pod.pos
      offset = 10
      (newPos,rotDegrees) = case boostDir of
        U -> ((oldX, oldY - offset), 90)
        D -> ((oldX, oldY + offset), 90)
        R -> ((oldX + offset, oldY), 0)
        L -> ((oldX - offset, oldY), 0)
  in oval 20 5
    |> gradient (radial (0,0) 10 (0,10) (20) [(0, rgb 252 75 65), (1, rgba 228 199 0 0)])
    |> move newPos
    |> rotate (degrees rotDegrees)

renderPlanet : Planet -> Form
renderPlanet p = circle p.mass |> filled brown
                               |> move (V2.getX p.pos, V2.getY p.pos)

renderExplosion : Pod -> Float -> Form
renderExplosion pod exploSize = circle exploSize 
  |> gradient (radial (0,0) 10 (0,10) (exploSize) [(0, rgb 252 75 65), (1, rgba 228 199 0 0)])
  |> move (V2.getX pod.pos, V2.getY pod.pos)