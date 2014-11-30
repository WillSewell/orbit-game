{-| Module for holding types to represent the pod,
as well as utility functions for interacting with it. -}
module Pod where

import Util (Positioned, vec2Pair)
import Math.Vector2 as V2
import String as S

{-| Represents the pod. -}
type Pod = Positioned { vel:V2.Vec2
                      , collided:Bool
                      , boostDir:[BoostDir]
                      , fuel:Int }

{-| Represents the current boost direction. -}
data BoostDir = U | D | L | R

{-| String representation of a pod. -}
showPod : Pod -> String
showPod pod = "{ pos=" ++ (show <| vec2Pair pod.pos) ++ (S.fromList ['\n'])
               ++ ", vel=" ++ (show <| vec2Pair pod.vel) ++ (S.fromList ['\n'])
               ++ ", collided=" ++ show pod.collided ++ (S.fromList ['\n'])
               ++ ", boostDir=" ++ show pod.boostDir ++ (S.fromList ['\n'])
               ++ ", fuel=" ++ show pod.fuel ++ " }"