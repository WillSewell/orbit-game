
{-| Module containing types that represent the current state of the game.
Also contains the defaultGame (the start state). -}
module State where

import Math.Vector2 as V2
import Pod (Pod)
import Planet (Planet)
import Http
import Signal
import Json as J
import Dict

{-| Represents the current state of the game. -}
data Game = Game { pod:Pod
                 , planets:[Planet]
                 , state:GameState
                 , explosionSize:Float
                   {- future states of the pod provided direction is not changed 
                      used to compute the trejectory. -}
                 , futureStates:[Pod] }

{-| Whether the game is running, or in another state. -}
data GameState = Running | Ended

{-| The configuration of the initial game state. -}
defaultGame : Game
defaultGame = Game
  { pod = { pos=V2.vec2 -100 0
          , vel=V2.vec2 0 0
          , collided=False
          , boostDir=[]
          , fuel=500 }
  , planets = [ { pos=V2.vec2 50 50, mass=20, imgPath="../resources/images/planet_arid.png" }
              , { pos=V2.vec2 100 0, mass=40, imgPath="../resources/images/planet_desolate.png" }
              , { pos=V2.vec2 150 200, mass=60, imgPath="../resources/images/planet_frozen.png" } ]
  , state = Running
  , explosionSize = 0
  , futureStates = [] }

{-getLevel : Int -> Signal Game
getLevel levelNum = Http.sendGet (Signal.constant <| "worlds/" ++ show levelNum ++ ".json")-}


handleResult : Http.Response String -> Maybe { pod : { pos : V2.Vec2 }}
handleResult response =
  case response of
    Http.Success string ->
      case J.fromString string of
        Just (J.Object fields) -> unpackPod fields
                                  |> (\maybepod -> case maybepod of
                                       Just pod -> Just { pod = pod }
                                       _ -> Nothing)
        _ -> Nothing
    _ -> Nothing

unpackPod fields = Dict.get "pod" fields 
                   |> (\maybepod -> case maybepod of
                        Just (J.Object pod) -> unpackPos pod
                        _ -> Nothing)
                   |> (\maybepos -> case maybepos of
                        Just pos -> Just { pos = pos }
                        _ -> Nothing)

unpackPos pod = (Dict.get "xpos" pod, Dict.get "ypos" pod) 
                |> (\fields -> case fields of
                     (Just (J.Number xpos), Just (J.Number ypos)) -> Just (V2.vec2 xpos ypos)
                     _ -> Nothing)