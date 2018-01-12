module Model.Nearby exposing (Msg, Model, Nearby)

import Http
import Geolocation exposing (Location)
import Date exposing (Date)
import Model.Schedule as Schedule exposing (Schedule)


type Msg
    = None
    | GetLocation Int
    | SetLocation Location
    | UnavailableLocation Geolocation.Error
    | RequestSchedule Location
    | ReceiveSchedule (Result Http.Error Nearby)
    | ReceiveTime Nearby Date


type Model
    = NoLocation
    | ReceivedLocation Float Float
    | ReceivedSchedule Nearby
    | ReceivedDate Nearby Date
    | Error String


type alias Nearby =
    { latitude : Float
    , longitude : Float
    , schedule : Schedule
    , address : Maybe String
    }
