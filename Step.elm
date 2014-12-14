{-| The main module for updating the state at each step of the game. -}
module Step where

import Util (iterate)
import Config (config, defaultGame)
import State (Game, GameState(..))
import Physics (..)
import Pod (Pod, BoostDir(..), showPod)
import Planet (Planet)
import List (..)
import Math.Vector2 as V2
import Debug as D

{-| The top level function that calls a different helper for each object. -}
step : (Float, { x:Int, y:Int }) -> Game -> Game
step (t,dir) g = 
  let collided = isCollided g.pod g.planets
      isExploding = (g.explosionSize > 0 || collided) && g.explosionSize < 50
  in { g | pod <- case g.state of
                    Running -> updatePod g.planets g.pod ({-D.watch "t"-} t, dir)
                    _ -> g.pod
         , state <- if collided || g.pod.fuel <= 0 then Ended else Running
         , explosionSize <- g.explosionSize + if isExploding 
                                                then config.maxExplosionSize
                                                else 0 
         , futureStates <- updateStates g.planets t g.pod 50 }

{-| Compute the future states of the pod.
Assuming there is no change in direction. -}
updateStates : List Planet -> Float -> Pod -> Int -> List Pod
updateStates planets t pod =
  iterate (\nextPod -> updatePod planets nextPod (t, { x=0,y=0 })) pod

{-| Update the pod by piping it through the various physics functions that
update its velocity, then update its position by applying the main physics
function. Finally, perform any other updates to its state. -}
updatePod : List Planet -> Pod -> (Float, { x:Int, y:Int }) -> Pod
updatePod planets pod (t, dir) = pod |> gravityPullAll planets
                                     |> boost dir
                                     |> physics t
                                     |> updateBoostDir dir
                                     |> useFuel dir

{-| Check if the pod intersects a planet. -}
isCollided : Pod -> List Planet -> Bool
isCollided pod = any (\planet -> V2.distance planet.pos pod.pos < toFloat planet.mass + 5)

{-| Set the boost direction depending on the movement arrow pressed. -}
updateBoostDir : { x:Int, y:Int } -> Pod -> Pod
updateBoostDir dir pod = { pod |
  boostDir <- (if dir.x == 1 then [L] else if dir.x == -1 then [R] else [])
              ++ (if dir.y == 1 then [U] else if dir.y == -1 then [D] else []) }

{-| If the user is boosting, decrease the fuel. -}
useFuel : { x:Int, y:Int } -> Pod -> Pod
useFuel dir pod = { pod | fuel <- pod.fuel - abs dir.x - abs dir.y }
