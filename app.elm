import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.App as App
import Html.Events exposing (onClick)

import Navigation
import Url exposing (..)

import Material
import Material.Button as Button

import View.Layout
import View.LoginForm
import Model exposing (..)
import Msg exposing (..)

main =
    Navigation.program urlParser { init = init
                , view = view
                , update = update
                , urlUpdate = urlUpdate
                , subscriptions = always Sub.none
                }

init : Result String Int -> (Model, Cmd Msg)
init result =
    urlUpdate result model

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    let (newModel, cmd) =
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
    in
        (newModel, Cmd.batch [cmd, Navigation.newUrl (toUrl newModel)])

content: Model -> List Int -> Html Msg
content model idx =
    div [ style [ ("margin", "20px auto"), ("width", "600px") ] ]
        [ Button.render Mdl (idx ++ [0]) model.mdl [ Button.onClick Decrement ] [ text "-" ]
        , div [] [ text (toString model.counter) ]
        , Button.render Mdl (idx ++ [1]) model.mdl [ Button.onClick Increment ] [ text "+" ]
        ]

view model =
    View.Layout.render model content

