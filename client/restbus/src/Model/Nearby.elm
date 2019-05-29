module Model.Nearby exposing (..)

import Http
import Time exposing (Posix)
import Model.Common exposing (Schedule, Location, Route)
import Json.Predictions
import Json.Trains


type Msg
    = RequestSchedule Location
    | ReceiveSchedule (Result Http.Error Json.Predictions.Schedule)
    | RequestTrains Location Schedule
    | ReceivedTrains (Result Http.Error Json.Trains.Schedule)
    | RequestTime Schedule
    | ReceiveTime Schedule Posix


type Model
    = Nil
    | HasLocation Location
    | ReceivedDate Schedule Posix
    | Error String
