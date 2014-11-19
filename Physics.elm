module Physics where

import Math.Vector2 as V2
import Pod (Pod)
import Planet (Planet)

physics : Float -> Pod -> Pod
physics t p = { p | pos <- p.pos `V2.add` V2.scale t p.vel }

boost : { x:Int, y:Int } -> Pod -> Pod
boost { x, y } p = 
  let scaleDir x = toFloat x / 5
  in { p | vel <- p.vel `V2.add` V2.vec2 (scaleDir x) (scaleDir y) }

gravityPullAll : [Planet] -> Pod -> Pod
gravityPullAll planets pod = foldl (gravityPull pod) pod planets

gravityPull : Pod -> Planet -> Pod -> Pod
gravityPull oldPod planet pod =
  { pod | vel <- pod.vel `V2.sub` (V2.direction oldPod.pos planet.pos |> V2.scale 0.01) }
