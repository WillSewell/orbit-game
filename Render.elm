{-| Module that takes a game state, and renders it. -}
module Render where

import Math.Vector2 as V2
import State (Game)
import Pod (Pod, BoostDir(..), showPod)
import Planet (Planet)

import List (..)
import Text (..)
import Graphics.Element (..)
import Graphics.Collage (..)
import Color (..)
import Debug as D

{-| The main render function that renders the state by creating a
collage in the window dimensions. -}
render : (Int, Int) -> Game -> Element
render (w', h') { pod, planets, status, futureStates, explosionSize } =
    let (w, h) = (toFloat w', toFloat h')
    --render each component with a helper function and add it to the list
    in collage w' (h' - 20) ([renderBg (w,h), renderPod pod, renderTrajectory futureStates]
                             ++ map renderPlanet planets
                             ++ map (renderBoost pod) pod.boostDir
                             ++ [renderExplosion pod explosionSize])
     -- render game stats
     `below` (asText ("Fuel: " ++ toString pod.fuel)
              `beside` asText ("         Status: " ++ status))

{-| Create a black background. -}
renderBg : (Float, Float) -> Form
renderBg (w, h) = rect w h |> filled black

{-| Render the pod. -}
renderPod : Pod -> Form
renderPod pod = image 10 10 pod.imgPath |> toForm
                                        |> move (V2.toTuple pod.pos)

{-| Create a dashed line from the future pod states that is its trajectory. -}
renderTrajectory : List Pod -> Form
renderTrajectory pods = path (map (\pod -> (V2.toTuple pod.pos)) pods)
                        |> traced (dashed (rgb 44 167 176))

{-| Render a boost a boost based on the direction.
This function should be called multiple times,
because more than one boost could fire at once. -}
renderBoost : Pod -> BoostDir -> Form
renderBoost pod boostDir = 
  let (oldX, oldY) = V2.toTuple pod.pos
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

{-| Render a planet. -}
renderPlanet : Planet -> Form
renderPlanet planet = 
  {-| scale up the mass because that represents the radius, and the planet image is a square -}
  let sideLen = toFloat planet.mass * 2.5 |> round
  in image sideLen sideLen planet.imgPath
     |> toForm
     |> move (V2.toTuple planet.pos)

{-| Render an explosion as an expanding red ball. -}
renderExplosion : Pod -> Int -> Form
renderExplosion pod exploSize = toFloat exploSize
  |> circle
  |> gradient (radial (0, 0) 10 (0, 10) (toFloat exploSize) [(0, rgb 252 75 65), (1, rgba 228 199 0 0)])
  |> move (V2.toTuple pod.pos)
