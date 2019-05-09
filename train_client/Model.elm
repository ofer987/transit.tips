module Model exposing (..)

import Json exposing (..)
import Http
import PortFunnel.Geolocation


type Msg
    = GetLocation
    | UnavailableLocation PortFunnel.Geolocation.Error
    | RequestSchedule Location
    | ReceivedSchedule (Result Http.Error Json.Schedule)
    | Error String


type Model
    = Nil
    | InProgress
    | Received Schedule
    | Error String


type alias Location =
    { latitude : Float
    , longitude : Float
    }


type alias Line =
    { id : Int
    , name : String
    , station : Station
    }


type alias Station =
    { id : Int
    , name : String
    , location : Location
    , destinationStationName : String
    , events : Events

    -- , directions : List Direction
    }


type alias Direction =
    { destinationStationName : String
    , events : List Event
    }


type alias Event =
    { arrivingIn : String
    , arrivingPreciselyIn : Float
    , message : String
    }


type alias Schedule =
    { location : Location
    , address : Maybe String
    , lines : List Line
    }
