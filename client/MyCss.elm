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


css : Stylesheet
css =
    (stylesheet << namespace "TransitTips")
        [ body
            []
        , Css.Elements.table
            [ borderStyle hidden
            , descendants
                [ class Direction
                    [ width (pct 70) ]
                , class Arrival
                    [ width (pct 30) ]
                , class Route
                    [ borderStyle hidden
                    , descendants
                        [ class Title
                            [ fontSize (ex 2.5)
                            ]
                        ]
                    ]
                ]
            ]
        ]
