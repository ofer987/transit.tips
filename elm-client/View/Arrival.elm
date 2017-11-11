module View.Arrival exposing (view)

import Html exposing (Html, tr, td, text)
import Model exposing (..)
import Model.Arrival exposing (Arrival)

view : Arrival -> Html Msg
view arrival =
    tr
        []
        [ column arrival.title
        , column arrival.time
        ]

column : a -> Html Msg
column value =
    td
        []
        [ text (toString value) ]

