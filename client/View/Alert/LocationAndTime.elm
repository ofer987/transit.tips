module View.Alert.LocationAndTime exposing (view)

import Html exposing (Html, div, text, a)
import Html.Attributes exposing (href)
import Date exposing (Date)
import Strftime exposing (format)
import Model exposing (..)
import Bootstrap.Alert as Alert


view : Float -> Float -> String -> Date -> Html ControllerMsg
view latitude longitude address date =
    let
        mapsUrl =
            "https://www.google.com/maps/place/" ++ toString latitude ++ "," ++ toString longitude

        message =
            where_ address ++ " at " ++ when_ date
    in
        a
            [ href mapsUrl ]
            [ Alert.info [text message] ]


where_ : String -> String
where_ address =
    "Schedule for " ++ address


when_ : Date -> String
when_ date =
    format "%H:%M:%S" date
