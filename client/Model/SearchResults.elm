-- Rename to Model.Search
module Model.SearchResults exposing (..)

import Http
import Geolocation exposing (Location)
import Model.Route exposing (Route)


type Msg
    = None
    | GetLocation String
    | SetLocation Location String
    | UnavailableLocation Geolocation.Error
    | RequestRoute Location String
    | ReceiveRoute (Result Http.Error Route)
    -- Might not be needed
    -- | RequestArrivals String String
    | ReceiveArrivals (Result Http.Error Route)


type Model
    = NoLocation
    | ReceivedLocation Float Float
    | ReceivedRoute Route
    | ReceivedArrivals Route
    | Error String
