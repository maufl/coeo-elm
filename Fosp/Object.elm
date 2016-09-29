module Fosp.Object exposing (..)

import Date exposing (Date)
import Json.Decode exposing (Value)

type alias Object =
    { owner: String
    , created: Date
    , updated: Date
    , typ: String
    , data: Value
    }
