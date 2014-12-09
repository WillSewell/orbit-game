{-| Module that takes a game state, and renders it. -}
module Render where

import Math.Vector2 as V2
import State (Game(..))
import Pod (Pod, BoostDir(..), showPod)
import Planet (Planet)
import Util (vec2Pair)
import Debug as D

{-| The main render function that renders the state by creating a
collage in the window dimensions. -}
render : (Int, Int) -> Maybe Game -> Element
render (w', h') game = case game of
  Just (Game { pod, planets, explosionSize, futureStates }) ->
    let (w, h) = (toFloat w', toFloat h')
    {- render each component with a helper function and add it to the list -}
    in collage w' (h' - 20) ([renderBg (w,h), renderPod ({-D.watchSummary "pod" showPod-} pod), renderTrejactory ({-D.watchSummary "pods" (\pods -> show <| map showPod pods)-} futureStates)]
                             ++ map renderPlanet planets
                             ++ map (renderBoost pod) pod.boostDir
                             ++ [renderExplosion pod explosionSize])
     {- render game stats -}
     `below` asText ("Fuel: " ++ show pod.fuel)
  Nothing -> asText "ERROR"

{-| Create a black background. -}
renderBg : (Float, Float) -> Form
renderBg (w, h) = rect w h |> filled black

{-| Render the pod. -}
renderPod : Pod -> Form
renderPod pod = square 10 |> filled blue
                          |> move (vec2Pair pod.pos)

{-| Create a dashed line from the future pod states that is its trejectory. -}
renderTrejactory : [Pod] -> Form
renderTrejactory pods = path (map (\pod -> (vec2Pair pod.pos)) pods) |> traced (dashed red)

{-| Render a boost a boost based on the direction.
This function should be called multiple times,
because more than one boost could fire at once. -}
renderBoost : Pod -> BoostDir -> Form
renderBoost pod boostDir = 
  let (oldX, oldY) = vec2Pair pod.pos
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
     |> move (vec2Pair planet.pos)

{-| Render an explosion as an expanding red ball. -}
renderExplosion : Pod -> Float -> Form
renderExplosion pod exploSize = circle exploSize 
  |> gradient (radial (0, 0) 10 (0, 10) exploSize [(0, rgb 252 75 65), (1, rgba 228 199 0 0)])
  |> move (vec2Pair pod.pos)
