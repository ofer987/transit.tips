module View exposing (view)

import String exposing (fromFloat)
import List
import Model exposing (..)
import Html exposing (Html, text, div)


view : Model -> Html Msg
view model =
    case model of
        HasLocation _ ->
            div [] []

        HasSchedule schedule location ->
            div [] [ (viewSchedule schedule) ]

        Error message ->
            div [] [ (text message) ]


viewSchedule : Schedule -> Html Msg
viewSchedule schedule =
    div [] []


viewLocation : Location -> Html Msg
viewLocation location =
    let
        locationString : String
        locationString =
            "(" ++ (fromFloat location.latitude) ++ ", " ++ (fromFloat location.longitude) ++ ")"
    in
        div
            []
            [ text ("location is " ++ locationString) ]


viewLines : List Line -> Html Msg
viewLines lines =
    div
        []
        []


viewLine : Line -> Html Msg
viewLine line =
    div
        []
        [ text line.name, (viewStation line.station) ]


viewStation : Station -> Html Msg
viewStation station =
    let
        directions =
            station.directions
                |> List.map (viewDirection station.name)
    in
        div
            []
            (text station.name :: directions)


viewDirection : String -> Direction -> Html Msg
viewDirection stationName direction =
    let
        message =
            stationName ++ "to " ++ direction.destinationStationName

        events : List (Html Msg)
        events =
            direction.events
                |> List.map viewEvent
    in
        div
            []
            (text message :: events)


viewEvent : Event -> Html Msg
viewEvent event =
    let
        message =
            "arrving in " ++ event.arrivingIn
    in
        div
            []
            [ text message ]
