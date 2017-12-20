module Model exposing (..)

import Http
import Geolocation exposing (Location)
import Model.Response exposing (Response)


type Msg
    = None
    | GetLocation Int
    | SetLocation Location
    | UnavailableLocation Geolocation.Error
    | RequestSchedule Location
    | ReceiveSchedule (Result Http.Error Response)


type Model
    = NoLocation Int
    | FoundLocation Int Float Float
    | FoundSchedule Response
    | Error String
