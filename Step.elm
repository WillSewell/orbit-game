module Step where

import Math.Vector2 as V2
import State (Game, GameState(..), defaultGame)
import Physics (..)
import Pod (Pod)
import Planet (Planet)

step : (Float,{ x:Int, y:Int }) -> Game -> Game
step (t,dir) g = 
  let collided = isCollided g.planets g.pod
  in { g | pod <- if g.state == Running 
                  then g.pod |> gravityPullAll g.planets
                                         |> boost dir 
                                         |> physics t
                  else g.pod
     , state <- if collided then Ended else Running
     , explosionSize <- g.explosionSize + if (g.explosionSize > 0 || collided) && g.explosionSize < 50 then 5 else 0 }

isCollided : [Planet] -> Pod -> Bool
isCollided planets pod = any (\planet -> V2.distance planet.pos pod.pos < planet.mass + 5) planets
