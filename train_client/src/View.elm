module View exposing (view)

import String
import List
import Model exposing (..)


view : Model -> Html Controller
view model =
    case model of
        Nil ->
            div [] []

        InProgress ->
            div [] [ text "in progress" ]

        Received schedule ->
            div [] [ (viewSchedule schedule) ]


viewSchedule : Schedule -> Html Controller
viewSchedule schedule =
    div [] []


viewLocation : Location -> Html Controller
viewLocation location =
    let
        loc =
            location
                |> List.map toString
                |> String.join ", "
    in
        div
            []
            [ text "location is (" ++ loc ++ ")" ]


viewLines : List Line -> Html Controller
viewLines lines =
    div
        []
        []


viewLine : Line -> Html Controller
viewLine line =
    div
        []
        [ text line.name, (viewStation line.station) ]


viewStation : Station -> Html Controller
viewStation station =
    let
        direction =
            station.name ++ "to " ++ station.direction
    in
        div
            []
            [ text station.name ]


viewDirection : String -> Direction -> Html Controller
viewDirection stationName direction =
    let
        message =
            station.name ++ "to " ++ direction.destinationStationName

        events =
            direction.events
                |> List.map viewEvent
    in
        div
            []
            [ text message :: viewEvents ]


viewEvent : Event -> HtmlController
viewEvent event =
    let
        message =
            "arrving in " ++ event.arrivingIn
    in
        div
            []
            [ text message ]
