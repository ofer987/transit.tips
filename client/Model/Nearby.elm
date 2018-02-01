module Model.Nearby exposing (..)

import Http
import Geolocation
import Date exposing (Date)
import Model.Common exposing (Schedule, Location, Route)
import Json.Predictions


type Msg
    = None
    | GetLocation
    | UnavailableLocation Geolocation.Error
    | RequestSchedule Location
    | ReceiveSchedule (Result Http.Error Json.Predictions.Schedule)
    | RequestTime Schedule
    | ReceiveTime Schedule Date

type Step
    = NotStarted
    | First
    | Middle
    | Last

type Model
    = Nil
    | ReceivedSchedule Schedule
    | ReceivedDate Schedule Date
    | Error String
