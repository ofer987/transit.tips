module Model exposing (..)

import Geolocation exposing (Error, Location)
import Model.Schedule exposing (..)


type Msg
    = None
    | GetLocation Int
    | SetLocation Location
    | NoLocation Error


type alias Model =
    { locationLatitude : Float
    , locationLongitude : Float
    , schedule : Schedule
    }
