module Model exposing (..)

import Http
import Geolocation exposing (Location)
import Model.Schedule exposing (Schedule)


type Msg
    = None
    | GetLocation Int
    | SetLocation Location
    | UnavailableLocation Geolocation.Error
    | RequestSchedule Location
    | ReceiveSchedule (Result Http.Error Schedule)


-- type alias Model =
--     { location : Maybe Location
--     , schedule : Maybe Schedule
--     , error : Maybe String
--     }

type Model
    = NoLocation
    | FoundLocation Location
    | FoundSchedule Schedule
    | Error String
