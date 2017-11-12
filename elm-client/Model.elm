module Model exposing (..)

import Geolocation exposing (Error, Location)
import Model.Schedule exposing (..)


type Msg
    = None
    | GetLocation Int
    | SetLocation Location
    | UnavailableLocation Error


type alias Model =
    { location : Maybe Location
    , schedule : Schedule
    }
