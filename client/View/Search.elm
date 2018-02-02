module View.Search exposing (view)

import Model exposing (Controller(..))
import Model.Common exposing (Route)
import Model.Search as Search exposing (Model)
import String
import Html exposing (Html, div, text, input)
import Html.Attributes exposing (type_, defaultValue)
import Html.Events exposing (onInput)


view : Model -> Html Controller
view model =
    div
        []
        [ viewSearch
        -- , viewResults model
        ]



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
viewSearch : Html Controller
viewSearch =
    div
        []
        [ input
            [ type_ "text"
            , defaultValue ""
            -- , onInput (\value -> (SearchController (Search.RequestRoute (Location 12.0 14.0) (String.trim value))))
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
