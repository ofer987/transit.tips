module View.Arrival exposing (view)

import MyCss exposing (..)
import Html exposing (Html, text)
import Html.CssHelpers
import Model exposing (..)
import Model.Arrival exposing (Arrival)
import View.AgencyLogo
import Bootstrap.Table exposing (Row, Cell, tr, td, cellAttr)


{ class, classList } =
    Html.CssHelpers.withNamespace "TransitTips"


view : String -> Arrival -> Row Msg
view agencyUrl arrival =
    tr
        []
        [ View.AgencyLogo.view agencyUrl
        , column arrival.title MyCss.Direction
        , column (toString arrival.time) MyCss.Arrival
        ]


column : String -> CssClasses -> Cell Msg
column value cls =
    td
        [ cellAttr (class [ cls ]) ]
        [ text value ]
