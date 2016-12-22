module HeightMap exposing (..)

import Array exposing (Array)

-- MODEL

type alias HeightMap =
  { resolution: Int
  , exponent : Int
  , last : Int
  , cells: Array Float
  }

buildMap : Int -> HeightMap
buildMap exponent =
  let
    resolution = 2 ^ exponent + 1
    last = resolution - 1
  in
    { resolution = resolution
    , exponent = exponent
    , last = last
    , cells = Array.repeat (resolution * resolution) 0.0
    }