module Json.Nearby exposing (..)

import Json.Schedule exposing (Schedule)

type alias Nearby =
    { latitude : Float
    , longitude : Float
    , schedule : Schedule
    , address : Maybe String
    }

toModel : Nearby -> Model.Nearby.Nearby
toModel json =
    { latitude = json.latitude
    , longitude = json.longitude
    , schedule = Json.Schedule.toModel schedule
    , address = json.address
    }

