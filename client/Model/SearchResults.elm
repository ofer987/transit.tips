-- Rename to Model.Search


module Model.SearchResults exposing (..)

import Http
import Geolocation exposing (Location)
import Model.Stop exposing (Stop)
import Model.Route exposing (MyRoute, Route)


type Msg
    = None
    | GetLocation String
    | SetLocation Location String
    | UnavailableLocation Geolocation.Error
    | RequestRoute Location String
    | ReceiveRoute (Result Http.Error MyRoute)
    | ReceiveArrivals (Result Http.Error (Maybe Route))


type Model
    = NoLocation
    | ReceivedLocation Float Float
    | ReceivedRoute Float Float (List Stop)
    | ReceivedArrivals Route
    | Error String
