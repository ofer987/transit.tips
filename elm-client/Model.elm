module Model exposing (..)

import Http
import Geolocation exposing (Error, Location)
import Model.Schedule exposing (Schedule)


type Msg
    = None
    | GetLocation Int
    | SetLocation Location
    | UnavailableLocation Error
    | RequestSchedule Location
    | ReceiveSchedule (Result Http.Error Schedule)


type alias Model =
    { location : Maybe Location
    , schedule : Maybe Schedule
    }
