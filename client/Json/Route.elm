module Json.Route exposing (..)

import Json.Common exposing (Agency)


type alias Route =
    { id : String
    , title : String
    , agency : Agency
    , stops : List Stop
    , directions : List Direction
    }


type alias Direction =
    { id : String
    , title : String
    , shortTitle : String
    , stops : List String
    }


type alias Stop =
    { id : String
    , code : String
    , title : String
    , latitude : Float
    , longitude : Float
    }


type alias Arrival =
    { minutes : Int
    , seconds : Int
    , direction : Direction
    }
