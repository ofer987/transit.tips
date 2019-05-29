module MyCss exposing (..)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)


headings : List (Attribute msg) -> Html msg
headings attributes =
    styled div
        [ margin4 (px 15) (px 0) (px 5) (px 0) ]
        attributes
        [ styled span
            [ float left, fontWeight bold ]
            [ id "direction", class "MyCss.Direction" ]
            [ text "Direction" ]
        , styled span
            [ float right, fontWeight bold ]
            [ id "arrival", class "MyCss.Arrival" ]
            [ text "Arrival (in minutes)" ]
        , styled div
            [ Css.property "clear" "both" ]
            [ class "MyCss.Clearing" ]
            []
        ]


routes : List (Attribute msg) -> List (Html msg) -> Html msg
routes attributes children =
    styled div
        []
        attributes
        children


route : List (Attribute msg) -> List (Html msg) -> Html msg
route attributes children =
    styled div
        []
        attributes
        children


directions : List (Attribute msg) -> List (Html msg) -> Html msg
directions attributes children =
    styled div
        []
        attributes
        children


direction : List (Attribute msg) -> List (Html msg) -> Html msg
direction attributes children =
    styled div
        [ padding2 (px 5) (px 20) ]
        attributes
        children


stops : List (Attribute msg) -> List (Html msg) -> Html msg
stops attributes children =
    styled div
        []
        attributes
        children


stop : List (Attribute msg) -> List (Html msg) -> Html msg
stop attributes children =
    styled div
        []
        attributes
        children


arrivals : List (Attribute msg) -> List (Html msg) -> Html msg
arrivals attributes children =
    styled div
        [ margin2 (px 5) (px 0) ]
        attributes
        children


arrival : List (Attribute msg) -> List (Html msg) -> Html msg
arrival attributes children =
    styled div
        [ margin2 (px 20) (px 0) ]
        attributes
        children



-- direction : Html Msg
-- direction =
--     styled
-- css : Stylesheet
-- css =
--     (stylesheet << namespace "TransitTips")
--         [ body
--             []
--         , class Directions
--             [ descendants
--                 [ class Direction
--                     [ padding2 (px 5) (px 20)
--                     ]
--                 ]
--             ]
--         , class Arrivals
--             [ margin2 (px 5) (px 0)
--             , descendants
--                 [ class Arrival
--                     -- Remove
--                     [ margin2 (px 20) (px 0)
--                     , descendants
--                         -- TODO: unnest
--                         [ class Location
--                             [ float left ]
--                         , class Minutes
--                             [ float right ]
--                         ]
--                     ]
--                 ]
--             ]
--         , class Clearing
--             [ property "clear" "both" ]
--         , class Headings
--             [ margin4 (px 15) (px 0) (px 5) (px 0)
--             , descendants
--                 [ class Direction
--                     [ float left
--                     , fontWeight bold
--                     ]
--                 , class Arrival
--                     [ float right
--                     , fontWeight bold
--                     ]
--                 ]
--             ]
--         ]
