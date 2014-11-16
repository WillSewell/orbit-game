import Keyboard
import Window
import Math.Vector2 as V2

type Pod = { pos:V2.Vec2, vel:V2.Vec2 }
type Planet = { pos:V2.Vec2, mass:Float }
type Game = { pod:Pod, planets:[Planet] }

defaultGame : Game
defaultGame =
  { pod     = { pos=V2.vec2 0 0, vel=V2.vec2 0 0 }
  , planets = [ { pos=V2.vec2 50 50, mass=5 }
              , { pos=V2.vec2 -100 0, mass=10 }
              , { pos=V2.vec2 150 200, mass=15 }] }

step : (Float,{ x:Int, y:Int }) -> Game -> Game
step (t,dir) g = { g | pod <- g.pod |> boost dir |> physics t }

physics : Float -> Pod -> Pod
physics t p = { p | pos <- V2.vec2 (V2.getX p.pos + t * V2.getX p.vel)
                                   (V2.getY p.pos + t * V2.getY p.vel) }

boost : { x:Int, y:Int } -> Pod -> Pod
boost { x, y } p = { p | vel <- V2.vec2 (toFloat x) (toFloat y) }
              
render : (Int,Int) -> Game -> Element
render (w',h') {pod,planets} =
  let (w,h) = (toFloat w', toFloat h')
  in collage w' h'
    ((square 10 |> outlined (solid (rgb 50 150 200)) 
                |> move (V2.getX pod.pos, V2.getY pod.pos))
     :: map renderPlanet planets)

renderPlanet : Planet -> Form
renderPlanet p = circle p.mass |> outlined (solid (rgb 200 150 50))
                               |> move (V2.getX p.pos, V2.getY p.pos)

input : Signal (Float,{ x:Int, y:Int })
input = let delta = lift (\t -> t/20) (fps 24)
        in sampleOn delta (lift2 (,) delta Keyboard.arrows)

main = lift2 render Window.dimensions (foldp step defaultGame input)
  