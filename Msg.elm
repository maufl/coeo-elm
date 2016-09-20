module Msg exposing (Msg (..))

import Material
import Hop.Types exposing (Query)

type Msg
    = Increment
    | Decrement
    | NavigateTo String
    | SetQuery Query
    | Mdl (Material.Msg Msg)

