module Update exposing (update)

import Model exposing (..)
import Update.Nearby
import Update.SearchResults
import Tuple
import Platform.Cmd


update : ControllerMsg -> Model -> ( Model, Cmd ControllerMsg )
update controller model =
    case controller of
        NearbyController msg ->
            let
                result =
                    Update.Nearby.update msg model.nearby

                nextModel =
                    { model | nearby = Tuple.first result }

                nextCmd =
                    Tuple.second result
                        |> Platform.Cmd.map NearbyController
            in
                ( nextModel, nextCmd )

        SearchController msg ->
            let
                result =
                    Update.SearchResults.update msg model.search

                nextModel =
                    { model | search = Tuple.first result }

                nextCmd =
                    Tuple.second result
                        |> Platform.Cmd.map SearchController
            in
                ( nextModel, nextCmd )
