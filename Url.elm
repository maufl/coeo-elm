module Url exposing (hopConfig, urlParser, urlUpdate)

import String
import Navigation
import Hop.Types exposing (Config, Address)
import Hop
import UrlParser

import Model exposing (Model)
import Msg exposing (Msg)
import Routing exposing (routeParser, Route (Root))



hopConfig : Config
hopConfig =
    { hash = True
    , basePath = ""
    }


urlParser : Navigation.Parser ( Route, Address )
urlParser =
    let
        parse path =
            path
                |> UrlParser.parse identity routeParser
                |> Result.withDefault Root
        resolver =
            Hop.makeResolver hopConfig parse
    in
        Navigation.makeParser (.href >> resolver)

urlUpdate : ( Route, Address ) -> Model -> ( Model, Cmd Msg )
urlUpdate ( route, address ) model =
    ( { model | route = route, address = address }, Cmd.none )
