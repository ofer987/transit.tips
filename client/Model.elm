module Model exposing (..)

import Http
import Geolocation exposing (Location)
import Time exposing (Time)
import Model.Nearby exposing (Nearby)


type Msg
    = None
    | GetLocation Int
    | SetLocation Location
    | UnavailableLocation Geolocation.Error
    | RequestSchedule Location
    | ReceiveSchedule (Result Http.Error Nearby)
    | ReceiveTime Nearby Time


type Model
    = NoLocation
    | FoundLocation Float Float
    | FoundSchedule Nearby
    | FoundTime Nearby Time
    | Error String
