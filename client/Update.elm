module Update exposing (update)

import Model exposing (..)
import Update.Location as Location
import Update.Nearby as Nearby
import Update.Search as Search
import Tuple
import Platform.Cmd


update : ControllerMsg -> Model -> ( Model, Cmd ControllerMsg )
update controller model =
    case controller of
        Initial controller ->
            case controller of
                Location ->
                    let
                        result =
                            Update.Location.update (Location.GetLocation 42) model.location

                        nextModel =
                            { model | location = Tuple.first result }

                        nextCmd =
                            Tuple.second result
                                |> Platform.Cmd.map LocationController
                    in
                        ( nextModel, nextCmd )
        LocationController msg ->
            let
                result =
                    Update.Location.update msg model.location

                nextModel =
                    { model | location = Tuple.first result }

                nextCmd =
                    Tuple.second result
                        |> Platform.Cmd.map LocationController
            in
                ( nextModel, nextCmd )

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
                    Update.Search.update msg model.search

                nextModel =
                    { model | search = Tuple.first result }

                nextCmd =
                    Tuple.second result
                        |> Platform.Cmd.map SearchController
            in
                ( nextModel, nextCmd )
