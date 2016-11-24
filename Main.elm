import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Random exposing (Generator)
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
      (model, Random.generate NewMap tilesGenerator)
    NewMap newTiles ->
      ({ model | 
            tiles = newTiles }
      , Cmd.none) 
    NewWindowSize windowSize ->
      ({ model |
            windowSize = windowSize }
      , Cmd.none)

tilesGenerator : Generator (List Tile)
tilesGenerator =
  Random.list 100 tileGenerator

-- Tile generator turns a more primitive generator into a Tile.
-- Next step is to use Array.sample to produce different tile colors.
tileGenerator : Generator Tile
tileGenerator =
  Random.map (\(x, y) -> Tile x y 50 "green") (Random.pair (Random.int 0 1000) (Random.int 0 1000))
  
-- VIEW

view : Model -> Html Msg
view model =
  let 
    viewTile tile =
      div [ cssTile tile ] [ ]
  in
    main_
      [ cssMain ]
      [
        styleTag 
      , div
          [ cssTileContainer ]
          (List.map (\tile -> viewTile tile) model.tiles)
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

-- STYLES

styleTag =
  let
    styles = "body { overflow: hidden; }"
  in
    node "style" [] [ text styles ]
    
cssTile tile =
  style
    [ ("position", "absolute")
    , ("backgroundColor", tile.color)
    , ("top", toString tile.y ++ "px")
    , ("left", toString tile.x ++ "px")
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