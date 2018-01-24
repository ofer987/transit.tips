module Model.Nearby exposing (..)

import Http
import Geolocation exposing (Location)
import Date exposing (Date)
import Model.Schedule as Schedule exposing (Schedule)


type Msg
    = None
    | RequestNearby Location
    | ReceiveNearby (Result Http.Error Json.Nearby.Nearby)
    | ReceiveTime Nearby Date


type Model
    = None
    | ReceivedSchedule Schedule
    | ReceivedDate Schedule Date
    | Error String


type alias Schedule =
    { routes : List Route
    , address : Maybe String
    }
