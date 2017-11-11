module View exposing (view)

import Html exposing (Html)
import Model exposing (..)
import View.Schedule


view : Model -> Html Msg
view model =
    View.Schedule.view model.schedule
