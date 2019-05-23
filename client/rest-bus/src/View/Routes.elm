module View.Routes exposing (view)

import MyCss exposing (CssClasses)


-- import Html.CssHelpers

import Html exposing (Html, div, span, text)
import Html.Attributes exposing (class)
import String exposing (fromInt)
import Model exposing (..)
import Model.Route
import Model.Direction
import Model.Common exposing (..)


-- { id, class, classList } =
--     Html.CssHelpers.withNamespace "TransitTips"


view : Routes -> Html Controller
view routes =
    let
        list =
            case routes of
                Routes value ->
                    value
    in
        div
            [ class "MyCss.Routes" ]
            (List.map routeView list)


routeView : Route -> Html Controller
routeView route =
    div
        [ class "MyCss.Route" ]
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
            [ class "MyCss.Directions" ]
            (List.map directionView list)


directionView : Direction -> Html Controller
directionView direction =
    let
        agencyId =
            direction.parent.agencyId

        agency =
            Model.Route.toAgency agencyId
    in
        div
            [ class "MyCss.Direction" ]
            [ text (Model.Direction.title agency direction.title)
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
            [ class "MyCss.Stops" ]
            (List.map stopView list)


stopView : Stop -> Html Controller
stopView stop =
    div
        [ class "MyCss.Stop" ]
        [ arrivalsView stop.arrivals ]


arrivalsView : Arrivals -> Html Controller
arrivalsView arrivals =
    let
        list =
            case arrivals of
                Arrivals value ->
                    value
    in
        div
            [ class "MyCss.Arrivals" ]
            (List.map (\arrival -> arrivalView arrival.parent.title arrival.minutes) list)


arrivalView : String -> Int -> Html Controller
arrivalView location minutes =
    div
        [ class "MyCss.Arrival" ]
        [ span [ class "MyCss.Location" ] [ text location ]
        , span [ class "MyCss.Minutes" ] [ text (fromInt minutes) ]
        , div [ class "MyCss.Clearing" ] []
        ]
