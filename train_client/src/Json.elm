module Json exposing (..)


type alias Schedule =
    { latitude : Float
    , longitude : Float
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
    , latitude : Float
    , longitude : Float
    , directions : List Direction
    }


type alias Direction =
    { destination_station : String
    , events : List Event
    }


type alias Event =
    { approximately_in : String
    , precisely_in : Float
    , message : String
    }
