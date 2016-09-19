module Msg exposing (Msg (..))

import Material

type Msg
    = Increment
    | Decrement
    | Mdl (Material.Msg Msg)

