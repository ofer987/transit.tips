module Json exposing (..)


type alias Schedule =
    { longitude : Float
    , latitude : Float
    , lines : List Line
    }


type alias Line =
    { line_id : Int
    , station_id : Int
    , events : List Event
    }


type alias Event =
    { line : String
    , line_id : Int
    , station : String
    , station_id : Int
    , longitude : Float
    , latitude : Float
    , destination_station : String
    , events : List Event
    }
type alias Event =
    { precisely_in : Float
    , message : String
    }
