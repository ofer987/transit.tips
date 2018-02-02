module Model.Search exposing (..)

import Http
import Geolocation
import Json.Route
import Json.Predictions
import Model.Common exposing (..)


type Msg
    = GetLocation String
    | UnavailableLocation String Geolocation.Error
    | RequestRoute String Location
    | ReceiveRoute (Result Http.Error Json.Route.Schedule)
    | ReceivePredictions (Result Http.Error Json.Predictions.Schedule)


type Model
    = Nil String
    | ReceivedRoute Schedule
    | ReceivedPredictions Schedule
    | Error String
