module Util where

import Math.Vector2 as V2

type Positioned a = { a | pos:V2.Vec2 }

{-| Inspired by the iterate from Haskell:
http://hackage.haskell.org/package/base-4.7.0.1/docs/Prelude.html#v:iterate
Has to be non-lazy so there is a stopping parameter n
-}
iterate : (a -> a) -> a -> Int -> [a]
iterate f x n = case n of
  0 -> []
  _ -> x :: (iterate f (f x) (n-1))

vec2Pair : V2.Vec2 -> (Float, Float)
vec2Pair point = (V2.getX point, V2.getY point)