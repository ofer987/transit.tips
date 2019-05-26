module RestBus.Main exposing (..)

import Browser
import Html.Styled exposing (toUnstyled)
import Init exposing (init)
import Model exposing (Model, Msg)
import Model.Common exposing (Location)
import Update exposing (update)
import View exposing (view)


-- INIT


main : Program Location Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view >> toUnstyled
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
