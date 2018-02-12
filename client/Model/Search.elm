module Model.Search exposing (..)

import Http
import Geolocation
import Json.Route
import Json.Predictions
import Model.Common exposing (..)


type Msg
    = GetLocation (List String) String
    | UnavailableLocation String Geolocation.Error
    | RequestRoute (List String) String Location
    | ReceiveRoute (Result Http.Error (List Json.Route.Schedule))
    | ReceivePredictions (Result Http.Error (List Json.Predictions.Schedule))


type Model
    = Nil
    | InProgress
    | ReceivedPredictions Schedule
    | Error String
