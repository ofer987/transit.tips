module View.Alert.Time exposing (view)

import Html exposing (Html, div, text, a)
import Html.Attributes exposing (href)
import Time exposing (Time)
import Strftime exposing (format)
import Model exposing (..)
import Bootstrap.Alert as Alert


view : Float -> Float -> Time -> Html Controller
view latitude longitude date =
    let
        mapsUrl =
            "https://www.google.com/maps/place/" ++ toString latitude ++ "," ++ toString longitude

        message =
            when_ date
    in
        a
            [ href mapsUrl ]
            [ Alert.info [ text message ] ]


when_ : Time -> String
when_ date =
    format "%H:%M:%S" date
