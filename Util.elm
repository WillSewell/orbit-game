module Util where

{- A place for generic utility functions and types.
Tend to be extentions to libraries, and could eventually
be factored out into the related library (and I could send
PRs. -}

import List exposing ((::))
import Math.Vector2 as V2
import Task

{- Used to give a type a position field.
Useful for any object in the game world. -}
type alias Positioned a = { a | pos : V2.Vec2 }

{- Records with an image. -}
type alias HasImage a = { a | imgPath : String }

{- Inspired by the iterate from Haskell:
http://hackage.haskell.org/package/base-4.7.0.1/docs/Prelude.html#v:iterate
Has to be non-lazy so there is a stopping parameter n -}
iterate : (a -> a) -> a -> Int -> List a
iterate f x n = case n of
  0 -> []
  _ -> x :: (iterate f (f x) (n-1))

{- Check if a Result type is Ok. -}
isOk : Result error value -> Bool
isOk res = case res of
  Ok _ -> True
  Err _ -> False

{-| Pull a task out of a result. -}
flipResult : Result e (Task.Task x a) -> (Task.Task x (Result e a))
flipResult res = case res of
  Ok t -> Task.map Ok t
  Err e -> Task.succeed (Err e)