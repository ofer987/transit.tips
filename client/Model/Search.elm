module Model.Search exposing (..)

import Http
import Json.Route
import Json.Predictions
import Model.Common exposing (..)


type Msg
    = None
    | RequestRoute Location String
    | ReceiveRoute (Result Http.Error Json.Route.Schedule)
    | ReceivePredictions (Result Http.Error (Maybe Json.Predictions.Schedule))


type Model
    = Nil
    | ReceivedRoute Schedule
    | ReceivedPredictions Schedule
    | Error String
