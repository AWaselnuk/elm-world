module HeightMap exposing (..)

import Array exposing (Array)

-- MODEL

type alias HeightMap =
  { resolution: Int
  , exponent : Int
  , last : Int
  , cells: Array Float
  }

type alias Coord = (Int, Int)

build : Int -> HeightMap
build exponent =
  let
    resolution = 2 ^ exponent + 1
    last = resolution - 1
  in
    { resolution = resolution
    , exponent = exponent
    , last = last
    , cells = Array.repeat (resolution * resolution) 0.0
    }

-- Get a value at x, y and return a Nothing if out of bounds
get : HeightMap -> Coord -> Maybe Float
get heightMap coord =
  let
    (x, y) = coord
    index = heightMap.resolution * x + y
  in
    if (x <= heightMap.last && y<= heightMap.last) then
      Array.get index heightMap.cells
    else
      Maybe.Nothing

-- Set a value at x, y and return an error if the coord is out of bounds
-- set : HeightMap -> Coord -> Float -> Float

-- Normalize the heightmap, no value should be below 0.0 or above 1.0
-- normalize : HeightMap -> Int -> Int -> HeightMap