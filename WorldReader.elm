module WorldReader where

{-| Module for requesting for world files stored in JSON format,
these are then converted into the world datatype. -}

import Http
import Json.Decode as J
import Json.Decode exposing ((:=))
import Math.Vector2 as V2
import Signal
import Signal exposing ((<~))
import Task

import Config exposing (config, defaultGame)
import Planet exposing (Planet, planet)
import Pod exposing (Pod, pod)
import State exposing (Game, GameState(..), game)

worldMailbox : Signal.Mailbox (Result String Game)
worldMailbox = Signal.mailbox (Ok defaultGame)

getLevel : Int -> Task.Task Http.Error Game
getLevel lvlNum = Http.get decoder ("worlds/" ++ (toString lvlNum) ++ ".json")

{-| Build the level URI based on a level number which may be an error. -}
genLevelRequestUri : Result String Int -> String
genLevelRequestUri lvl = (case lvl of
    Ok lvl -> toString lvl
    _ -> "1")
  |> \lvlStr -> "worlds/" ++ lvlStr ++ ".json"

{-| Take the response signal, and convert it into a Game. -}
handleResult : Http.Response -> Result String Game
handleResult { status, statusText, headers, url, value } =
  if status == 200 then
    case value of
      Http.Text s -> J.decodeString decoder s
  else
    Err ("Failed to download level. Code: "
        ++ toString status
        ++ " error: " ++ statusText)

{-| Json decoder for the level files. -}
decoder : J.Decoder Game
decoder = J.object2 game
  ("pod" :=
    J.object3
      (\xpos ypos -> pod config.podImgPath (V2.vec2 xpos ypos))
      ("xpos" := J.float)
      ("ypos" := J.float)
      ("fuel" := J.int))
  ("planets" :=
    J.list (J.object4
      (\xpos ypos -> planet (V2.vec2 xpos ypos))
      ("xpos" := J.float)
      ("ypos" := J.float)
      ("mass" := J.int)
      ("imgPath" := J.string)))
