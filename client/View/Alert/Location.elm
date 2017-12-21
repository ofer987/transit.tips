module View.Alert.Location exposing (view)

import Html exposing (Html, div, text)
import Time exposing (Time)
import Model exposing (..)
import Bootstrap.Alert as Alert


view : String -> Time -> Html Msg
view address time =
    Alert.info [ text (where_ address ++ " at " ++ when_ time) ]


where_ : String -> String
where_ address =
    "Schedule for " ++ address


when_ : Time -> String
when_ time =
    toString time
