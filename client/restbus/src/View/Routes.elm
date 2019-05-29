module View.Routes exposing (view)

import MyCss
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


view : Routes -> Html Msg
view routes =
    let
        list =
            case routes of
                Routes value ->
                    value
    in
        MyCss.routes
            [ class "MyCss.Routes" ]
            (List.map routeView list)


routeView : Route -> Html Msg
routeView route =
    MyCss.route
        [ class "MyCss.Route" ]
        [ text route.title
        , directionsView route.directions
        ]


directionsView : Directions -> Html Msg
directionsView directions =
    let
        list =
            case directions of
                Directions value ->
                    value
    in
        MyCss.directions
            [ class "MyCss.Directions" ]
            (List.map directionView list)


directionView : Direction -> Html Msg
directionView direction =
    let
        agencyId =
            direction.parent.agencyId

        agency =
            Model.Route.toAgency agencyId
    in
        MyCss.direction
            [ class "MyCss.Direction" ]
            [ text (Model.Direction.title agency direction.title)
            , stopsView direction.stops
            ]


stopsView : Stops -> Html Msg
stopsView stops =
    let
        list =
            case stops of
                Stops value ->
                    value
    in
        MyCss.stops
            [ class "MyCss.Stops" ]
            (List.map stopView list)


stopView : Stop -> Html Msg
stopView stop =
    MyCss.stop
        [ class "MyCss.Stop" ]
        [ arrivalsView stop.arrivals ]


arrivalsView : Arrivals -> Html Msg
arrivalsView arrivals =
    let
        list =
            case arrivals of
                Arrivals value ->
                    value
    in
        MyCss.arrivals
            [ class "MyCss.Arrivals" ]
            (List.map (\arrival -> arrivalView arrival.parent.title arrival.minutes) list)


arrivalView : String -> Int -> Html Msg
arrivalView location minutes =
    MyCss.arrival
        [ class "MyCss.Arrival" ]
        [ styled span [ float left ] [ class "MyCss.Location" ] [ text location ]
        , styled span [ float right ] [ class "MyCss.Minutes" ] [ text (fromInt minutes) ]
        , styled div [ property "clear" "both" ] [ class "MyCss.Clearing" ] []
        ]
