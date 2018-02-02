module Json.Route exposing (..)


type alias Schedule =
    { latitude : Float
    , longitude : Float
    , address : Maybe String
    , route : Route
    }


type alias Route =
    { id : String
    , title : String
    , agencyId : String
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
