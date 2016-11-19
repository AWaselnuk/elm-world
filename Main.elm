import Html exposing (..)
import Html.Attributes exposing (..)

main =
  Html.beginnerProgram 
    { model = model 
    , update = update
    , view = view 
    }

-- MODEL

type alias Model = {}

model : Model
model =
  {}

-- UPDATE

type Msg = NoOp

update : Msg -> Model -> Model
update msg model =
  case msg of
    NoOp ->
      model

-- VIEW

view : Model -> Html Msg
view model =
  main_
    [ cssMain ]
    [ 
      div 
        [ cssControlPanel ]
        [
          button 
            [ cssBtn, cssBtnGenerate ]
            [ text "GENERATE MAP" ]
        ]
    ]

-- STYLES

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