module Model.Stop exposing (Stops, Stop, toString)


type alias Stops =
    List Stop


type alias Stop =
    { id : String
    , title : String
    , latitude : Float
    , longitude : Float
    }


toString : List Stop -> String -> String
toString stops result =
    case stops of
        head :: tail ->
            toString tail (result ++ head.id)

        [] ->
            result
