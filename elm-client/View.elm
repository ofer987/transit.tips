module View exposing (view)

import Model exposing (..)
import View.Schedule


view : Model -> Html Msg
view model =
    View.Schedule.view model.schedule
