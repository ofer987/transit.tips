module RestBus.Main exposing (..)

import Browser
import Html.Styled exposing (toUnstyled)
import Init exposing (init)
import Model exposing (Model, Controller)
import Model.Common exposing (Location)
import Update exposing (update)
import View exposing (view)


-- INIT


main : Program Location Model Controller
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view >> toUnstyled
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Controller
subscriptions model =
    Sub.none
