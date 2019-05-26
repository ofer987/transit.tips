module View.Alert.LocationAndTime exposing (view)

import Html exposing (Html, div, text, a)
import Html.Attributes exposing (href)
import Time exposing (Posix)
import Strftime exposing (format)
import Model exposing (..)
import Bootstrap.Alert as Alert
import String exposing (fromFloat)


view : Float -> Float -> String -> Posix -> Html Controller
view latitude longitude address date =
    let
        mapsUrl =
            "https://www.google.com/maps/place/" ++ fromFloat latitude ++ "," ++ fromFloat longitude

        message =
            where_ address ++ " at " ++ when_ date
    in
        a
            [ href mapsUrl ]
            [ Alert.simpleInfo
                []
                [ text message ]
            ]


where_ : String -> String
where_ address =
    "Schedule for " ++ address


when_ : Posix -> String
when_ date =
    format "%H:%M:%S" Time.utc date
