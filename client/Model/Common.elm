module Model.Common exposing (..)


type Agency
    = TTC
    | Else


type Directions
    = Directions (List Direction)


type Routes
    = Routes (List Route)


type Arrivals
    = Arrivals (List Arrival)


type Stops
    = Stops (List Stop)


type alias Schedule =
    { location : Location
    , address : Maybe String
    , routes : Routes
    }


type alias Route =
    { id : String
    , parent : Schedule
    , title : String
    , agencyId : String
    , directions : Directions
    }


type alias Direction =
    { id : Maybe String
    , parent : Route
    , shortTitle : String
    , title : String
    , stops : Stops
    }


type alias Stop =
    { id : String
    , parent : Direction
    , title : String
    , location : Maybe Location
    , arrivals : Arrivals
    }


type alias Location =
    { latitude : Float
    , longitude : Float
    }


type alias Arrival =
    { parent : Stop
    , minutes : Int
    , seconds : Int
    }
