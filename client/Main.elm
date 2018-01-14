module Main exposing (..)

import Html
import Init
import Model exposing (Model, ControllerMsg)
import Update exposing (update)
import View exposing (view)


-- INIT


main : Program Never Model ControllerMsg
main =
    Html.program
        { init = Init.init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub ControllerMsg
subscriptions model =
    Sub.none
