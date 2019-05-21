module Model.Nearby exposing (..)

import Http
import Time exposing (Time)
import Model.Common exposing (Schedule, Location, Route)
import Json.Predictions


type Msg
    = RequestSchedule Location
    | ReceiveSchedule (Result Http.Error Json.Predictions.Schedule)
    | RequestTime Schedule
    | ReceiveTime Schedule Date


type Model
    = Nil
    | HasLocation Location
    | ReceivedDate Schedule Date
    | Error String
