module Model.Search exposing (..)

import Http
import Json.Route
import Json.Predictions
import Model.Common exposing (..)


type Msg
    = RequestRoute (List String) String Location
    | ReceiveRoute (Result Http.Error (List Json.Route.Schedule))
    | ReceivePredictions (Result Http.Error (List Json.Predictions.Schedule))


type Model
    = Nil
    | InProgress
    | ReceivedPredictions Schedule
    | Error String
