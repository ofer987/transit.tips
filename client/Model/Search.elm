module Model.Search exposing (..)

import Http
import Json.Route
import Json.Predictions
import Model.Common exposing (..)


type Msg
    = None
    | RequestRoute Location String
    | ReceiveRoute Location (Result Http.Error Json.Route.Schedule)
    | FindNearestStop Location Schedule
    | RequestPredictions Location Schedule Stop
    | ReceivePredictions Location (Result Http.Error (Maybe Json.Predictions.Schedule))


type Model
    = Nil
    | ReceivedRoute Schedule
    | ReceivedNearestStop Schedule Stop
    | ReceivedPredictions Schedule
    | Error String
