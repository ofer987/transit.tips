module Model.Common exposing (..)

type Agency
    = TTC
    | Else

type Directions
    = Directions (List Direction)


type Routes
    = Routes (List Route)


type Arrivals
    = Arrivals (List Arrival)


type Stops
    = Stops (List Stop)


type alias Schedule =
    { location : Location
    , address : Maybe String
    , routes : Routes
    }


type alias Route =
    { id : String
    , parent : Schedule
    , title : String
    , agencyId : String
    , directions : Directions
    }


type alias Direction =
    { id : Maybe String
    , parent : Route
    , shortTitle : String
    , title : String
    , stops : Stops
    }


type alias Stop =
    { id : String
    , parent : Direction
    , title : String
    , location : Maybe Location
    , arrivals : Arrivals
    }


type alias Location =
    { latitude : Float
    , longitude : Float
    }


type alias Arrival =
    { parent : Stop
    , minutes : Int
    , seconds : Int
    }


sortByStop : Float -> Float -> Routes -> List Stop
sortByStop latitude longitude routes =
    case routes of
        Routes routes ->
            routes
                |> List.concatMap
                    (\route ->
                        case route.directions of
                            Directions directions ->
                                directions
                    )
                |> List.concatMap
                    (\direction ->
                        case direction.stops of
                            Stops stops ->
                                stops
                    )
                |> List.sortBy (stopDistance latitude longitude)


stopDistance : Float -> Float -> Stop -> Float
stopDistance latitude longitude stop =
    let
        location =
            case stop.location of
                Just value ->
                    value

                Nothing ->
                    Location ((2 ^ 32) - 1) ((2 ^ 32) - 1)
    in
        distance latitude longitude location.latitude location.longitude


distance : Float -> Float -> Float -> Float -> Float
distance latitude1 longitude1 latitude2 longitude2 =
    sqrt (((latitude2 - latitude1) ^ 2) + ((longitude2 - longitude1) ^ 2))
