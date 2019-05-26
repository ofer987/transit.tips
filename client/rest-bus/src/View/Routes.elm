module View.Routes exposing (view)

import MyCss exposing (CssClasses)
import Html.Styled exposing (Html, styled, div, span, text)
import Html.Styled.Attributes exposing (class)
import Css exposing (padding2, px, property, margin2, float, left, right)
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
        styled div
            []
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
        styled div
            [ padding2 (px 5) (px 20) ]
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
        styled div
            [ margin2 (px 5) (px 0) ]
            [ class "MyCss.Arrivals" ]
            (List.map (\arrival -> arrivalView arrival.parent.title arrival.minutes) list)


arrivalView : String -> Int -> Html Controller
arrivalView location minutes =
    styled div
        [ margin2 (px 20) (px 0) ]
        [ class "MyCss.Arrival" ]
        [ styled span [ float left ] [ class "MyCss.Location" ] [ text location ]
        , styled span [ float right ] [ class "MyCss.Minutes" ] [ text (fromInt minutes) ]
        , styled div [ property "clear" "both" ] [ class "MyCss.Clearing" ] []
        ]
