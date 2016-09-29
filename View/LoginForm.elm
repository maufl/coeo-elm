module View.LoginForm exposing (render)

import Fosp.Connection as FospConnection

import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Material.Textfield as Textfield
import Material.Button as Button

import Model exposing (Model)
import Msg exposing (..)

render : Model -> List Int -> Html Msg
render model idx =
    div [ style [("margin", "20px auto"), ("width", "300px")] ]
        [ div []
              [ Textfield.render Mdl (idx ++ [0]) model.mdl
                    [ Textfield.label "Username"
                    , Textfield.onInput (\x -> FospMsg (FospConnection.UpdateUsername x))
                    ]
              ]
        , div []
            [ Textfield.render Mdl (idx ++ [1]) model.mdl
                  [ Textfield.label "Password"
                  , Textfield.password
                  , Textfield.onInput (\x -> FospMsg (FospConnection.UpdatePassword x))
                  ]
            ]
        , div []
            [ Button.render Mdl (idx ++ [2]) model.mdl
                  [ Button.onClick (FospMsg FospConnection.SignIn)
                  , Button.raised
                  , Button.colored
                  ]
                  [ text "Login" ]
            ]
        ]
