module Step where

import Util (iterate)
import State (Game(..), GameState(..), defaultGame)
import Physics (..)
import Pod (Pod, BoostDir(..))
import Planet (Planet)
import Math.Vector2 as V2

step : (Float, { x:Int, y:Int }) -> Game -> Game
step (t,dir) (Game g) = 
  let collided = isCollided g.pod g.planets
      isExploding = (g.explosionSize > 0 || collided) && g.explosionSize < 50
  in Game { g | pod <- case g.state of
                          Running -> updatePod g.planets g.pod (t, dir)
                          _ -> g.pod
              , state <- if collided || g.pod.fuel <= 0 then Ended else Running
              , explosionSize <- g.explosionSize + if isExploding then 15 else 0 
              , futureStates <- updateStates g.planets t g.pod 10 }

updateStates : [Planet] -> Float -> Pod -> Int -> [Pod]
updateStates planets t pod =
  iterate (\nextPod -> updatePod planets nextPod (t*20, { x=0,y=0 })) pod

updatePod : [Planet] -> Pod -> (Float, { x:Int, y:Int }) -> Pod
updatePod planets pod (t, dir) = pod |> gravityPullAll planets
                                     |> boost dir
                                     |> physics t
                                     |> updateBoostDir dir
                                     |> useFuel dir

isCollided : Pod -> [Planet] -> Bool
isCollided pod = any (\planet -> V2.distance planet.pos pod.pos < planet.mass + 5)

updateBoostDir : { x:Int, y:Int } -> Pod -> Pod
updateBoostDir dir pod = { pod |
  boostDir <- (if dir.x == 1 then [L] else if dir.x == -1 then [R] else [])
              ++ (if dir.y == 1 then [U] else if dir.y == -1 then [D] else []) }

useFuel : { x:Int, y:Int } -> Pod -> Pod
useFuel dir pod = { pod | fuel <- pod.fuel - abs dir.x - abs dir.y }
