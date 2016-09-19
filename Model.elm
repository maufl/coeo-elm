module Model exposing (Model, model)

import Material

type alias Model =
    { counter: Int
    , mdl: Material.Model
    }

model : Model
model =
    { counter = 0
    , mdl = Material.model
    }
