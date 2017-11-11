module View.Arrival exposing (view)

import Html exposing (tr, td, text)
import Model.Arrival exposing (Arrival)

view : Route -> Html Msg
view route =
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

