module Url exposing (toUrl, urlParser, urlUpdate)

import String

import Navigation

import Model exposing (Model)
import Msg exposing (Msg)

toUrl : Model -> String
toUrl model =
    "#/count/" ++ toString model.counter

fromUrl : String -> Result String Int
fromUrl url =
    url
        |> String.dropLeft 8
        |> String.toInt

urlParser : Navigation.Parser (Result String Int)
urlParser =
    Navigation.makeParser (fromUrl << .hash)

urlUpdate : Result String Int -> Model -> (Model, Cmd Msg)
urlUpdate result model =
    case result of
        Ok newCount ->
            ({ model | counter = newCount }, Cmd.none)
        Err _ ->
            (model, Navigation.modifyUrl (toUrl model))
