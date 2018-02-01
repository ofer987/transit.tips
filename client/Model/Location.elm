module Model.Location exposing (..)

import Geolocation exposing (Location)


type Msg
    = None
    | GetLocation
    | SetLocation Location
    | UnavailableLocation Geolocation.Error


type Step
    = First Msg
    | Middle Msg
    | Last Msg

type Model
    = Nil
    | ReceivedLocation Float Float
    | Error String
