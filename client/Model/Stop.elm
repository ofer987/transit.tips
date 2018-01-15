module Model.Stop exposing (Stops, Stop, nilStop, toString)


type alias Stops =
    List Stop


type alias Stop =
    { id : String
    , title : String
    , latitude : Float
    , longitude : Float
    }


nilStop : Stop
nilStop =
    { id = ""
    , title = ""
    , latitude = 0.0
    , longitude = 0.0
    }


toString : List Stop -> String -> String
toString stops result =
    case stops of
        head :: tail ->
            toString tail (result ++ head.id)

        [] ->
            result
