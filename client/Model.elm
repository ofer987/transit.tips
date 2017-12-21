module Model exposing (..)

import Http
import Geolocation exposing (Location)
import Date exposing (Date)
import Model.Nearby exposing (Nearby)


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
    | FoundLocation Float Float
    | FoundSchedule Nearby
    | FoundTime Nearby Date
    | Error String
