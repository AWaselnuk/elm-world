module HeightMap exposing (HeightMap, Coord, build, get, set)

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
    index = toIndex heightMap coord
  in
    if (inBounds heightMap coord) then
      Array.get index heightMap.cells
    else
      Maybe.Nothing

-- Set a value at x, y and return an error if the coord is out of bounds
set : HeightMap -> Coord -> Float -> HeightMap
set heightMap coord val =
  let
    index = toIndex heightMap coord
  in
    if (inBounds heightMap coord) then
      { heightMap | cells = Array.set index val heightMap.cells }
    else
      heightMap

-- Check if coord is in bounds
inBounds : HeightMap -> Coord -> Bool
inBounds heightMap coord =
  let
    (x, y) = coord
  in
    x <= heightMap.last && y <= heightMap.last

-- Convert coord to array index
toIndex : HeightMap -> Coord -> Int
toIndex heightMap coord =
  let
    (x, y) = coord
  in
    heightMap.resolution * x + y

-- Normalize the heightmap, no value should be below 0.0 or above 1.0
-- normalize : HeightMap -> Int -> Int -> HeightMap