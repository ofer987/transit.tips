module Model.Search exposing (..)

import Http
import Geolocation exposing (Location)
import Model.Stop exposing (Stop)
import Model.Route exposing (MyRoute, Route)


type Msg
    = None
    | RequestRoute Location String
    | ReceiveRoute (Result Http.Error MyRoute)
    | ReceivePredictions (Result Http.Error (Maybe Route))


type Model
    = None
    | ReceivedRoute Float Float (List Stop)
    | ReceivedPredictions Route
    | Error String


type Agency
    = TTC
    | Other
