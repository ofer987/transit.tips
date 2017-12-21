module View.Alert.Location exposing (view)

import Html exposing (Html, div, text)
import Model exposing (..)
import Bootstrap.Alert as Alert


view : String -> Html Msg
view address =
    Alert.info [ text (where_ address) ]


where_ : String -> String
where_ address =
    "Schedule for " ++ address
