import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.App as App
import Html.Events exposing (onClick)

import Navigation
import Url exposing (..)
import Routing exposing (Route (..))
import Hop
import Hop.Types exposing (Address)

import Material
import Material.Button as Button

import View.Layout
import View.LoginForm
import Model exposing (..)
import Msg exposing (..)
import Url exposing (..)

main =
    Navigation.program urlParser { init = init
                , view = view
                , update = update
                , urlUpdate = urlUpdate
                , subscriptions = always Sub.none
                }

init : ( Route, Address ) -> ( Model, Cmd Msg )
init ( route, address ) =
    ( { model | route = route, address = address }, Cmd.none )

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
        NavigateTo path ->
            ( model, (Hop.outputFromPath hopConfig path |> Navigation.newUrl))
        SetQuery query ->
            ( model, (model.address |> Hop.setQuery query |> Hop.output hopConfig |> Navigation.newUrl))

content: Model -> List Int -> Html Msg
content model idx =
    div [ style [ ("margin", "20px auto"), ("width", "600px") ] ]
        [ Button.render Mdl (idx ++ [0]) model.mdl [ Button.onClick Decrement ] [ text "-" ]
        , div [] [ text (toString model.counter) ]
        , Button.render Mdl (idx ++ [1]) model.mdl [ Button.onClick Increment ] [ text "+" ]
        ]

view model =
    case model.route of
        Login -> View.Layout.render model View.LoginForm.render
        _ -> View.Layout.render model content

