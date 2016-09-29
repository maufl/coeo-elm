module Msg exposing (Msg (..))

import Material
import Hop.Types exposing (Query)

import Fosp.Connection as FospConnection

type Msg
    = NavigateTo String
    | SetQuery Query
    | MessageReceived String
    | FospMsg FospConnection.Msg
    | Mdl (Material.Msg Msg)

