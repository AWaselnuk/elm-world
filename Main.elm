import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Array exposing (Array)
import Random exposing (Generator)
import Random.Array
import HeightMap exposing (HeightMap, Coord)
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

type alias Color = String

type alias Model =
  { heightMap : HeightMap
  , windowSize : Window.Size
  }

initModel : Model
initModel =
  { heightMap = HeightMap.build 10
  , windowSize = Window.Size 0 0
  }

-- UPDATE

type Msg =
  NoOp
  | GenerateMap
  | NewMap HeightMap
  | NewWindowSize Window.Size

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)
    GenerateMap ->
      (model, Random.generate NewMap heightMapGenerator)
    NewMap newHeightMap ->
      ({ model |
            heightMap = newHeightMap }
      , Cmd.none)
    NewWindowSize windowSize ->
      ({ model |
            windowSize = windowSize }
      , Cmd.none)


heightMapGenerator : Generator HeightMap
heightMapGenerator =
  let
    heightMap = HeightMap.build 10
  in
    Random.map
      (\heights -> { heightMap | cells = heights })
      (heightsGenerator <| Array.length heightMap.cells)

heightsGenerator : Int -> Generator (Array Float)
heightsGenerator length =
  Random.Array.array length heightGenerator

heightGenerator : Generator Float
heightGenerator =
  Random.float 0 1

defaultTileColor : Color
defaultTileColor = "#87A96B"

-- VIEW

view : Model -> Html Msg
view model =
  main_
    [ cssMain ]
    [
      styleTag
    , (viewMap model.heightMap)
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

viewMap : HeightMap -> Html Msg
viewMap heightMap =
  let
    viewCell cell =
      div [ cssCell ] [ text <| toString cell ]
  in
    div
      [ cssCellContainer ]
      (Array.toList <| Array.map (\cell -> viewCell cell) heightMap.cells)

-- STYLES

styleTag =
  let
    styles = """
      body { overflow: hidden; }
      .elm-overlay { z-index: 9999; }
    """
  in
    node "style" [] [ text styles ]

cssCell =
  style
    [ ("width", "50px")
    , ("height", "50px")
    ]

cssCellContainer =
  style [ ]

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