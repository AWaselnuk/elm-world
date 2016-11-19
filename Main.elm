import Html exposing (Html, div, text)

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
  div [] [ text "hello world" ]