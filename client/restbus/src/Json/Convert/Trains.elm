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
                (Model.Routes (List.map (toRoute self) json.lines))

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

        directionModelsForStation : Station -> List Model.Direction
        directionModelsForStation jsonStation =
            toDirections self jsonStation

        directionModels : List Model.Direction
        directionModels =
            json.stations
                |> List.map directionModelsForStation
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
                (Model.Directions directionModels)
    in
        route


toDirections : Model.Route -> Station -> List Model.Direction
toDirections route jsonStation =
    let
        self : Direction -> Model.Direction
        self jsonDirection =
            Model.Direction
                Nothing
                route
                jsonDirection.destination_station
                jsonDirection.destination_station
                (Model.Stops [])

        direction : Direction -> Model.Direction
        direction jsonDirection =
            let
                directionSelf =
                    self jsonDirection
            in
                { directionSelf | stops = Model.Stops [ (toStop directionSelf jsonStation jsonDirection) ] }
    in
        jsonStation.directions
            |> List.map direction


toStop : Model.Direction -> Station -> Direction -> Model.Stop
toStop direction jsonStation jsonDirection =
    let
        self =
            Model.Stop
                (fromInt jsonStation.id)
                direction
                jsonStation.name
                (Just { latitude = jsonStation.latitude, longitude = jsonStation.longitude })
                (Model.Arrivals [])
    in
        { self | arrivals = Model.Arrivals (List.map (toArrival self) jsonDirection.events) }


toArrival : Model.Stop -> Event -> Model.Arrival
toArrival stop jsonEvent =
    let
        minutes =
            floor jsonEvent.precisely_in

        seconds =
            truncate <| 60 * (jsonEvent.precisely_in - (toFloat minutes))
    in
        Model.Arrival
            stop
            minutes
            seconds
