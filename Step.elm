module Step where

import Math.Vector2 as V2
import State (Game, GameState(..), defaultGame)
import Physics (..)
import Pod (Pod, BoostDir(..))
import Planet (Planet)

step : (Float,{ x:Int, y:Int }) -> Game -> Game
step (t,dir) g = 
  let collided = isCollided g.pod g.planets
      isExploding = (g.explosionSize > 0 || collided) && g.explosionSize < 50
  in { g | pod <- updatePod g dir t
         , state <- if collided || g.pod.fuel <= 0 then Ended else Running
         , explosionSize <- g.explosionSize + if isExploding then 15 else 0 }

updatePod : Game -> { x:Int, y:Int } -> Float -> Pod
updatePod g dir t = case g.state of
  Running -> g.pod |> gravityPullAll g.planets
                   |> boost dir
                   |> physics t
                   |> updateBoostDir dir
                   |> useFuel dir
  _ -> g.pod

isCollided : Pod -> [Planet] -> Bool
isCollided pod = any (\planet -> V2.distance planet.pos pod.pos < planet.mass + 5)

updateBoostDir : { x:Int, y:Int } -> Pod -> Pod
updateBoostDir dir pod = { pod |
  boostDir <- (if dir.x == 1 then [L] else if dir.x == -1 then [R] else [])
              ++ (if dir.y == 1 then [U] else if dir.y == -1 then [D] else []) }

useFuel : { x:Int, y:Int } -> Pod -> Pod
useFuel dir pod = { pod | fuel <- pod.fuel - abs dir.x - abs dir.y }
