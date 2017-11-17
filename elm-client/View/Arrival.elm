module View.Arrival exposing (view)

import Html exposing (Html, text)
import Model exposing (..)
import Model.Arrival exposing (Arrival)
import Bootstrap.Table exposing (Row, Cell, tr, td)


view : Arrival -> Row Msg
view arrival =
    tr
        []
        [ column arrival.title
        , column arrival.time
        ]


column : a -> Cell Msg
column value =
    td
        []
        [ text (toString value) ]
