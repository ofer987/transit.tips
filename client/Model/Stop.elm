module Model.Stop exposing (Stops, Stop, nilStop)


type alias Stops =
    List Stop


type alias Stop =
    { id : String
    , code : String
    , title : String
    , latitude : Float
    , longitude : Float
    }

nilStop : Stop
nilStop =
    { id = ""
    , code = ""
    , title = ""
    , latitude = 0.0
    , longitude = 0.0
    }
