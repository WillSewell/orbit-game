module Physics where

{-| Module with functions dealing with physics updates. -}

import List exposing (foldl)
import Math.Vector2 as V2

import Config exposing (config)
import Planet exposing (Planet)
import Pod exposing (Pod)

{-| Update the position of the pod based on velocity and position. -}
physics : Float -> Pod -> Pod
physics t pod = { pod | pos <- pod.pos `V2.add` V2.scale t pod.vel }

{-| Update the velocity in the direction the user is pressing. -}
boost : { x:Int, y:Int } -> Pod -> Pod
boost { x, y } pod = 
  let
    scaleDir x = toFloat x * config.boostPwrFactor
  in
    { pod | vel <- pod.vel `V2.add` V2.vec2 (scaleDir x) (scaleDir y) }

{-| Loop through the planets, and have them pull the pod closer. -}
gravityPullAll : List Planet -> Pod -> Pod
gravityPullAll planets pod = foldl (gravityPull pod) pod planets

{-| Pull the pod towards a planet (update velocity in that direction).
Strength of pull is based on the distance, and the mass of the planet. -}
gravityPull : Pod -> Planet -> Pod -> Pod
gravityPull oldPod planet pod =
  let
    distance = V2.distance pod.pos planet.pos
    scaleFactor =
      (1 / (distance / 150))
      * toFloat planet.mass
      * config.gravPwrFactor
    velocityModifier = V2.scale scaleFactor (V2.direction oldPod.pos planet.pos)
  in
    { pod | vel <- pod.vel `V2.sub` velocityModifier }
