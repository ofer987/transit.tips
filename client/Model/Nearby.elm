module Model.Nearby exposing (..)

import Http
import Date exposing (Date)
import Model.Common exposing (Schedule, Location, Route)
import Json.Predictions


type Msg
    = None
    | RequestSchedule Location
    | ReceiveSchedule (Result Http.Error Json.Predictions.Schedule)
    | RequestTime Schedule
    | ReceiveTime Schedule Date


type Model
    = Nil
    | ReceivedSchedule Schedule
    | ReceivedDate Schedule Date
    | Error String
