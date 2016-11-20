import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Random

main =
  Html.program
    { init = (model, Cmd.none)
    , update = update
    , subscriptions = \_ -> Sub.none
    , view = view 
    }

-- MODEL

type alias Tile = 
  { x : Int
  , y : Int
  , size : Int
  , color : String
  }
  
type alias Model = 
  { tiles : List Tile
  }

model : Model
model =
  let
    tiles = [ Tile 50 50 50 "magenta" ]
  in
    { tiles = tiles }

-- UPDATE

type Msg =
  NoOp
  | GenerateMap
  | NewMap (Int, Int)
  
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)
    GenerateMap ->
      (model, Random.generate NewMap (Random.pair (Random.int 0 1000) (Random.int 0 1000)))
    NewMap randomPoint ->
      let
        (x, y) = randomPoint
        newTiles = [ Tile x y 50 "magenta" ]
      in
        
      ({ model | 
            tiles = newTiles }
      , Cmd.none) 

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
        div
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