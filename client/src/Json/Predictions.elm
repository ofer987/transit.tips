module Json.Predictions exposing (..)


type alias Schedule =
    { latitude : Float
    , longitude : Float
    , address : Maybe String
    , routes : List Route
    }


type alias Route =
    { id : String
    , title : String
    , agencyId : String
    , stop : Stop
    , arrivals : List Arrival
    }


type alias Direction =
    { id : Maybe String
    , title : String
    }


type alias Stop =
    { id : String
    , title : String
    }


type alias Arrival =
    { minutes : Int
    , seconds : Int
    , direction : Direction
    }
