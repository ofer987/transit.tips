module Model.Nearby exposing (..)

import Http
import Time exposing (Posix)
import Model.Common exposing (Schedule, Location, Route)
import Json.Predictions


type Msg
    = RequestSchedule Location
    | ReceiveSchedule (Result Http.Error Json.Predictions.Schedule)
    | RequestTime Schedule
    | ReceiveTime Schedule Posix


type Model
    = Nil
    | HasLocation Location
    | ReceivedDate Schedule Posix
    | Error String
