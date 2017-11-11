module MyCss exposing (..)

import Css exposing (..)
import Css.Elements exposing (body, tbody, span)
import Css.Colors exposing (gray, blue, black, purple, green)
import Css.Namespace exposing (namespace)


grey : Color
grey =
    gray


type CssClasses
    = Route
    | Title


css : Stylesheet
css =
    (stylesheet << namespace "TransitTips")
        [ body
            []
        , tbody
            [ children
                [ class Route
                    [ borderStyle hidden
                    , children
                        [ span
                            [ children
                                [ class Title
                                    [ fontSize (ex 2.5)
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
