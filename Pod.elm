{-| Module for holding types to represent the pod,
as well as utility functions for interacting with it. -}
module Pod where

import Util (Positioned)
import Math.Vector2 as V2
import String as S

{-| Represents the pod. -}
type alias Pod = Positioned { vel : V2.Vec2
                            , collided : Bool
                            , boostDir : List BoostDir
                            , fuel : Int }

{-| Represents the current boost direction. -}
type BoostDir = U | D | L | R

{-| String representation of a pod. -}
showPod : Pod -> String
showPod pod = "{ pos=" ++ (toString <| V2.toTuple pod.pos) ++ (S.fromList ['\n'])
               ++ ", vel=" ++ (toString <| V2.toTuple pod.vel) ++ (S.fromList ['\n'])
               ++ ", collided=" ++ toString pod.collided ++ (S.fromList ['\n'])
               ++ ", boostDir=" ++ toString pod.boostDir ++ (S.fromList ['\n'])
               ++ ", fuel=" ++ toString pod.fuel ++ " }"

{-| Create a new pod by specifying only the initially required fields. -}
pod : V2.Vec2 -> Int -> Pod
pod pos fuel = { pos = pos
               , vel = V2.vec2 0 0
               , collided = False
               , boostDir = []
               , fuel = fuel }
