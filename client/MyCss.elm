module MyCss exposing (..)

import Css exposing (..)
import Css.Elements exposing (body, table, tbody, span, td, th)
import Css.Colors exposing (gray, blue, black, purple, green)
import Css.Namespace exposing (namespace)


grey : Color
grey =
    gray


type CssClasses
    = Routes
    | Directions
    | Stops
    | Arrivals
    | Route
    | Title
    | Stop
    | Direction
    | Arrival
    | Location
    | Minutes
    | Clearing
    | Headings


css : Stylesheet
css =
    (stylesheet << namespace "TransitTips")
        [ body
            []
        , class Directions
            [ descendants
                [ class Direction
                    [ padding2 (px 5) (px 20)
                    ]
                ]
            ]
        , class Arrivals
            [ margin2 (px 5) (px 0)
            , descendants
                [ class Arrival
                    -- Remove
                    [ margin2 (px 20) (px 0)
                    , descendants
                        -- TODO: unnest
                        [ class Location
                            [ float left ]
                        , class Minutes
                            [ float right ]
                        ]
                    ]
                ]
            ]
        , class Clearing
            [ property "clear" "both" ]
        , class Headings
            [ margin4 (px 15) (px 0) (px 5) (px 0)
            , descendants
                [ class Direction
                    [ float left
                    , fontWeight bold
                    ]
                , class Arrival
                    [ float right
                    , fontWeight bold
                    ]
                ]
            ]
        ]
