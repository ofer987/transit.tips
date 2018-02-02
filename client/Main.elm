module Main exposing (..)

import Html
import Init
import Model exposing (Model, Controller)
import Update exposing (update)
import View exposing (view)


-- INIT


main : Program Never Model Controller
main =
    Html.program
        { init = Init.init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Controller
subscriptions model =
    Sub.none
