module View.Alert.Time exposing (view)

import Html exposing (Html, div, text, a)
import Html.Attributes exposing (href)
import Time exposing (Posix)
import Strftime exposing (format)
import Model exposing (..)
import Bootstrap.Alert as Alert
import String exposing (fromFloat)


view : Float -> Float -> Posix -> Html Controller
view latitude longitude date =
    let
        mapsUrl =
            "https://www.google.com/maps/place/" ++ fromFloat latitude ++ "," ++ fromFloat longitude

        message =
            when_ date
    in
        a
            [ href mapsUrl ]
            [ Alert.simpleInfo
                []
                [ text message ]
            ]


when_ : Posix -> String
when_ date =
    format "%H:%M:%S" Time.utc date
