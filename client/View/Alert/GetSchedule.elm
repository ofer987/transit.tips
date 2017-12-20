module View.Alert.GetSchedule exposing (view)

import Html exposing (Html, div, text)
import Model exposing (..)
import Bootstrap.Alert as Alert


view : Html Msg
view =
    Alert.info [ text ("Getting Schedule" ++ (dots 10 "")) ]


dots : Int -> String -> String
dots remaining result =
    if remaining > 0 then
        dots (remaining - 1) (result ++ ".")
    else
        result
