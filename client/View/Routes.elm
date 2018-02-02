module View.Routes exposing (view)

import MyCss exposing (CssClasses)
import Html.CssHelpers
import Html exposing (Html, div, span, text)
import Model exposing (..)
import Model.Common exposing (..)


{ id, class, classList } =
    Html.CssHelpers.withNamespace "TransitTips"


view : Routes -> Html Controller
view routes =
    let
        list =
            case routes of
                Routes value ->
                    value
    in
        div
            [ class [ MyCss.Routes ] ]
            (List.map routeView list)


routeView : Route -> Html Controller
routeView route =
    div
        [ class [ MyCss.Route ] ]
        [ text route.title
        , directionsView route.directions
        ]


directionsView : Directions -> Html Controller
directionsView directions =
    let
        list =
            case directions of
                Directions value ->
                    value
    in
        div
            [ class [ MyCss.Directions ] ]
            (List.map directionView list)


directionView : Direction -> Html Controller
directionView direction =
    div
        [ class [ MyCss.Direction ] ]
        [ text direction.title
        , stopsView direction.stops
        ]


stopsView : Stops -> Html Controller
stopsView stops =
    let
        list =
            case stops of
                Stops value ->
                    value
    in
        div
            [ class [ MyCss.Stops ] ]
            (List.map stopView list)


stopView : Stop -> Html Controller
stopView stop =
    div
        []
        [ text stop.title
        , arrivalsView stop.arrivals
        ]


arrivalsView : Arrivals -> Html Controller
arrivalsView arrivals =
    let
        list =
            case arrivals of
                Arrivals value ->
                    value
    in
        div
            [ class [ MyCss.Arrivals ] ]
            (List.map (\arrival -> arrivalView arrival.parent.title arrival.minutes) list)


arrivalView : String -> Int -> Html Controller
arrivalView location minutes =
    div
        [ class [ MyCss.Arrival ] ]
        [ text location
        , text (toString minutes)
        ]
