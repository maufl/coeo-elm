import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.App as App
import Html.Events exposing (onClick)

import Material
import Material.Button as Button

import View.Layout
import View.LoginForm
import Model exposing (..)
import Msg exposing (..)

main =
    App.program { init = ( model, Cmd.none )
                , view = view
                , update = update
                , subscriptions = always Sub.none
                }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Increment ->
            ({ model | counter = model.counter + 1 }
            , Cmd.none
            )
        Decrement ->
            ({ model | counter = model.counter - 1}
            , Cmd.none
            )
        Mdl msg' ->
            Material.update msg' model

content: Model -> List Int -> Html Msg
content model idx =
    div [ style [ ("margin", "20px auto"), ("width", "600px") ] ]
        [ Button.render Mdl (idx ++ [0]) model.mdl [ Button.onClick Decrement ] [ text "-" ]
        , div [] [ text (toString model.counter) ]
        , Button.render Mdl (idx ++ [1]) model.mdl [ Button.onClick Increment ] [ text "+" ]
        ]

view model =
    View.Layout.render model View.LoginForm.render

