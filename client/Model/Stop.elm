module Model.Stop exposing (Stops, Stop)


type alias Stops =
    List Stop


type alias Stop =
    { id : String
    , code : String
    , title : String
    , latitude : Float
    , longitude : Float
    }
