module View.LoginForm exposing (render)

import Html exposing (Html, div)
import Material.Textfield as Textfield

import Model exposing (Model)
import Msg exposing (..)

render : Model -> List Int -> Html Msg
render model idx =
    div []
        [ Textfield.render Mdl (idx ++ [0]) model.mdl
              [ Textfield.label "Username" ]
        , Textfield.render Mdl (idx ++ [1]) model.mdl
              [ Textfield.label "Password"
              , Textfield.password
              ]
        ]
