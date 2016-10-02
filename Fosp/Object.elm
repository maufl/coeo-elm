module Fosp.Object exposing (Object, decoder)

import Date exposing (Date)
import Json.Decode exposing (..)

type alias Object =
    { owner: String
    , created: Date
    , updated: Date
    , typ: Maybe String
    , data: Maybe Value
    }


date : Decoder Date
date =
    customDecoder string Date.fromString
decoder : Decoder Object
decoder =
    object5 Object
        ("owner" := string)
        ("created" := date)
        ("updated" := date)
        (maybe ("type" := string))
        (maybe ("data" := value))
