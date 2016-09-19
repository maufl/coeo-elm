module View.Layout exposing (..)

import Model exposing (Model)
import Msg exposing (..)

import Html exposing (Html, h3, text)
import Material.Layout as MdlLayout
import Material.Scheme
import Material

render: Model -> (Model -> List Int -> Html Msg) -> Html Msg
render model content =
    Material.Scheme.top <|
        MdlLayout.render Mdl model.mdl
            [ MdlLayout.fixedHeader
            ]
            { header = [ h3 [] [ text "Counter"] ]
            , drawer = []
            , tabs = ([], [])
            , main = [ content model [0] ]
            }
