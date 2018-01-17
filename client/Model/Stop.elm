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


sortedStopsByPosition : Float -> Float -> List Stop -> List Stop
sortedStopsByPosition latitude longitude stops =
    stops
        |> List.sortBy (distance latitude longitude)


distance : Float -> Float -> Stop -> Float
distance latitude longitude stop =
    sqrt (((stop.latitude - latitude) ^ 2) + ((stop.longitude - longitude) ^ 2))
