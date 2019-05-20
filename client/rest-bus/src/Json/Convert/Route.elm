module Json.Convert.Route exposing (..)

import Json.Route exposing (..)
import Model.Route
import Model.Common
import List


toSchedule : Schedule -> Model.Common.Schedule
toSchedule json =
    let
        self =
            Model.Common.Schedule
                (Model.Common.Location json.latitude json.longitude)
                json.address
                (Model.Common.Routes [])

        schedule =
            Model.Common.Schedule
                (Model.Common.Location json.latitude json.longitude)
                json.address
                (Model.Common.Routes [ (toRoute self) json.route ])

        routes =
            case schedule.routes of
                Model.Common.Routes list ->
                    list

        flattenedRoutes =
            Model.Common.Routes (Model.Route.flatten [] routes)

        sortedRoutes =
            Model.Route.sort flattenedRoutes
    in
        { schedule | routes = sortedRoutes }


toRoute : Model.Common.Schedule -> Route -> Model.Common.Route
toRoute parent json =
    let
        self =
            Model.Common.Route
                json.id
                parent
                json.title
                json.agencyId
                (Model.Common.Directions [])

        route =
            Model.Common.Route
                json.id
                parent
                json.title
                json.agencyId
                (Model.Common.Directions (List.map (toDirection self json.directions) json.stops))
    in
        route


toDirection : Model.Common.Route -> List Direction -> Stop -> Model.Common.Direction
toDirection parent directions json =
    let
        self =
            Model.Common.Direction
                Nothing
                parent
                ""
                ""
                (Model.Common.Stops [])

        myDirection : List Direction -> String -> Maybe Direction
        myDirection list stopId =
            list
                |> List.filter (\dir -> List.any (\stop -> stop == stopId) dir.stops)
                |> List.head

        direction dir =
            Model.Common.Direction
                dir.id
                parent
                dir.shortTitle
                dir.title
                (Model.Common.Stops [ toStop self json ])
    in
        case myDirection directions json.id of
            Just value ->
                direction value

            Nothing ->
                Model.Common.Direction
                    Nothing
                    parent
                    ""
                    ""
                    (Model.Common.Stops [ toStop self json ])


toStop : Model.Common.Direction -> Stop -> Model.Common.Stop
toStop parent json =
    Model.Common.Stop
        json.id
        parent
        json.title
        Nothing
        (Model.Common.Arrivals [])
