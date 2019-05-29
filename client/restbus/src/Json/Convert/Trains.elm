module Json.Convert.Trains exposing (toModel)

import List
import String exposing (fromInt)
import Json.Trains exposing (..)
import Model.Common as Model
import Model.Route


toModel : Schedule -> Model.Schedule
toModel =
    toSchedule


toSchedule : Schedule -> Model.Schedule
toSchedule json =
    let
        otherRoutes =
            case json.otherSchedule.routes of
                Model.Routes list ->
                    list

        self =
            Model.Schedule
                (Model.Location json.latitude json.longitude)
                json.otherSchedule.address
                (Model.Routes [])

        schedule =
            Model.Schedule
                (Model.Location json.latitude json.longitude)
                json.otherSchedule.address
                (Model.Routes [ List.map (toRoute self) json.lines ])

        routes =
            case schedule.routes of
                Model.Routes list ->
                    list

        allRoutes : List Model.Route
        allRoutes =
            combine routes otherRoutes

        combine : List a -> List a -> List a
        combine result newItems =
            case newItems of
                item :: remaining ->
                    combine (item :: result) remaining

                [] ->
                    result

        flattenedRoutes =
            Model.Routes (Model.Route.flatten [] allRoutes)

        sortedRoutes =
            Model.Route.sort flattenedRoutes
    in
        { schedule | routes = sortedRoutes }


toRoute : Model.Schedule -> Line -> Model.Route
toRoute parent json =
    let
        directions : List Direction
        directions =
            json.stations
                |> List.map .directions
                |> List.concat

        self =
            Model.Route
                (fromInt json.id)
                parent
                json.name
                "ttc"
                (Model.Directions [])

        route =
            Model.Route
                (fromInt json.id)
                parent
                json.name
                "ttc"
                (Model.Directions (List.map (toDirection self directions) json.stations))
    in
        route


toDirection : Model.Route -> List Direction -> Station -> Model.Direction
toDirection parent directions json =
    let
        self =
            Model.Direction
                Nothing
                parent
                ""
                ""
                (Model.Stops [])

        myDirection : List Direction -> String -> Maybe Direction
        myDirection list stopId =
            list
                |> List.filter (\dir -> List.any (\stop -> stop == stopId) dir.stops)
                |> List.head

        direction dir =
            Model.Direction
                dir.id
                parent
                dir.shortTitle
                dir.title
                (Model.Stops [ toStop self json ])
    in
        case myDirection directions json.id of
            Just value ->
                direction value

            Nothing ->
                Model.Direction
                    Nothing
                    parent
                    ""
                    ""
                    (Model.Stops [ toStop self json ])


toStop : Model.Direction -> Station -> Model.Stop
toStop parent json =
    Model.Stop
        json.id
        parent
        json.title
        Nothing
        (Model.Arrivals [])
