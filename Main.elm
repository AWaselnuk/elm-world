import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Array
import Random exposing (Generator)
import Random.Array
import Window
import Task

main =
  Html.program
    { init = (initModel, initWindowSizeCmd)
    , update = update
    , subscriptions = \_ -> Sub.none
    , view = view 
    }

initWindowSizeCmd : Cmd Msg
initWindowSizeCmd =
  Task.perform NewWindowSize Window.size

-- MODEL

type alias Tile = 
  { x : Int
  , y : Int
  , size : Int
  , color : String
  }
  
type alias Model = 
  { tiles : List Tile
  , windowSize : Window.Size
  }

initModel : Model
initModel =
  let
    tiles = []
  in
    { tiles = tiles
    , windowSize = Window.Size 0 0 
    }

-- UPDATE

type Msg =
  NoOp
  | GenerateMap
  | NewMap (List Tile)
  | NewWindowSize Window.Size
  
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)
    GenerateMap ->
      (model, Random.generate NewMap mapGenerator)
    NewMap newTiles ->
      ({ model | 
            tiles = newTiles }
      , Cmd.none) 
    NewWindowSize windowSize ->
      ({ model |
            windowSize = windowSize }
      , Cmd.none)


mapGenerator : Generator (List Tile)
mapGenerator =
  let 
    rowCount = 50
    colCount = 100
    tileSize = 30
    tileColors = Array.fromList ["red", "green", "blue"]
    defaultTileColor = "green"
    -- [(0, 0), (0, 1), (0, 2) ...]
    gridCoords =
      List.concatMap 
        (\i -> List.map2 (,) (List.repeat colCount i) (List.range 0 (rowCount - 1)))
        (List.range 0 (colCount - 1))
    tiles =
      List.map (\(x, y) -> Tile x y tileSize defaultTileColor) gridCoords
    maybeColorToTile c t = 
      { t | color = Maybe.withDefault defaultTileColor c }
  in
    Random.map
      (\colors -> List.map2 maybeColorToTile colors tiles)
      (colorsGenerator (rowCount * colCount) tileColors)
  
colorsGenerator : Int -> Array.Array a -> Generator (List (Maybe a))
colorsGenerator totalColors tileColors =
    Random.list totalColors (Random.Array.sample tileColors)
  
-- VIEW

view : Model -> Html Msg
view model =
  main_
    [ cssMain ]
    [
      styleTag 
    , div
        [ cssTileContainer ]
        (viewTileGrid model.tiles)
    , div 
        [ cssControlPanel ]
        [
          button 
            [ cssBtn
            , cssBtnGenerate
            , onClick GenerateMap
            ]
            [ text "GENERATE MAP" ]
        ]
      ]

viewTileGrid : List Tile -> List (Html Msg)
viewTileGrid tiles =
  (List.map (\tile -> viewTile tile) tiles)
  
viewTile : Tile -> Html Msg
viewTile tile =
  div [ cssTile tile ] [ ]

-- STYLES

styleTag =
  let
    styles = """
      body { overflow: hidden; }
      .elm-overlay { z-index: 9999; }
    """
  in
    node "style" [] [ text styles ]
    
cssTile tile =
  style
    [ ("position", "absolute")
    , ("backgroundColor", tile.color)
    , ("top", toString (tile.y * tile.size) ++ "px")
    , ("left", toString (tile.x * tile.size) ++ "px")
    , ("width", toString tile.size ++ "px")
    , ("height", toString tile.size ++ "px")
    ]

cssTileContainer =
  style
    [ ("position", "absolute")
    , ("top", "0")
    , ("left", "0")
    , ("width", "100vw")
    , ("height", "100vh")
    , ("z-index", "1")
    ]

cssMain : Attribute Msg
cssMain =
  style
    [ ("backgroundColor", "#eee")
    , ("position", "relative")
    , ("width", "100vw")
    , ("height", "100vh")
    ]

cssControlPanel =
  style
    [ ("position", "fixed")
    , ("bottom", "40px")
    , ("left", "50%")
    , ("transform", "translateX(-50%)")
    , ("width", "400px")
    , ("max-width", "100%")
    , ("padding", "20px")
    , ("backgroundColor", "#ccc")
    , ("display", "flex")
    , ("z-index", "100")
    ]

cssBtn =
  style 
    [ ("background", "none")
    , ("border", "none")
    ]

cssBtnGenerate =
  style
    [ ("background", "#78ecbc")
    , ("border", "1px solid black")
    , ("padding", "1em")
    , ("flex-grow", "1")
    ]