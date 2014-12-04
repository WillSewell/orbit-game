module WorldReader where

import Math.Vector2 as V2
import State (Game(..), GameState(..))
import Pod (Pod)
import Planet (Planet)
import Http
import Signal
import Json as J
import Dict

getLevel : Int -> Signal (Maybe Game)
getLevel levelNum = Http.sendGet (Signal.constant <| "worlds/" ++ show levelNum ++ ".json")
                    |> lift handleResult

handleResult : Http.Response String -> Maybe Game
handleResult response =
  case response of
    Http.Success string ->
      case J.fromString string of
        Just (J.Object fields) -> unpackGame fields
        _ -> Nothing
    _ -> Nothing

unpackGame : Dict.Dict String J.Value -> Maybe Game
unpackGame fields = (Dict.get "pod" fields, Dict.get "planets" fields) 
                   |> (\maybefields -> case maybefields of
                        ( Just (J.Object pod)
                        , Just (J.Array  planets)) ->
                          (unpackPod pod, unpackPlanets planets) 
                          |> (\unpackResults -> case unpackResults of
                               (Just pod, Just planets) -> 
                                 Just (Game { pod = pod
                                            , planets = planets
                                            , state = Running
                                            , explosionSize = 0
                                            , futureStates = [] })
                               _ -> Nothing)
                        _ -> Nothing)

unpackPod : Dict.Dict String J.Value -> Maybe Pod
unpackPod pod = (Dict.get "xpos" pod, Dict.get "ypos" pod, Dict.get "fuel" pod) 
                |> (\fields -> case fields of
                     ( Just (J.Number xpos)
                     , Just (J.Number ypos)
                     , Just (J.Number fuel)) ->
                         Just { pos = V2.vec2 xpos ypos
                              , vel = V2.vec2 0 0
                              , collided = False
                              , boostDir = []
                              , fuel = round fuel }
                     _ -> Nothing)

unpackPlanets : [J.Value] -> Maybe [Planet]
unpackPlanets planets = foldr
  (\(J.Object planet) acc -> case acc of
    Just list -> unpackPlanet planet |> (\maybePlanet -> case maybePlanet of
      Just planet -> Just (planet :: list)
      _ -> Nothing)
    _ -> Nothing) 
  (Just []) planets

unpackPlanet : Dict.Dict String J.Value -> Maybe Planet
unpackPlanet planet = ( Dict.get "xpos" planet
                      , Dict.get "ypos" planet
                      , Dict.get "mass" planet
                      , Dict.get "imgPath" planet) 
                |> (\fields -> case fields of
                     ( Just (J.Number xpos)
                     , Just (J.Number ypos)
                     , Just (J.Number mass)
                     , Just (J.String imgPath)) ->
                         Just { pos = V2.vec2 xpos ypos
                              , mass = round mass
                              , imgPath = imgPath }
                     _ -> Nothing)
