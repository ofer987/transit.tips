module Model.Location exposing (..)

import Geolocation exposing (Location)


type Msg
    = None
    | GetLocation Int
    | SetLocation Location
    | UnavailableLocation Geolocation.Error


type Model
    = NoLocation
    | ReceivedLocation Float Float
    | Error String
