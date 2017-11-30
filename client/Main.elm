module Main exposing (..)

import Html
import Init
import Model exposing (Model, Msg)
import Update exposing (update)
import View exposing (view)


-- INIT


main : Program Never Model Msg
main =
    Html.program
        { init = Init.init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
