module View.AgencyLogo exposing (view)

import MyCss exposing (..)
import Html exposing (Html, text, img)
import Html.Attributes exposing (src)
import Html.CssHelpers
import Model exposing (..)
import Bootstrap.Table exposing (Cell, td, cellAttr)


{ class, classList } =
    Html.CssHelpers.withNamespace "TransitTips"


view : String -> Html Msg
view url =
    img [ class [], src (absoluteUrl url) ] [] 


absoluteUrl : String -> String
absoluteUrl relative =
    "https://www.nextbus.com" ++ relative
