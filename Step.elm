module Step where

import Math.Vector2 as V2
import State (Game, GameState(..), defaultGame)
import Physics (..)
import Pod (Pod)
import Planet (Planet)

step : (Float,{ x:Int, y:Int }) -> Game -> Game
step (t,dir) g = { g | pod <- if g.state == Running 
                              then g.pod |> gravityPullAll g.planets
                                         |> boost dir 
                                         |> physics t
                              else g.pod
                     , state <- if isCollided g.planets g.pod then Ended else Running }

isCollided : [Planet] -> Pod -> Bool
isCollided planets pod = any (\planet -> V2.distance planet.pos pod.pos < planet.mass + 5) planets
