module View.Search exposing (view, searchView)

import Model exposing (..)
import Model.Search
import String
import View.Alert.Error
import View.Schedule
import Html exposing (Html, div, text, input)
import Html.Attributes exposing (type_, defaultValue)
import Html.Events exposing (onInput)


view : Model.Search.Model -> Html Controller
view model =
    case model of
        Model.Search.Nil "" ->
            searchView

        Model.Search.Nil routeId ->
            div
                []
                [ searchView
                , text ("searching route " ++ routeId) 
                ]

        -- Note: Currently not used
        Model.Search.ReceivedRoute routeId schedule ->
            div
                []
                [ text ("searching route " ++ routeId) ]

        Model.Search.ReceivedPredictions schedule ->
            div
                []
                [ text "received predictions"
                , View.Schedule.view schedule.routes
                ]

        Model.Search.Error error ->
            div
                []
                [ View.Alert.Error.view error ]



-- view : Model -> Html Controller
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
-- TODO: add argument model


searchView : Html Controller
searchView =
    div
        []
        [ text "please search!"
        , input
            [ type_ "text"
            , defaultValue ""
            , onInput (\value -> (SearchController (String.trim value)))
            ]
            []
        ]



-- viewResults : Model -> Html Controller
-- viewResults model =
--     case model of
--         Nil ->
--             div [] []
--
--         ReceivedLocation latitude longitude ->
--             div [] [ text ("You are at " ++ toString latitude ++ ", " ++ toString longitude) ]
--
--         ReceivedRoute latitude longitude stops ->
--             div [] [ text ("You are at " ++ toString latitude ++ ", " ++ toString longitude ++ "found these stops [" ++ Stop.toString stops "" ++ "]") ]
--
--         ReceivedArrivals route ->
--             div [] [ text ("I have found route " ++ route.id ++ " arriving in " ++ routeToString route ++ " minutes") ]
--
--         Error value ->
--             div [] [ text ("Oh no! " ++ value) ]
-- routeToString : Route -> String
-- routeToString route =
--     case route.arrivals of
--         head :: _ ->
--             toString head.time
--
--         [] ->
--             "Not found"
-- searchView : Float -> Float -> Html Controller
-- searchView latitude longitude =
--     div
--         []
--         [ input (type_ "text", defaultValue "", onClick (SearchController (Search.GetLocation "ttc") )) ]
--


noSearchView : Html Controller
noSearchView =
    div [] []
