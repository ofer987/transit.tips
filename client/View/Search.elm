module View.Search exposing (view)

import Model exposing (ControllerMsg(..))
import Model.SearchResults as SearchResults exposing (Model(..), Msg(..))
import Model.Stop as Stop
import Model.Route exposing (Route)
import String
import Html exposing (Html, div, text, input)
import Html.Attributes exposing (type_, defaultValue)
import Html.Events exposing (onInput)


view : Model -> Html ControllerMsg
view model =
    div
        []
        [ viewSearch
        , viewResults model
        ]



-- view : Model -> Html ControllerMsg
-- view model =
--     case model.nearby of
--         Nearby.NoLocation ->
--             noSearchView
--
--         Nearby.ReceivedLocation latitude longitude ->
--             searchView latitude longitude
--
--         Nearby.ReceivedSchedule nearby ->
--             searchView nearby.latitude nearby.longitude
--
--         Nearby.ReceivedDate nearby _ ->
--             searchView nearby.latitude nearby.longitude
--
--         Nearby.Error _ ->
--             noSearchView


viewSearch : Html ControllerMsg
viewSearch =
    div
        []
        [ input
            [ type_ "text"
            , defaultValue ""
            , onInput (\value -> (SearchController (SearchResults.GetLocation (String.trim value))))
            ]
            []
        ]


viewResults : Model -> Html ControllerMsg
viewResults model =
    case model of
        NoLocation ->
            div [] []

        ReceivedLocation latitude longitude ->
            div [] [ text ("You are at " ++ toString latitude ++ ", " ++ toString longitude) ]

        ReceivedRoute latitude longitude stops ->
            div [] [ text ("You are at " ++ toString latitude ++ ", " ++ toString longitude ++ "found these stops [" ++ Stop.toString stops "" ++ "]") ]

        ReceivedArrivals route ->
            div [] [ text ("I have found route " ++ route.id ++ " arriving in " ++ routeToString route ++ " minutes") ]

        Error value ->
            div [] [ text ("Oh no! " ++ value) ]


routeToString : Route -> String
routeToString route =
    case route.arrivals of
        head :: _ ->
            toString head.time

        [] ->
            "Not found"



-- searchView : Float -> Float -> Html ControllerMsg
-- searchView latitude longitude =
--     div
--         []
--         [ input (type_ "text", defaultValue "", onClick (SearchController (SearchResults.GetLocation "ttc") )) ]
--


noSearchView : Html ControllerMsg
noSearchView =
    div [] []
