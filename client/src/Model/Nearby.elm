module Model.Nearby exposing (..)

import Http
import Geolocation
import Date exposing (Date)
import Model.Common exposing (Schedule, Location, Route)
import Json.Predictions


type Msg
    = GetLocation
    | UnavailableLocation Geolocation.Error
    | RequestSchedule Location
    | ReceiveSchedule (Result Http.Error Json.Predictions.Schedule)
    | RequestTime Schedule
    | ReceiveTime Schedule Date


type Model
    = Nil
    | ReceivedDate Schedule Date
    | Error String
