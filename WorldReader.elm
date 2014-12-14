{-| Module for requesting for world files stored in JSON format,
these are then converted into the world datatype. -}

module WorldReader where

import Math.Vector2 as V2
import State (Game, GameState(..), game)
import Pod (Pod, pod)
import Planet (Planet, planet)
import Http
import Signal
import Json.Decode ((:=))
import Json.Decode as J
import Dict

{-| Request the level denoted by a number. Unpack the JSON file into the game datatype. -}
getLevel : Int -> Signal (Maybe Game)
getLevel levelNum =
  Http.sendGet (Signal.constant <| "worlds/" ++ toString levelNum ++ ".json")
  |> Signal.map handleResult

{-| Take the response signal, and convert it into a Game. -}
handleResult : Http.Response String -> Maybe Game
handleResult response = 
  case response of
    Http.Success string ->
      case J.decodeString decoder string of
        Ok val -> Just val
        Err _ -> Nothing
    _ -> Nothing

decoder : J.Decoder Game
decoder = J.object2 game
  ("pod" := J.object3 (\xpos ypos -> pod (V2.vec2 xpos ypos))
                      ("xpos" := J.float)
                      ("ypos" := J.float)
                      ("fuel" := J.int))
  ("planets" := J.list (J.object4 (\xpos ypos -> planet (V2.vec2 xpos ypos))
                                  ("xpos" := J.float)
                                  ("ypos" := J.float)
                                  ("mass" := J.int)
                                  ("imgPath" := J.string)))
