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
    | ReceivedLocation Float Float
    | ReceivedSchedule Nearby
    | ReceivedDate Nearby Date
    | Error String
