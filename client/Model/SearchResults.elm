module Model.SearchResults exposing (..)

import Http
import Geolocation exposing (Location)
import Model.Route exposing (Route)


type Msg
    = None
    | GetLocation Int
    | SetLocation Location
    | UnavailableLocation Geolocation.Error
    | RequestRoute Location String
    | ReceiveRoute (Result Http.Error Route)
    | RequestStops String String
    | ReceiveStops (Result Http.Error Route)


type Model
    = NoLocation
    | ReceivedLocation Float Float
    | ReceivedRoute Route
    | ReceivedStops Route
    | Error String
