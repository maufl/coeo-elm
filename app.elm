import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.App as App
import Html.Events exposing (onClick)

import String

import Navigation
import Url exposing (..)
import Routing exposing (Route (..))
import Hop
import Hop.Types exposing (Address)
import WebSocket
import Debug exposing (log)

import Material
import Material.Button as Button

import View.Layout
import View.LoginForm
import Model exposing (..)
import Msg exposing (..)
import Url exposing (..)
import Fosp.Connection as FospConnection

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
        Mdl msg' ->
            Material.update msg' model
        NavigateTo path ->
            ( model, (Hop.outputFromPath hopConfig path |> Navigation.newUrl))
        SetQuery query ->
            ( model, (model.address |> Hop.setQuery query |> Hop.output hopConfig |> Navigation.newUrl))
        MessageReceived message ->
            let
                _ = log "WebSocket message received : " message
            in
                ( model, Cmd.none )
        FospMsg msg' ->
            let
                (connection, cmd) = FospConnection.update msg' model.connection
            in
                ({ model | connection = connection }, cmd)

subscriptions : Model -> Sub Msg
subscriptions model =
    case model.connection.host of
        "" -> Sub.none
        host -> WebSocket.listen host MessageReceived

content: Model -> List Int -> Html Msg
content model idx =
    div [ style [ ("margin", "20px auto"), ("width", "600px") ] ]
        []

view model =
    case model.route of
        Routing.Login -> View.Layout.render model View.LoginForm.render
        _ -> View.Layout.render model content


