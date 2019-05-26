module View exposing (view)

import String exposing (fromFloat)
import List
import Model exposing (..)
import Html exposing (Html, text, div)
import Html.Attributes exposing (class)


view : Model -> Html Msg
view model =
    case model of
        HasLocation location ->
            div
                []
                [ text ("the location is (" ++ (fromFloat location.latitude) ++ ", " ++ (fromFloat location.longitude) ++ ")") ]

        HasSchedule schedule location ->
            div [] [ text "displaying the schedule", (viewSchedule schedule) ]

        Error message ->
            div [] [ (text message) ]


viewSchedule : Schedule -> Html Msg
viewSchedule schedule =
    div
        [ class "schedule" ]
        [ viewLocation schedule.location
        , text "available lines"
        , viewLines schedule.lines
        ]


viewLocation : Location -> Html Msg
viewLocation location =
    let
        locationString : String
        locationString =
            "(" ++ (fromFloat location.latitude) ++ ", " ++ (fromFloat location.longitude) ++ ")"
    in
        div
            [ class "location" ]
            [ text ("location is " ++ locationString) ]


viewLines : List Line -> Html Msg
viewLines lines =
    div
        [ class "lines" ]
        (List.map viewLine lines)


viewLine : Line -> Html Msg
viewLine line =
    div
        [ class "line" ]
        [ text line.name, (viewStation line.station) ]


viewStation : Station -> Html Msg
viewStation station =
    let
        directions =
            station.directions
                |> List.map (viewDirection station.name)
    in
        div
            [ class "station" ]
            (text station.name :: directions)


viewDirection : String -> Direction -> Html Msg
viewDirection stationName direction =
    let
        message =
            stationName ++ " to " ++ direction.destinationStationName

        events : List (Html Msg)
        events =
            direction.events
                |> List.map viewEvent
    in
        div
            [ class "direction" ]
            (text message :: events)


viewEvent : Event -> Html Msg
viewEvent event =
    let
        message =
            "arrving in " ++ event.arrivingIn
    in
        div
            [ class "event" ]
            [ text message ]
