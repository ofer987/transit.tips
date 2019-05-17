module Model exposing (..)

import Json exposing (..)
import Http
import PortFunnel.Geolocation as Geolocation


type Msg
    = RequestSchedule Location
    | ReceivedSchedule (Result Http.Error Json.Schedule)


type Model
    = HasLocation Location
    | HasSchedule Schedule Location
    | Error String


type alias Location =
    { latitude : Float
    , longitude : Float
    }


type alias Schedule =
    { location : Location
    , lines : List Line
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
    , directions : List Direction
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
