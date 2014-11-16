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
step (t,dir) g = { g | pod <- g.pod |> gravityPullAll g.planets
                                    |> boost dir 
                                    |> physics t }

physics : Float -> Pod -> Pod
physics t p = { p | pos <- p.pos `V2.add` V2.scale t p.vel }

boost : { x:Int, y:Int } -> Pod -> Pod
boost { x, y } p = 
  let scaleDir x = toFloat x / 5
  in { p | vel <- p.vel `V2.add` V2.vec2 (scaleDir x) (scaleDir y) }

gravityPullAll : [Planet] -> Pod -> Pod
gravityPullAll planets p = foldl (gravityPull p) p planets

gravityPull : Pod -> Planet -> Pod -> Pod
gravityPull oldPod planet pod =
  { pod | vel <- oldPod.vel `V2.sub` (V2.direction oldPod.pos planet.pos |> V2.scale 0.01) }
              
render : (Int,Int) -> Game -> Element
render (w',h') {pod,planets} =
  let (w,h) = (toFloat w', toFloat h')
  in collage w' h' (renderPod pod :: map renderPlanet planets)

renderPod : Pod -> Form
renderPod p = square 10 |> outlined (solid (rgb 50 150 200)) 
                        |> move (V2.getX p.pos, V2.getY p.pos)

renderPlanet : Planet -> Form
renderPlanet p = circle p.mass |> outlined (solid (rgb 200 150 50))
                               |> move (V2.getX p.pos, V2.getY p.pos)

input : Signal (Float,{ x:Int, y:Int })
input = let delta = lift (\t -> t/20) (fps 24)
        in sampleOn delta (lift2 (,) delta Keyboard.arrows)

main = lift2 render Window.dimensions (foldp step defaultGame input)
  