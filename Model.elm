module Model exposing (Model, model)

import Fosp.Connection as FospConnection
import Routing exposing (Route (Root))
import Hop.Types exposing (Address, newAddress)
import Material

type alias Model =
    { counter: Int
    , route: Route
    , address: Address
    , mdl: Material.Model
    , connection: FospConnection.Model
    }

model : Model
model =
    { counter = 0
    , route = Root
    , address = newAddress
    , mdl = Material.model
    , connection = FospConnection.model
    }
